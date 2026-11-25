import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_colors.dart';
import 'package:get/get.dart';

class AppTypography {
  AppTypography._();

  static const double _smallScreenScale = 38 / 48;
  static const double _smallScreenWidth = 360;

  static Color get headingColor {
    final context = Get.context;
    if (context != null) {
      return Theme.of(context).colorScheme.onSurface;
    }
    return Get.isDarkMode
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
  }

  static Color get bodyColor {
    final context = Get.context;
    if (context != null) {
      return Theme.of(context).colorScheme.onSurfaceVariant;
    }
    return Get.isDarkMode
        ? AppColors.darkTextSecondary
        : AppColors.lightTextPrimary;
  }

  static bool get _isSmallScreen {
    final context = Get.context;
    if (context != null) {
      return MediaQuery.sizeOf(context).width <= _smallScreenWidth;
    }
    final width = Get.width;
    if (width > 0) {
      return width <= _smallScreenWidth;
    }
    return false;
  }

  static double _scaled(double size) {
    if (!_isSmallScreen) {
      return size;
    }
    return size * _smallScreenScale;
  }

  static TextStyle getHeading1(bool isArabic) => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: _scaled(46),
    height: isArabic ? 2 : 1.10,
    letterSpacing: isArabic ? 0 : -1.5,
    color: headingColor,
  );

  static TextStyle getHeading2(bool isArabic) => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: _scaled(30),
    height: 1.0,
    letterSpacing: isArabic ? 0 : -1,
    color: headingColor,
  );

  static TextStyle getHeading3(bool isArabic) => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: _scaled(24),
    height: 1.21,
    letterSpacing: isArabic ? 0 : -1,
    color: headingColor,
  );

  static TextStyle getHeading4(bool isArabic) => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: _scaled(20),
    height: 1.2,
    color: headingColor,
  );

  static TextStyle getParagraphLargeRegular(bool isArabic) => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: _scaled(18),
    height: 1.5,
    color: bodyColor,
  );

  static TextStyle getParagraphLargeMedium(bool isArabic) => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: _scaled(18),
    height: 1.5,
    color: bodyColor,
  );

  static TextStyle getParagraphLargeBold(bool isArabic) => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: _scaled(18),
    height: 1.5,
    color: bodyColor,
  );

  static TextStyle getParagraphRegular(bool isArabic) => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: _scaled(16),
    height: 1.5,
    color: bodyColor,
  );

  static TextStyle getParagraphMedium(bool isArabic) => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: _scaled(16),
    height: 1.5,
    color: bodyColor,
  );

  static TextStyle getParagraphBold(bool isArabic) => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: _scaled(16),
    height: 1.5,
    color: bodyColor,
  );

  static TextStyle getParagraphSmallRegular(bool isArabic) => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: _scaled(14),
    height: 1.43,
    color: bodyColor,
  );

  static TextStyle getParagraphSmallMedium(bool isArabic) => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: _scaled(14),
    height: 1.43,
    color: bodyColor,
  );

  static TextStyle getParagraphSmallBold(bool isArabic) => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: _scaled(14),
    height: 1.43,
    color: bodyColor,
  );

  static TextStyle getParagraphMiniRegular(bool isArabic) => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: _scaled(12),
    height: 1.33,
    color: bodyColor,
  );

  static TextStyle getParagraphMiniMedium(bool isArabic) => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: _scaled(12),
    height: 1.33,
    color: bodyColor,
  );

  static TextStyle getParagraphMiniBold(bool isArabic) => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: _scaled(12),
    height: 1.33,
    color: bodyColor,
  );

  static TextStyle getMono(bool isArabic) => TextStyle(
    fontFamily: 'monospace',
    fontWeight: FontWeight.w400,
    fontSize: _scaled(16),
    height: 1.5,
    color: bodyColor,
  );
}
