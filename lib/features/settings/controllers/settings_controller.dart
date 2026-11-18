import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/localization/locale_service.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_service.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final LocaleService _localeService = LocaleService.instance;
  final ThemeService _themeService = ThemeService.instance;

  final RxBool isArabic = false.obs;
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isArabic.value = _localeService.locale.languageCode == 'ar';
    isDarkMode.value = _themeService.isDarkMode;
  }

  Future<void> toggleLanguage(bool value) async {
    isArabic.value = value;
    await _localeService.changeLocale(
      value ? const Locale('ar') : const Locale('en'),
    );
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    _themeService.setDarkMode(value);
  }
}
