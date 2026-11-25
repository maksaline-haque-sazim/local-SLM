import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/domain/entitys/chat_message_entity.dart';
import 'package:flutter_getx_starter_template/shared/services/inference.service.dart';
import 'package:flutter_getx_starter_template/shared/services/model.service.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find();

  final ModelService _modelService = ModelService.instance;
  final InferenceService _inferenceService = InferenceService.instance;

  final TextEditingController promptController = TextEditingController();

  /// Messages of the current session, oldest first. Held in memory only.
  final RxList<ChatMessageEntity> messages = <ChatMessageEntity>[].obs;
  final RxBool isGenerating = false.obs;

  /// Drives the send button; kept in sync with the text field.
  final RxBool hasPrompt = false.obs;

  /// How many previous prompt/reply pairs are sent along with a new prompt.
  static const int _historyExchanges = 2;

  StreamSubscription<String>? _generation;
  int _nextMessageId = 0;

  Rx<ModelLoadStatus> get modelStatus => _modelService.status;
  RxDouble get copyProgress => _modelService.copyProgress;
  RxnString get modelErrorDetails => _modelService.errorDetails;

  bool get canSend =>
      hasPrompt.value &&
      !isGenerating.value &&
      modelStatus.value == ModelLoadStatus.ready;

  @override
  void onInit() {
    super.onInit();
    promptController.addListener(_onPromptChanged);
  }

  @override
  void onReady() {
    super.onReady();
    loadModel();
  }

  @override
  void onClose() {
    _generation?.cancel();
    _generation = null;
    promptController
      ..removeListener(_onPromptChanged)
      ..dispose();
    // Frees the model's memory when the chat page is left.
    _modelService.unloadModel();
    super.onClose();
  }

  Future<void> loadModel() => _modelService.loadModel();

  void sendPrompt() {
    if (!canSend) {
      return;
    }

    final prompt = promptController.text.trim();
    FocusManager.instance.primaryFocus?.unfocus();
    promptController.clear();

    // Taken before the new messages are added so it only holds past turns.
    final history = _recentHistory();

    messages.add(_newMessage(ChatMessageRole.user, prompt));
    final replyId = _nextMessageId;
    messages.add(_newMessage(ChatMessageRole.model, '', isLoading: true));
    isGenerating.value = true;

    final buffer = StringBuffer();
    _generation = _inferenceService
        .generate(prompt, history: history)
        .listen(
          (delta) {
            buffer.write(delta);
            _updateMessage(replyId, (message) {
              return message.copyWith(text: buffer.toString());
            });
          },
          onError: (Object error) {
            _updateMessage(replyId, (message) {
              return message.copyWith(isLoading: false, hasError: true);
            });
            isGenerating.value = false;
          },
          onDone: () {
            _updateMessage(replyId, (message) {
              return message.copyWith(isLoading: false);
            });
            isGenerating.value = false;
          },
          cancelOnError: true,
        );
  }

  /// Stops the reply in progress and keeps whatever was generated so far.
  Future<void> stopGeneration() async {
    await _generation?.cancel();
    _generation = null;
    isGenerating.value = false;

    // Keep whatever was generated; drop the reply if nothing came through.
    final last = messages.isEmpty ? null : messages.last;
    if (last != null && !last.isUser && last.isLoading) {
      if (last.text.isEmpty) {
        messages.removeLast();
      } else {
        messages[messages.length - 1] = last.copyWith(isLoading: false);
      }
    }
  }

  /// Stops any reply in progress and deletes every message.
  Future<void> resetConversation() async {
    await _generation?.cancel();
    _generation = null;
    isGenerating.value = false;
    messages.clear();
  }

  /// The last [_historyExchanges] completed prompt/reply pairs, oldest first.
  /// Pairs whose reply failed, was cancelled empty or is still running are
  /// skipped so the model never sees a dangling turn.
  List<ChatMessageEntity> _recentHistory() {
    final pairs = <List<ChatMessageEntity>>[];
    for (var i = 0; i < messages.length - 1; i++) {
      final prompt = messages[i];
      final reply = messages[i + 1];
      if (prompt.isUser &&
          !reply.isUser &&
          !reply.isLoading &&
          !reply.hasError &&
          reply.text.trim().isNotEmpty) {
        pairs.add([prompt, reply]);
        i++;
      }
    }
    return pairs.reversed
        .take(_historyExchanges)
        .toList()
        .reversed
        .expand((pair) => pair)
        .toList();
  }

  ChatMessageEntity _newMessage(
    ChatMessageRole role,
    String text, {
    bool isLoading = false,
  }) {
    return ChatMessageEntity(
      id: _nextMessageId++,
      role: role,
      text: text,
      isLoading: isLoading,
    );
  }

  void _updateMessage(
    int id,
    ChatMessageEntity Function(ChatMessageEntity message) update,
  ) {
    final index = messages.indexWhere((message) => message.id == id);
    if (index == -1) {
      return;
    }
    messages[index] = update(messages[index]);
  }

  void _onPromptChanged() {
    hasPrompt.value = promptController.text.trim().isNotEmpty;
  }
}
