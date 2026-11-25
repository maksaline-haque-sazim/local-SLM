import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/features/chat/controllers/chat_controller.dart';
import 'package:flutter_getx_starter_template/features/chat/widgets/chat_input_bar.dart';
import 'package:flutter_getx_starter_template/features/chat/widgets/chat_message_list.dart';
import 'package:flutter_getx_starter_template/features/chat/widgets/model_error_view.dart';
import 'package:flutter_getx_starter_template/features/chat/widgets/model_loading_view.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/shared/services/model.service.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:get/get.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.model.name,
          style: AppTypography.getHeading4(isArabic),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
        actions: [
          Obx(() {
            final canReset = controller.messages.isNotEmpty;
            return IconButton(
              tooltip: TranslationKeys.chatReset.tr,
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: canReset ? controller.resetConversation : null,
            );
          }),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          switch (controller.modelStatus.value) {
            case ModelLoadStatus.idle:
            case ModelLoadStatus.loading:
              return const ModelLoadingView();
            case ModelLoadStatus.error:
              return const ModelErrorView();
            case ModelLoadStatus.ready:
              return const Column(
                children: [
                  Expanded(child: ChatMessageList()),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      Sizes.md,
                      Sizes.sm,
                      Sizes.md,
                      Sizes.md,
                    ),
                    child: ChatInputBar(),
                  ),
                ],
              );
          }
        }),
      ),
    );
  }
}
