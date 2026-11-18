import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_colors.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static const int _defaultSnackbarSeconds = 3;

  static void _showSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required int durationSeconds,
  }) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: textColor,
      backgroundColor: backgroundColor,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: durationSeconds),
      snackStyle: SnackStyle.GROUNDED,
      margin: EdgeInsets.zero,
      mainButton: TextButton(
        onPressed: () {
          if (Get.isSnackbarOpen) {
            Get.closeCurrentSnackbar();
          }
        },
        child: Text(
          TranslationKeys.snackbarDismiss.tr,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }

  static void successSnackBar({
    required title,
    message = '',
    int? duration,
  }) {
    _showSnackbar(
      title: title.toString(),
      message: message.toString(),
      backgroundColor: AppColors.success,
      textColor: Colors.white,
      durationSeconds: duration ?? _defaultSnackbarSeconds,
    );
  }

  static void warningSnackBar({
    required title,
    message = '',
    int? duration,
  }) {
    _showSnackbar(
      title: title.toString(),
      message: message.toString(),
      backgroundColor: AppColors.warning,
      textColor: AppColors.darkSurfaceSoft,
      durationSeconds: duration ?? _defaultSnackbarSeconds,
    );
  }

  static void errorSnackBar({
    required title,
    message = '',
    int? duration,
  }) {
    _showSnackbar(
      title: title.toString(),
      message: message.toString(),
      backgroundColor: AppColors.error,
      textColor: Colors.white,
      durationSeconds: duration ?? _defaultSnackbarSeconds,
    );
  }
}
