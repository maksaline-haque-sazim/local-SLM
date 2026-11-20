enum ChatMessageRole { user, model }

class ChatMessageEntity {
  final int id;
  final ChatMessageRole role;
  final String text;

  /// True while the model is still producing this message.
  final bool isLoading;
  final bool hasError;

  const ChatMessageEntity({
    required this.id,
    required this.role,
    required this.text,
    this.isLoading = false,
    this.hasError = false,
  });

  bool get isUser => role == ChatMessageRole.user;

  ChatMessageEntity copyWith({String? text, bool? isLoading, bool? hasError}) {
    return ChatMessageEntity(
      id: id,
      role: role,
      text: text ?? this.text,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }
}
