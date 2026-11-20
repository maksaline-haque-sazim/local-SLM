import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/features/chat/controllers/chat_controller.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';
import 'package:get/get.dart';

class ChatInputBar extends GetView<ChatController> {
  const ChatInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Obx(
            () => TextField(
              controller: controller.promptController,
              enabled: !controller.isGenerating.value,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => controller.sendPrompt(),
              style: AppTypography.getParagraphRegular(isArabic)
                  .copyWith(color: colors.onSurface),
              decoration: InputDecoration(
                hintText: TranslationKeys.chatInputHint.tr,
              ),
            ),
          ),
        ),
        const SizedBox(width: Sizes.sm),
        Obx(() {
          if (controller.isGenerating.value) {
            return IconButton.filled(
              onPressed: controller.stopGeneration,
              icon: const Icon(Icons.stop_rounded),
            );
          }
          return IconButton.filled(
            onPressed: controller.canSend ? controller.sendPrompt : null,
            icon: const Icon(Icons.arrow_upward_rounded),
          );
        }),
      ],
    );
  }
}
