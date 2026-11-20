import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/features/chat/controllers/chat_controller.dart';
import 'package:flutter_getx_starter_template/features/chat/widgets/message_bubble.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:get/get.dart';

class ChatMessageList extends GetView<ChatController> {
  const ChatMessageList({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Obx(() {
      final messages = controller.messages;

      if (messages.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  TranslationKeys.chatEmptyTitle.tr,
                  style: AppTypography.getHeading3(isArabic),
                ),
                const SizedBox(height: Sizes.sm),
                Text(
                  TranslationKeys.chatEmptySubtitle.tr,
                  textAlign: TextAlign.center,
                  style: AppTypography.getParagraphRegular(isArabic),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.separated(
        reverse: true,
        padding: const EdgeInsets.all(Sizes.md),
        itemCount: messages.length,
        separatorBuilder: (_, __) => const SizedBox(height: Sizes.sm),
        itemBuilder: (context, index) {
          final message = messages[messages.length - 1 - index];
          return MessageBubble(key: ValueKey(message.id), message: message);
        },
      );
    });
  }
}
