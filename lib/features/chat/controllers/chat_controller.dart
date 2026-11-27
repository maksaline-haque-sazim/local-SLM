import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/domain/entitys/chat_message_entity.dart';
import 'package:flutter_getx_starter_template/domain/entitys/generation_stats_entity.dart';
import 'package:flutter_getx_starter_template/domain/entitys/slm_model_entity.dart';
import 'package:flutter_getx_starter_template/shared/services/inference.service.dart';
import 'package:flutter_getx_starter_template/shared/services/model.service.dart';
import 'package:flutter_getx_starter_template/utils/constants/model_catalog.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find();

  final ModelService _modelService = ModelService.instance;
  final InferenceService _inferenceService = InferenceService.instance;

  /// The model chosen on the home page, passed as the route argument.
  final SlmModelEntity model = ModelCatalog.byId(Get.arguments as String?)!;

  final TextEditingController promptController = TextEditingController();

  /// Messages of the current session, oldest first. Held in memory only.
  final RxList<ChatMessageEntity> messages = <ChatMessageEntity>[].obs;
  final RxBool isGenerating = false.obs;

  /// Drives the send button; kept in sync with the text field.
  final RxBool hasPrompt = false.obs;

  /// How many previous prompt/reply pairs are sent along with a new prompt.
  static const int _historyExchanges = 2;

  StreamSubscription<InferenceEvent>? _generation;
  int _nextMessageId = 0;

  Rx<ModelLoadStatus> get modelStatus => _modelService.status;
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
    _modelService.unloadModel();
    super.onClose();
  }

  Future<void> loadModel() => _modelService.loadModel(model);

  void sendPrompt() {
    if (!canSend) {
      return;
    }

    final prompt = promptController.text.trim();
    FocusManager.instance.primaryFocus?.unfocus();
    promptController.clear();

    final history = _recentHistory(messages);

    messages.add(_newMessage(ChatMessageRole.user, prompt));
    final replyId = _nextMessageId;
    messages.add(_newMessage(ChatMessageRole.model, '', isLoading: true));

    _startGeneration(prompt, replyId, history);
  }

  bool canRegenerate(ChatMessageEntity message) {
    if (isGenerating.value ||
        modelStatus.value != ModelLoadStatus.ready ||
        messages.length < 2) {
      return false;
    }
    final last = messages.last;
    return last.id == message.id &&
        !last.isUser &&
        !last.isLoading &&
        messages[messages.length - 2].isUser;
  }

  void regenerate() {
    if (messages.length < 2 || !canRegenerate(messages.last)) {
      return;
    }

    final replyIndex = messages.length - 1;
    final prompt = messages[replyIndex - 1].text;
    final history = _recentHistory(messages.sublist(0, replyIndex - 1));
    final replyId = messages[replyIndex].id;

    messages[replyIndex] = messages[replyIndex].copyWith(
      text: '',
      isLoading: true,
      hasError: false,
      clearStats: true,
    );

    _startGeneration(prompt, replyId, history);
  }

  void _startGeneration(
    String prompt,
    int replyId,
    List<ChatMessageEntity> history,
  ) {
    isGenerating.value = true;

    final buffer = StringBuffer();
    GenerationStatsEntity? stats;
    _generation = _inferenceService
        .generate(prompt, history: history)
        .listen(
          (event) {
            stats = event.stats ?? stats;
            if (event.text.isEmpty) {
              return;
            }
            buffer.write(event.text);
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
              return message.copyWith(isLoading: false, stats: stats);
            });
            isGenerating.value = false;
          },
          cancelOnError: true,
        );
  }

  Future<void> stopGeneration() async {
    await _generation?.cancel();
    _generation = null;
    isGenerating.value = false;

    final last = messages.isEmpty ? null : messages.last;
    if (last != null && !last.isUser && last.isLoading) {
      if (last.text.isEmpty) {
        messages.removeLast();
      } else {
        messages[messages.length - 1] = last.copyWith(isLoading: false);
      }
    }
  }


  Future<void> resetConversation() async {
    await _generation?.cancel();
    _generation = null;
    isGenerating.value = false;
    messages.clear();
  }


  List<ChatMessageEntity> _recentHistory(List<ChatMessageEntity> source) {
    final pairs = <List<ChatMessageEntity>>[];
    for (var i = 0; i < source.length - 1; i++) {
      final prompt = source[i];
      final reply = source[i + 1];
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
