import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/features/products/controllers/create_product_controller.dart';
import 'package:flutter_getx_starter_template/features/products/widgets/create_product_form.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';
import 'package:get/get.dart';

class CreateProductPage extends GetView<CreateProductController> {
  const CreateProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          TranslationKeys.productsCreateTitle.tr,
          style: AppTypography.getHeading3(isArabic),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: Get.back,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.md,
            vertical: Sizes.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TranslationKeys.productsCreateSubtitle.tr,
                style: AppTypography.getParagraphRegular(isArabic).copyWith(
                  color: context.colors.onSurfaceVariant.withAlpha(150),
                ),
              ),
              const SizedBox(height: Sizes.lg),
              const CreateProductForm(),
            ],
          ),
        ),
      ),
    );
  }
}
