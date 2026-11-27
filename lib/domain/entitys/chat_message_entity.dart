import 'package:flutter_getx_starter_template/domain/entitys/generation_stats_entity.dart';

enum ChatMessageRole { user, model }

class ChatMessageEntity {
  final int id;
  final ChatMessageRole role;
  final String text;

  /// True while the model is still producing this message.
  final bool isLoading;
  final bool hasError;

  /// Speed of the finished reply; null for prompts and unfinished replies.
  final GenerationStatsEntity? stats;

  const ChatMessageEntity({
    required this.id,
    required this.role,
    required this.text,
    this.isLoading = false,
    this.hasError = false,
    this.stats,
  });

  bool get isUser => role == ChatMessageRole.user;

  ChatMessageEntity copyWith({
    String? text,
    bool? isLoading,
    bool? hasError,
    GenerationStatsEntity? stats,
    bool clearStats = false,
  }) {
    return ChatMessageEntity(
      id: id,
      role: role,
      text: text ?? this.text,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      stats: clearStats ? null : (stats ?? this.stats),
    );
  }
}
