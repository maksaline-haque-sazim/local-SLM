import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/features/auth/sign_up/controllers/sign_up_controller.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/shared/widgets/buttons/primary_button.dart';
import 'package:flutter_getx_starter_template/shared/widgets/input_widgets/core_text_field.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_colors.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';
import 'package:get/get.dart';

class SignUpForm extends GetView<SignUpController> {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final linkColor = Get.isDarkMode ? AppColors.info : AppColors.primary;

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CoreTextField(
            label: TranslationKeys.signUpNameLabel.tr,
            controller: controller.nameController,
            hintText: TranslationKeys.signUpNameHint.tr,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: Sizes.lg),
          CoreTextField(
            label: TranslationKeys.signUpEmailLabel.tr,
            controller: controller.emailController,
            hintText: TranslationKeys.signUpEmailHint.tr,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: Sizes.lg),
          Obx(
            () => CoreTextField(
              label: TranslationKeys.signUpPasswordLabel.tr,
              controller: controller.passwordController,
              hintText: TranslationKeys.signUpPasswordHint.tr,
              obscureText: !controller.isPasswordVisible.value,
              textInputAction: TextInputAction.next,
              suffixIcon: IconButton(
                onPressed: controller.togglePasswordVisibility,
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(height: Sizes.lg),
          Obx(
            () => CoreTextField(
              label: TranslationKeys.signUpConfirmPasswordLabel.tr,
              controller: controller.confirmPasswordController,
              hintText: TranslationKeys.signUpConfirmPasswordHint.tr,
              obscureText: !controller.isConfirmPasswordVisible.value,
              textInputAction: TextInputAction.done,
              suffixIcon: IconButton(
                onPressed: controller.toggleConfirmPasswordVisibility,
                icon: Icon(
                  controller.isConfirmPasswordVisible.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(height: Sizes.xl),
          Obx(
            () => PrimaryButton(
              label: TranslationKeys.signUpSubmit.tr,
              isArabic: isArabic,
              isLoading: controller.isSubmitting.value,
              onPressed: () => controller.submitSignUp(context),
            ),
          ),
          const SizedBox(height: Sizes.sm),
          TextButton(
            onPressed: controller.openLogin,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
            ),
            child: Text(
              TranslationKeys.signUpGoToLogin.tr,
              style: AppTypography.getParagraphSmallBold(isArabic)
                  .copyWith(color: linkColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
