import 'package:flutter_getx_starter_template/features/chat/controllers/chat_controller.dart';
import 'package:flutter_getx_starter_template/shared/services/inference.service.dart';
import 'package:flutter_getx_starter_template/shared/services/model.service.dart';
import 'package:get/get.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModelService>(() => ModelService());
    Get.lazyPut<InferenceService>(() => InferenceService());
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
