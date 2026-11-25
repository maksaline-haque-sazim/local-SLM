import 'package:flutter_getx_starter_template/domain/entitys/chat_message_entity.dart';
import 'package:flutter_getx_starter_template/shared/services/model.service.dart';
import 'package:get/get.dart';
import 'package:llamadart/llamadart.dart';

class InferenceService extends GetxService {
  static InferenceService get instance => Get.find<InferenceService>();

  static const GenerationParams _generationParams = GenerationParams(
    maxTokens: 1024,
    temp: 0.4,
    topP: 0.9,
  );

  final ModelService _modelService = ModelService.instance;

  Stream<String> generate(
    String prompt, {
    List<ChatMessageEntity> history = const [],
  }) {
    final engine = _modelService.engine;
    if (engine == null || !_modelService.isReady) {
      return Stream<String>.error(StateError('The model is not loaded yet.'));
    }

    final messages = [
      for (final message in history)
        LlamaChatMessage.fromText(
          role: message.isUser ? LlamaChatRole.user : LlamaChatRole.assistant,
          text: message.text,
        ),
      LlamaChatMessage.fromText(role: LlamaChatRole.user, text: prompt),
    ];

    return engine
        .create(messages, params: _generationParams, enableThinking: false)
        .textDeltas();
  }

  void cancel() {
    _modelService.engine?.cancelGeneration();
  }
}
