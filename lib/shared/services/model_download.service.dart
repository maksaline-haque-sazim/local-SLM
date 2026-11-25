import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_getx_starter_template/domain/entitys/slm_model_entity.dart';
import 'package:flutter_getx_starter_template/utils/constants/model_catalog.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

enum ModelDownloadStatus { notDownloaded, downloading, downloaded, failed }

class ModelDownloadState {
  const ModelDownloadState({
    this.status = ModelDownloadStatus.notDownloaded,
    this.progress = 0,
    this.error,
  });

  final ModelDownloadStatus status;

  /// 0..1. For a model that is not downloading, this is how much of a
  /// partial file already exists, so the download can be resumed.
  final double progress;
  final String? error;

  bool get isDownloading => status == ModelDownloadStatus.downloading;
  bool get isDownloaded => status == ModelDownloadStatus.downloaded;
}

/// Downloads, resumes, cancels and deletes model files in app storage.
///
/// Files are streamed to disk through Dio so they never sit in memory, which
/// is what makes models above 1 GB possible.
class ModelDownloadService extends GetxService {
  static ModelDownloadService get instance => Get.find<ModelDownloadService>();

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      // Applies between chunks, so a stalled connection fails instead of
      // hanging forever; the partial file is kept for resuming.
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  final RxMap<String, ModelDownloadState> states =
      <String, ModelDownloadState>{}.obs;

  final Map<String, CancelToken> _cancelTokens = {};
  Directory? _directory;

  Future<ModelDownloadService> init() async {
    final directory = await _modelsDirectory();
    for (final model in ModelCatalog.models) {
      final file = File('${directory.path}/${model.fileName}');
      if (await file.exists() && await file.length() == model.sizeBytes) {
        states[model.id] = const ModelDownloadState(
          status: ModelDownloadStatus.downloaded,
          progress: 1,
        );
        continue;
      }
      final partial = File('${file.path}.part');
      final partialBytes = await partial.exists() ? await partial.length() : 0;
      states[model.id] = ModelDownloadState(
        progress: (partialBytes / model.sizeBytes).clamp(0.0, 1.0).toDouble(),
      );
    }
    return this;
  }

  ModelDownloadState stateOf(SlmModelEntity model) {
    return states[model.id] ?? const ModelDownloadState();
  }

  bool isDownloaded(SlmModelEntity model) => stateOf(model).isDownloaded;

  Future<File> fileFor(SlmModelEntity model) async {
    final directory = await _modelsDirectory();
    return File('${directory.path}/${model.fileName}');
  }

  /// Starts (or resumes) the download. Completes when it finishes, fails or
  /// is cancelled; the outcome is published through [states].
  Future<void> download(SlmModelEntity model) async {
    if (stateOf(model).isDownloading || stateOf(model).isDownloaded) {
      return;
    }

    final file = await fileFor(model);
    final partial = File('${file.path}.part');
    final cancelToken = CancelToken();
    _cancelTokens[model.id] = cancelToken;

    var received = await partial.exists() ? await partial.length() : 0;
    if (received >= model.sizeBytes) {
      // A leftover that is not a valid partial download; start over.
      await partial.delete();
      received = 0;
    }
    _setState(
      model,
      ModelDownloadStatus.downloading,
      received / model.sizeBytes,
    );

    IOSink? sink;
    try {
      final response = await _dio.get<ResponseBody>(
        model.url,
        cancelToken: cancelToken,
        options: Options(
          responseType: ResponseType.stream,
          headers: received > 0 ? {'Range': 'bytes=$received-'} : null,
          validateStatus: (status) => status == 200 || status == 206,
        ),
      );

      // 200 means the server ignored the Range header: restart from zero.
      final resuming = response.statusCode == 206 && received > 0;
      if (!resuming) {
        received = 0;
      }

      sink = partial.openWrite(
        mode: resuming ? FileMode.append : FileMode.write,
      );
      var lastReported = -1;
      await for (final chunk in response.data!.stream) {
        sink.add(chunk);
        received += chunk.length;
        final permille = (received * 1000 ~/ model.sizeBytes).clamp(0, 1000);
        if (permille != lastReported) {
          lastReported = permille;
          _setState(
            model,
            ModelDownloadStatus.downloading,
            received / model.sizeBytes,
          );
        }
      }
      await sink.flush();
      await sink.close();
      sink = null;

      if (await partial.length() != model.sizeBytes) {
        throw const FileSystemException('The download was incomplete.');
      }
      await partial.rename(file.path);
      _setState(model, ModelDownloadStatus.downloaded, 1);
    } on DioException catch (error) {
      await _closeQuietly(sink);
      if (CancelToken.isCancel(error)) {
        // Cancelling keeps the partial file so the download can resume.
        _setState(
          model,
          ModelDownloadStatus.notDownloaded,
          await _partialProgress(partial, model),
        );
      } else {
        _fail(model, error.message ?? error.toString(), partial);
      }
    } catch (error) {
      await _closeQuietly(sink);
      _fail(model, error.toString(), partial);
    } finally {
      _cancelTokens.remove(model.id);
    }
  }

  void cancel(SlmModelEntity model) {
    _cancelTokens[model.id]?.cancel();
  }

  /// Removes the downloaded file and any partial download.
  Future<void> delete(SlmModelEntity model) async {
    cancel(model);
    final file = await fileFor(model);
    for (final target in [file, File('${file.path}.part')]) {
      if (await target.exists()) {
        await target.delete();
      }
    }
    _setState(model, ModelDownloadStatus.notDownloaded, 0);
  }

  Future<Directory> _modelsDirectory() async {
    final cached = _directory;
    if (cached != null) {
      return cached;
    }
    final support = await getApplicationSupportDirectory();
    final directory = Directory('${support.path}/models');
    await directory.create(recursive: true);
    return _directory = directory;
  }

  Future<double> _partialProgress(File partial, SlmModelEntity model) async {
    if (!await partial.exists()) {
      return 0;
    }
    return (await partial.length() / model.sizeBytes)
        .clamp(0.0, 1.0)
        .toDouble();
  }

  Future<void> _fail(SlmModelEntity model, String message, File partial) async {
    states[model.id] = ModelDownloadState(
      status: ModelDownloadStatus.failed,
      progress: await _partialProgress(partial, model),
      error: message,
    );
  }

  Future<void> _closeQuietly(IOSink? sink) async {
    try {
      await sink?.close();
    } catch (_) {}
  }

  void _setState(
    SlmModelEntity model,
    ModelDownloadStatus status,
    double progress,
  ) {
    states[model.id] = ModelDownloadState(status: status, progress: progress);
  }

  @override
  void onClose() {
    for (final token in _cancelTokens.values) {
      token.cancel();
    }
    _dio.close(force: true);
    super.onClose();
  }
}
