import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/routes.dart';
import 'package:flutter_getx_starter_template/shared/services/auth.service.dart';
import 'package:flutter_getx_starter_template/utils/constants/functions.dart';
import 'package:flutter_getx_starter_template/utils/theme/snackbar.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final AuthService _authService = AuthService.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isSubmitting = false.obs;
  final RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> submitLogin(BuildContext context) async {
    closeKeyboard(context);
    if (isSubmitting.value) {
      return;
    }

    try {
      isSubmitting.value = true;
      await _authService.login(
        email: emailController.text,
        password: passwordController.text,
      );
      Get.offAllNamed(Routes.home);
    } catch (_) {
      AppSnackbar.errorSnackBar(
        title: TranslationKeys.errorTitle.tr,
        message: TranslationKeys.loginErrorMessage.tr,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void openSignUp() {
    Get.toNamed(Routes.signUp);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
