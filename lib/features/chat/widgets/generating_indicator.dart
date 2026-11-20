import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';

/// Loading state shown in the output area while the model is generating.
class GeneratingIndicator extends StatelessWidget {
  const GeneratingIndicator({super.key, this.color});

  /// Defaults to the theme's body colour; pass the bubble's foreground colour
  /// when drawn on a coloured bubble.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final colors = context.colors;
    final tint = color ?? colors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${TranslationKeys.chatGenerating.tr}…',
          style: AppTypography.getParagraphSmallMedium(isArabic)
              .copyWith(color: color),
        ),
        const SizedBox(height: Sizes.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.xs),
          child: LinearProgressIndicator(
            minHeight: 3,
            color: tint,
            backgroundColor: tint.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }
}
