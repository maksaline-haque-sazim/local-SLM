import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';

class HomeHighlights extends StatelessWidget {
  const HomeHighlights({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final colors = context.colors;

    final highlights = [
      TranslationKeys.homeHighlightOffline.tr,
      TranslationKeys.homeHighlightPrivate.tr,
      TranslationKeys.homeHighlightModel.tr,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final highlight in highlights)
          Padding(
            padding: const EdgeInsets.only(bottom: Sizes.sm),
            child: Row(
              children: [
                Icon(Icons.check_rounded, size: 20, color: colors.primary),
                const SizedBox(width: Sizes.sm),
                Expanded(
                  child: Text(
                    highlight,
                    style: AppTypography.getParagraphMedium(isArabic),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
