import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/domain/entitys/chat_message_entity.dart';
import 'package:flutter_getx_starter_template/features/chat/widgets/generating_indicator.dart';
import 'package:flutter_getx_starter_template/features/chat/widgets/markdown_message.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final ChatMessageEntity message;

  static const double _radius = 20;
  static const double _tailRadius = 2;

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final colors = context.colors;
    final isUser = message.isUser;

    final backgroundColor = isUser
        ? colors.primary
        : colors.surfaceContainerHighest;
    final foregroundColor = isUser ? colors.onPrimary : colors.onSurface;

    return Align(
      alignment: isUser
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.8,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadiusDirectional.only(
              bottomStart: const Radius.circular(_radius),
              bottomEnd: const Radius.circular(_radius),
              topStart: Radius.circular(!isUser ? _tailRadius : _radius),
              topEnd: Radius.circular(isUser ? _tailRadius : _radius),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.md,
              vertical: Sizes.sm + Sizes.xs,
            ),
            child: _buildContent(isArabic, foregroundColor),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isArabic, Color foregroundColor) {
    if (message.isUser) {
      return SelectableText(
        message.text,
        style: AppTypography.getParagraphRegular(isArabic)
            .copyWith(color: foregroundColor),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.text.isNotEmpty)
          MarkdownMessage(data: message.text, color: foregroundColor),
        if (message.isLoading) ...[
          if (message.text.isNotEmpty) const SizedBox(height: Sizes.sm),
          GeneratingIndicator(color: foregroundColor),
        ],
        if (message.hasError)
          Text(
            TranslationKeys.chatGenerationError.tr,
            style: AppTypography.getParagraphSmallRegular(isArabic)
                .copyWith(color: foregroundColor),
          ),
      ],
    );
  }
}
