import 'package:flutter_getx_starter_template/domain/entitys/chat_message_entity.dart';
import 'package:flutter_getx_starter_template/domain/entitys/generation_stats_entity.dart';
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

  /// Streams the reply. Text arrives as deltas; the final event carries the
  /// [GenerationStatsEntity] reported by llamadart (token count and duration).
  Stream<InferenceEvent> generate(
    String prompt, {
    List<ChatMessageEntity> history = const [],
  }) {
    final engine = _modelService.engine;
    if (engine == null || !_modelService.isReady) {
      return Stream<InferenceEvent>.error(
        StateError('The model is not loaded yet.'),
      );
    }

    final messages = [
      for (final message in history)
        LlamaChatMessage.fromText(
          role: message.isUser ? LlamaChatRole.user : LlamaChatRole.assistant,
          text: message.text,
        ),
      LlamaChatMessage.fromText(role: LlamaChatRole.user, text: prompt),
    ];

    final stopwatch = Stopwatch()..start();
    return engine
        .create(messages, params: _generationParams, enableThinking: false)
        .map((chunk) {
          final usage = chunk.usage;
          GenerationStatsEntity? stats;
          if (usage != null) {
            stats = GenerationStatsEntity(
              completionTokens: usage.completionTokens,
              // Falls back to wall-clock time if the backend gave no duration.
              duration: usage.duration ?? stopwatch.elapsed,
            );
          }
          return InferenceEvent(text: chunk.text, stats: stats);
        });
  }

  void cancel() {
    _modelService.engine?.cancelGeneration();
  }
}


class InferenceEvent {
  const InferenceEvent({this.text = '', this.stats});

  final String text;
  final GenerationStatsEntity? stats;
}
