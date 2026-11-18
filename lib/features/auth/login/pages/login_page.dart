import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/features/auth/login/controllers/login_controller.dart';
import 'package:flutter_getx_starter_template/features/auth/login/widgets/login_form.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/shared/widgets/core_global_widgets/app_logo_tile.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.md,
            vertical: Sizes.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppLogoTile(size: 128),
              Text(
                TranslationKeys.loginTitle.tr,
                style: AppTypography.getHeading2(isArabic),
              ),
              const SizedBox(height: Sizes.sm),
              Text(
                TranslationKeys.loginSubtitle.tr,
                style: AppTypography.getParagraphRegular(isArabic).copyWith(
                  color: context.colors.onSurfaceVariant.withAlpha(150),
                ),
              ),
              const SizedBox(height: Sizes.xl),
              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
