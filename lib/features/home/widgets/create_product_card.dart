import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/features/home/controllers/home_controller.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/shared/widgets/buttons/primary_button.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';
import 'package:get/get.dart';

class CreateProductCard extends GetView<HomeController> {
  const CreateProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Sizes.md),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withAlpha(80),
        borderRadius: BorderRadius.circular(Sizes.md),
        border: Border.all(
          color: colors.outlineVariant.withAlpha(120),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            TranslationKeys.productsCreateTitle.tr,
            style: AppTypography.getHeading3(isArabic),
          ),
          const SizedBox(height: Sizes.sm),
          Text(
            TranslationKeys.productsCreateSubtitle.tr,
            style: AppTypography.getParagraphRegular(isArabic).copyWith(
              color: colors.onSurfaceVariant.withAlpha(150),
            ),
          ),
          const SizedBox(height: Sizes.lg),
          PrimaryButton(
            label: TranslationKeys.drawerCreateProduct.tr,
            isArabic: isArabic,
            onPressed: controller.openCreateProduct,
          ),
        ],
      ),
    );
  }
}
