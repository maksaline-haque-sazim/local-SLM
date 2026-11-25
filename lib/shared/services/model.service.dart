import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_getx_starter_template/utils/constants/app_assets.dart';
import 'package:get/get.dart';
import 'package:llamadart/llamadart.dart';
import 'package:path_provider/path_provider.dart';

enum ModelLoadStatus { idle, preparing, loading, ready, error }

class ModelService extends GetxService {
  static const MethodChannel _assetChannel = MethodChannel(
    'local_slm/asset_copier',
  );

  static ModelService get instance => Get.find<ModelService>();

  static const String _modelAsset = AppAssets.smolLm2Model;

  static const ModelParams _modelParams = ModelParams(
    contextSize: 2048,
    gpuLayers: 0,
  );

  final Rx<ModelLoadStatus> status = ModelLoadStatus.idle.obs;

  final RxDouble copyProgress = 0.0.obs;
  final RxnString errorDetails = RxnString();

  LlamaEngine? _engine;
  Future<void>? _loading;
  Future<void>? _unloading;

  int _generation = 0;

  LlamaEngine? get engine => _engine;

  bool get isReady => status.value == ModelLoadStatus.ready && _engine != null;

  Future<void> loadModel() {
    return _loading ??= _loadModel().whenComplete(() => _loading = null);
  }

  Future<void> unloadModel() {
    return _unloading ??= _unloadModel().whenComplete(() => _unloading = null);
  }

  Future<void> _loadModel() async {
    await _unloading;
    if (isReady) {
      return;
    }

    final generation = _generation;
    errorDetails.value = null;
    copyProgress.value = 0;

    try {
      status.value = ModelLoadStatus.preparing;
      final modelPath = await _prepareModelFile();
      _throwIfStale(generation);

      status.value = ModelLoadStatus.loading;
      final engine = await LlamaEngine.load(
        LlamaModel(ModelSource.path(modelPath)),
        params: _modelParams,
      );

      if (generation != _generation) {
        await engine.dispose();
        return;
      }

      _engine = engine;
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
    status.value = ModelLoadStatus.idle;
    copyProgress.value = 0;
    await engine?.dispose();
  }

  void _throwIfStale(int generation) {
    if (generation != _generation) {
      throw const _StaleLoad();
    }
  }

  Future<String> _prepareModelFile() async {
    final directory = await getApplicationSupportDirectory();
    final fileName = _modelAsset.split('/').last;
    final modelFile = File('${directory.path}/$fileName');

    if (await modelFile.exists()) {
      copyProgress.value = 1;
      return modelFile.path;
    }

    final partialFile = File('${modelFile.path}.part');
    try {
      await _copyAssetNatively(_modelAsset, partialFile.path);
    } catch (_) {
      if (await partialFile.exists()) {
        await partialFile.delete();
      }
      rethrow;
    }

    await partialFile.rename(modelFile.path);
    return modelFile.path;
  }

  Future<void> _copyAssetNatively(String asset, String destination) async {
    _assetChannel.setMethodCallHandler((call) async {
      if (call.method == 'progress') {
        final arguments = call.arguments as Map<Object?, Object?>;
        copyProgress.value = (arguments['fraction'] as num).toDouble();
      }
    });
    try {
      await _assetChannel.invokeMethod<void>('copyAsset', {
        'asset': asset,
        'destination': destination,
      });
      copyProgress.value = 1;
    } finally {
      _assetChannel.setMethodCallHandler(null);
    }
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
