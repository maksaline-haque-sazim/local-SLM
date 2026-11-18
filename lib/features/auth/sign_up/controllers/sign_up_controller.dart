import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/routes.dart';
import 'package:flutter_getx_starter_template/shared/services/auth.service.dart';
import 'package:flutter_getx_starter_template/utils/constants/functions.dart';
import 'package:flutter_getx_starter_template/utils/theme/snackbar.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final AuthService _authService = AuthService.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxBool isSubmitting = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> submitSignUp(BuildContext context) async {
    closeKeyboard(context);
    if (isSubmitting.value) {
      return;
    }

    try {
      isSubmitting.value = true;
      await _authService.signUp(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
      Get.offAllNamed(Routes.home);
    } catch (_) {
      AppSnackbar.errorSnackBar(
        title: TranslationKeys.errorTitle.tr,
        message: TranslationKeys.signUpErrorMessage.tr,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void openLogin() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
