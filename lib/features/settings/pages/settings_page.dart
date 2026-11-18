import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/features/settings/controllers/settings_controller.dart';
import 'package:flutter_getx_starter_template/features/settings/widgets/language_switch_tile.dart';
import 'package:flutter_getx_starter_template/features/settings/widgets/theme_switch_tile.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:get/get.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          TranslationKeys.settingsTitle.tr,
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
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.md,
          vertical: Sizes.sm,
        ),
        children: const [
          LanguageSwitchTile(),
          SizedBox(height: Sizes.md),
          ThemeSwitchTile(),
        ],
      ),
    );
  }
}
