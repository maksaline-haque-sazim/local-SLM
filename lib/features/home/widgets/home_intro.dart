import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';

class HomeIntro extends StatelessWidget {
  const HomeIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TranslationKeys.homeHeadline.tr,
          style: AppTypography.getHeading1(isArabic),
        ),
        const SizedBox(height: Sizes.md),
        Text(
          TranslationKeys.homeSubtitle.tr,
          style: AppTypography.getParagraphLargeRegular(isArabic)
              .copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
