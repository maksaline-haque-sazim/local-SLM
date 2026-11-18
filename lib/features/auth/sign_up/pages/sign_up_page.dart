import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/features/auth/sign_up/controllers/sign_up_controller.dart';
import 'package:flutter_getx_starter_template/features/auth/sign_up/widgets/sign_up_form.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/shared/widgets/core_global_widgets/app_logo_tile.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';
import 'package:get/get.dart';

class SignUpPage extends GetView<SignUpController> {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: Get.back,
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.md,
            vertical: Sizes.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppLogoTile(size: 128),
              Text(
                TranslationKeys.signUpTitle.tr,
                style: AppTypography.getHeading2(isArabic),
              ),
              const SizedBox(height: Sizes.sm),
              Text(
                TranslationKeys.signUpSubtitle.tr,
                style: AppTypography.getParagraphRegular(isArabic).copyWith(
                  color: context.colors.onSurfaceVariant.withAlpha(150),
                ),
              ),
              const SizedBox(height: Sizes.xl),
              const SignUpForm(),
            ],
          ),
        ),
      ),
    );
  }
}
