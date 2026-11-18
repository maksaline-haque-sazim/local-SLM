import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/data/dto_models/create_product_dto.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/shared/services/product.service.dart';
import 'package:flutter_getx_starter_template/utils/constants/functions.dart';
import 'package:flutter_getx_starter_template/utils/theme/snackbar.dart';
import 'package:flutter_getx_starter_template/utils/validators.dart';
import 'package:get/get.dart';

class CreateProductController extends GetxController {
  static CreateProductController get instance => Get.find();

  final ProductService _productService = ProductService.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  final RxBool isSubmitting = false.obs;

  String? validateName(String? value) => Validators.minLength(value, 2);

  String? validateDescription(String? value) => Validators.minLength(value, 5);

  String? validatePrice(String? value) => Validators.positiveNumber(value);

  String? validateStock(String? value) => Validators.nonNegativeInteger(value);

  Future<void> submitProduct(BuildContext context) async {
    closeKeyboard(context);

    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid || isSubmitting.value) {
      return;
    }

    try {
      isSubmitting.value = true;

      final dto = CreateProductDto(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        price: double.parse(priceController.text.trim().replaceAll(',', '')),
        stock: int.parse(stockController.text.trim()),
      );

      await _productService.createProduct(dto);

      AppSnackbar.successSnackBar(
        title: TranslationKeys.productsCreateSuccessTitle.tr,
        message: TranslationKeys.productsCreateSuccessMessage.tr,
      );

      Get.back(result: true);
    } catch (e) {
      AppSnackbar.errorSnackBar(
        title: TranslationKeys.errorTitle.tr,
        message: TranslationKeys.productsCreateErrorMessage.tr,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.onClose();
  }
}
