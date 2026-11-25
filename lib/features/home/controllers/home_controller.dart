import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/domain/entitys/slm_model_entity.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/routes.dart';
import 'package:flutter_getx_starter_template/shared/services/model_download.service.dart';
import 'package:flutter_getx_starter_template/utils/constants/model_catalog.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final ModelDownloadService _downloads = ModelDownloadService.instance;

  List<SlmModelEntity> get models => ModelCatalog.models;

  /// Reactive: reading it inside an `Obx` rebuilds on download progress.
  ModelDownloadState stateOf(SlmModelEntity model) => _downloads.stateOf(model);

  void download(SlmModelEntity model) {
    _downloads.download(model);
  }

  void cancelDownload(SlmModelEntity model) {
    _downloads.cancel(model);
  }

  Future<void> confirmDelete(SlmModelEntity model) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text(TranslationKeys.homeDeleteTitle.tr),
        content: Text(
          TranslationKeys.homeDeleteMessage.trParams({'name': model.name}),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(TranslationKeys.homeCancel.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(TranslationKeys.homeDelete.tr),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _downloads.delete(model);
    }
  }

  void openChat(SlmModelEntity model) {
    Get.toNamed(Routes.chat, arguments: model.id);
  }
}
