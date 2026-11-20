import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/features/chat/controllers/chat_controller.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/shared/widgets/buttons/primary_button.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';
import 'package:get/get.dart';

class ModelErrorView extends GetView<ChatController> {
  const ModelErrorView({super.key});

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
              TranslationKeys.chatLoadErrorTitle.tr,
              textAlign: TextAlign.center,
              style: AppTypography.getHeading4(isArabic)
                  .copyWith(color: colors.error),
            ),
            const SizedBox(height: Sizes.sm),
            Obx(
              () => Text(
                controller.modelErrorDetails.value ?? '',
                textAlign: TextAlign.center,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.getParagraphSmallRegular(isArabic),
              ),
            ),
            const SizedBox(height: Sizes.lg),
            PrimaryButton(
              label: TranslationKeys.chatRetry.tr,
              isArabic: isArabic,
              onPressed: controller.loadModel,
            ),
          ],
        ),
      ),
    );
  }
}
