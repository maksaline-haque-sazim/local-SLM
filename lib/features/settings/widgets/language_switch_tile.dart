import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/features/settings/controllers/settings_controller.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:get/get.dart';

class LanguageSwitchTile extends GetView<SettingsController> {
  const LanguageSwitchTile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          TranslationKeys.settingsLanguageTitle.tr,
          style: AppTypography.getParagraphBold(isArabic),
        ),
        subtitle: Text(
          TranslationKeys.settingsLanguageSubtitle.tr,
          style: AppTypography.getParagraphSmallRegular(isArabic),
        ),
        trailing: Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.isArabic.value ? 'AR' : 'EN',
                style: AppTypography.getParagraphSmallBold(isArabic)
                    .copyWith(color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 8),
              Switch.adaptive(
                value: controller.isArabic.value,
                onChanged: controller.toggleLanguage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
