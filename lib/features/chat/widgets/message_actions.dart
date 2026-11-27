import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getx_starter_template/domain/entitys/chat_message_entity.dart';
import 'package:flutter_getx_starter_template/features/chat/controllers/chat_controller.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:get/get.dart';

/// Speed figures plus copy and regenerate buttons under a finished reply.
class MessageActions extends GetView<ChatController> {
  const MessageActions({super.key, required this.message, required this.color});

  final ChatMessageEntity message;
  final Color color;

  static const double _iconSize = 18;

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final stats = message.stats;
    final muted = color.withValues(alpha: 0.7);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (stats != null)
          Text(
            TranslationKeys.chatStats.trParams({
              'rate': stats.tokensPerMinute.round().toString(),
              'time': stats.durationLabel,
            }),
            style: AppTypography.getParagraphMiniRegular(isArabic)
                .copyWith(color: muted),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ActionButton(
              icon: Icons.copy_rounded,
              tooltip: TranslationKeys.chatCopy.tr,
              color: muted,
              onPressed: message.text.isEmpty ? null : () => _copy(context),
            ),
            Obx(
              () => _ActionButton(
                icon: Icons.refresh_rounded,
                tooltip: TranslationKeys.chatRegenerate.tr,
                color: muted,
                onPressed: controller.canRegenerate(message)
                    ? controller.regenerate
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: message.text));
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(TranslationKeys.chatCopied.tr),
          duration: const Duration(seconds: 2),
        ),
      );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: MessageActions._iconSize),
      color: color,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(Sizes.xs),
      constraints: const BoxConstraints(),
    );
  }
}
