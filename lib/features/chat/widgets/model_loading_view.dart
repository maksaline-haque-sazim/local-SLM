import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';

class ModelLoadingView extends StatelessWidget {
  const ModelLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              TranslationKeys.chatLoadingModel.tr,
              textAlign: TextAlign.center,
              style: AppTypography.getParagraphLargeMedium(isArabic)
                  .copyWith(color: colors.onSurface),
            ),
            const SizedBox(height: Sizes.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.xs),
              // Loading into memory reports no progress, so it is indeterminate.
              child: LinearProgressIndicator(
                minHeight: Sizes.xs,
                color: colors.primary,
                backgroundColor: colors.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: Sizes.md),
            Text(
              TranslationKeys.chatLoadingHint.tr,
              textAlign: TextAlign.center,
              style: AppTypography.getParagraphSmallRegular(isArabic),
            ),
          ],
        ),
      ),
    );
  }
}
