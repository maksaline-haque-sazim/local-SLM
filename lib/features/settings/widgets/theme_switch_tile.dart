import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/features/settings/controllers/settings_controller.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:get/get.dart';

class ThemeSwitchTile extends GetView<SettingsController> {
  const ThemeSwitchTile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          TranslationKeys.settingsThemeTitle.tr,
          style: AppTypography.getParagraphBold(isArabic),
        ),
        subtitle: Text(
          TranslationKeys.settingsThemeSubtitle.tr,
          style: AppTypography.getParagraphSmallRegular(isArabic),
        ),
        trailing: Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                controller.isDarkMode.value
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Switch.adaptive(
                value: controller.isDarkMode.value,
                onChanged: controller.toggleTheme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
