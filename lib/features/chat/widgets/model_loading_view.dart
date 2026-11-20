import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/features/chat/controllers/chat_controller.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/shared/services/model.service.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';
import 'package:get/get.dart';

class ModelLoadingView extends GetView<ChatController> {
  const ModelLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.lg),
        child: Obx(() {
          final isPreparing =
              controller.modelStatus.value == ModelLoadStatus.preparing;
          final progress = controller.copyProgress.value;

          final label = isPreparing
              ? '${TranslationKeys.chatPreparingModel.tr} '
                    '${(progress * 100).round()}%'
              : TranslationKeys.chatLoadingModel.tr;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTypography.getParagraphLargeMedium(isArabic)
                    .copyWith(color: colors.onSurface),
              ),
              const SizedBox(height: Sizes.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(Sizes.xs),
                child: LinearProgressIndicator(
                  // Determinate while the file is copied; the native load that
                  // follows reports no progress, so it stays indeterminate.
                  value: isPreparing ? progress : null,
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
          );
        }),
      ),
    );
  }
}
