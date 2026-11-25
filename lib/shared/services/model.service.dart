import 'package:flutter_getx_starter_template/domain/entitys/slm_model_entity.dart';
import 'package:flutter_getx_starter_template/shared/services/model_download.service.dart';
import 'package:get/get.dart';
import 'package:llamadart/llamadart.dart';

enum ModelLoadStatus { idle, loading, ready, error }

class ModelService extends GetxService {
  static ModelService get instance => Get.find<ModelService>();

  static const ModelParams _modelParams = ModelParams(
    contextSize: 2048,
    gpuLayers: 0,
  );

  final Rx<ModelLoadStatus> status = ModelLoadStatus.idle.obs;

  final RxnString errorDetails = RxnString();

  SlmModelEntity? _loadedModel;
  LlamaEngine? _engine;
  Future<void>? _loading;
  Future<void>? _unloading;

  int _generation = 0;

  LlamaEngine? get engine => _engine;

  bool get isReady => status.value == ModelLoadStatus.ready && _engine != null;

  Future<void> loadModel(SlmModelEntity model) {
    return _loading ??= _loadModel(model).whenComplete(() => _loading = null);
  }

  Future<void> unloadModel() {
    return _unloading ??= _unloadModel().whenComplete(() => _unloading = null);
  }

  Future<void> _loadModel(SlmModelEntity model) async {
    await _unloading;
    if (isReady && _loadedModel?.id == model.id) {
      return;
    }
    if (isReady) {
      // A different model is in memory; free it before loading this one.
      await _unloadModel();
    }

    final generation = _generation;
    errorDetails.value = null;

    try {
      status.value = ModelLoadStatus.loading;
      final modelPath = await _resolveModelPath(model);
      _throwIfStale(generation);

      final engine = await LlamaEngine.load(
        LlamaModel(ModelSource.path(modelPath)),
        params: _modelParams,
      );

      if (generation != _generation) {
        await engine.dispose();
        return;
      }

      _engine = engine;
      _loadedModel = model;
      status.value = ModelLoadStatus.ready;
    } on _StaleLoad {
      //TODO: The page was left while loading; unloadModel already reset the state.
    } catch (error) {
      errorDetails.value = error.toString();
      status.value = ModelLoadStatus.error;
    }
  }

  Future<void> _unloadModel() async {
    _generation++;
    final engine = _engine;
    _engine = null;
    _loadedModel = null;
    status.value = ModelLoadStatus.idle;
    await engine?.dispose();
  }

  void _throwIfStale(int generation) {
    if (generation != _generation) {
      throw const _StaleLoad();
    }
  }

  Future<String> _resolveModelPath(SlmModelEntity model) async {
    final downloads = ModelDownloadService.instance;
    final file = await downloads.fileFor(model);
    if (!downloads.isDownloaded(model) || !await file.exists()) {
      throw StateError('${model.name} has not been downloaded yet.');
    }
    return file.path;
  }

  @override
  void onClose() {
    unloadModel();
    super.onClose();
  }
}

class _StaleLoad implements Exception {
  const _StaleLoad();
}
