import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/localization/app_translations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleService extends GetxService {
  static LocaleService get instance => Get.find<LocaleService>();

  static const String _storageKey = 'app_locale';

  final GetStorage _box = GetStorage();

  late Locale _locale;

  Locale get locale => _locale;

  Future<LocaleService> init() async {
    final savedCode = _box.read<String>(_storageKey);
    _locale = _resolveLocale(savedCode);
    return this;
  }

  Future<void> changeLocale(Locale locale) async {
    if (!AppTranslations.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    )) {
      locale = AppTranslations.fallbackLocale;
    }

    _locale = locale;
    await _box.write(_storageKey, locale.languageCode);
    Get.updateLocale(locale);
  }

  Future<void> toggleLocale() async {
    final next = _locale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    await changeLocale(next);
  }

  Locale _resolveLocale(String? code) {
    if (code == null || code.isEmpty) {
      return AppTranslations.fallbackLocale;
    }

    return AppTranslations.supportedLocales.firstWhere(
      (locale) => locale.languageCode == code,
      orElse: () => AppTranslations.fallbackLocale,
    );
  }
}
