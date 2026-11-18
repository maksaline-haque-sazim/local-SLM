import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/features/products/controllers/create_product_controller.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/shared/widgets/buttons/primary_button.dart';
import 'package:flutter_getx_starter_template/shared/widgets/input_widgets/amount_input_field.dart';
import 'package:flutter_getx_starter_template/shared/widgets/input_widgets/core_text_field.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:get/get.dart';

class CreateProductForm extends GetView<CreateProductController> {
  const CreateProductForm({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CoreTextField(
            label: TranslationKeys.productsNameLabel.tr,
            controller: controller.nameController,
            hintText: TranslationKeys.productsNameHint.tr,
            validator: controller.validateName,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: Sizes.md),
          CoreTextField(
            label: TranslationKeys.productsDescriptionLabel.tr,
            controller: controller.descriptionController,
            hintText: TranslationKeys.productsDescriptionHint.tr,
            validator: controller.validateDescription,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: 4,
          ),
          const SizedBox(height: Sizes.md),
          AmountInputField(
            label: TranslationKeys.productsPriceLabel.tr,
            controller: controller.priceController,
            hintText: TranslationKeys.productsPriceHint.tr,
            validator: controller.validatePrice,
          ),
          const SizedBox(height: Sizes.md),
          CoreTextField(
            label: TranslationKeys.productsStockLabel.tr,
            controller: controller.stockController,
            hintText: TranslationKeys.productsStockHint.tr,
            validator: controller.validateStock,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: Sizes.lg),
          Obx(
            () => PrimaryButton(
              label: TranslationKeys.productsCreateSubmit.tr,
              isArabic: isArabic,
              isLoading: controller.isSubmitting.value,
              onPressed: () => controller.submitProduct(context),
            ),
          ),
          SizedBox(height: bottomInset + Sizes.md),
        ],
      ),
    );
  }
}
