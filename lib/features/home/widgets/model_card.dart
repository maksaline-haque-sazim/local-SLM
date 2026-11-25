import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/domain/entitys/slm_model_entity.dart';
import 'package:flutter_getx_starter_template/features/home/controllers/home_controller.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/shared/services/model_download.service.dart';
import 'package:flutter_getx_starter_template/shared/widgets/buttons/primary_button.dart';
import 'package:flutter_getx_starter_template/shared/widgets/buttons/secondary_button.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';
import 'package:get/get.dart';

class ModelCard extends GetView<HomeController> {
  const ModelCard({super.key, required this.model});

  final SlmModelEntity model;

  static const double _buttonHeight = 44;

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(Sizes.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.md),
        child: Obx(() {
          final state = controller.stateOf(model);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                model.name,
                style: AppTypography.getParagraphLargeBold(isArabic),
              ),
              const SizedBox(height: Sizes.xs),
              Text(
                '${model.parameters}  ·  ${model.sizeLabel}',
                style: AppTypography.getParagraphSmallRegular(isArabic)
                    .copyWith(color: colors.onSurfaceVariant),
              ),
              if (state.status == ModelDownloadStatus.failed) ...[
                const SizedBox(height: Sizes.sm),
                Text(
                  TranslationKeys.homeDownloadFailed.tr,
                  style: AppTypography.getParagraphSmallRegular(isArabic)
                      .copyWith(color: colors.error),
                ),
              ],
              const SizedBox(height: Sizes.md),
              _buildAction(context, state, isArabic),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildAction(
    BuildContext context,
    ModelDownloadState state,
    bool isArabic,
  ) {
    final colors = context.colors;

    if (state.isDownloading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Sizes.xs),
            child: LinearProgressIndicator(
              value: state.progress,
              minHeight: Sizes.xs,
              color: colors.primary,
              backgroundColor: colors.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: Sizes.sm),
          Row(
            children: [
              Text(
                '${(state.progress * 100).floor()}%',
                style: AppTypography.getParagraphSmallMedium(isArabic),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => controller.cancelDownload(model),
                child: Text(TranslationKeys.homeCancel.tr),
              ),
            ],
          ),
        ],
      );
    }

    if (state.isDownloaded) {
      return Row(
        children: [
          Expanded(
            child: PrimaryButton(
              label: TranslationKeys.homeChat.tr,
              isArabic: isArabic,
              height: _buttonHeight,
              onPressed: () => controller.openChat(model),
            ),
          ),
          const SizedBox(width: Sizes.sm),
          IconButton(
            tooltip: TranslationKeys.homeDelete.tr,
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => controller.confirmDelete(model),
          ),
        ],
      );
    }

    final hasPartial = state.progress > 0;
    return SecondaryButton(
      label: hasPartial
          ? '${TranslationKeys.homeResume.tr} (${(state.progress * 100).floor()}%)'
          : TranslationKeys.homeDownload.tr,
      isArabic: isArabic,
      height: _buttonHeight,
      leading: const Icon(Icons.download_rounded, size: 20),
      onPressed: () => controller.download(model),
    );
  }
}
