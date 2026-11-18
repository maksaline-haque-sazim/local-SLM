import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxService {
  static ThemeService get instance => Get.find<ThemeService>();

  static const String _storageKey = 'isDarkMode';

  final GetStorage _box = GetStorage();

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode =>
      _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<ThemeService> init() async {
    _isDarkMode = _box.read<bool>(_storageKey) ?? false;
    return this;
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    _box.write(_storageKey, value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    setDarkMode(!_isDarkMode);
  }
}
