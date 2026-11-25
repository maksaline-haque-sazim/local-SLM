import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.lightSurfaceSoft,
      onSecondary: AppColors.primary,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      onSurfaceVariant: AppColors.lightTextSecondary,
      outline: Color(0xFFE2E8F0),
      outlineVariant: AppColors.lightTextMuted,
      surfaceContainerHighest: AppColors.lightSurfaceSoft,
    ),
    scaffoldBackgroundColor: AppColors.lightSurface,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
      bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
      bodySmall: TextStyle(color: AppColors.lightTextMuted),
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        color: AppColors.lightTextPrimary,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.lightTextPrimary,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightTextPrimary,
      elevation: 0,
    ),
    cardColor: AppColors.lightSurfaceSoft,
    cardTheme: CardThemeData(
      color: AppColors.lightSurfaceSoft,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: _inputDecorationTheme(
      fillColor: AppColors.lightSurface,
      borderColor: const Color(0xFFE2E8F0),
      hintColor: AppColors.lightTextMuted,
      errorColor: AppColors.error,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.lightTextPrimary,
        side: const BorderSide(color: AppColors.lightTextPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.lightSurface,
      headerBackgroundColor: AppColors.primary,
      headerForegroundColor: Colors.white,
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return AppColors.lightTextPrimary;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return null;
      }),
      todayForegroundColor: const WidgetStatePropertyAll(AppColors.primary),
      todayBorder: const BorderSide(color: AppColors.primary),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: AppColors.lightSurface,
      dialHandColor: AppColors.primary,
      hourMinuteTextColor: AppColors.lightTextPrimary,
      dayPeriodTextColor: AppColors.lightTextPrimary,
    ),
    extensions: const [
      AppCustomColors(
        successSoft: AppColors.lightSuccessSoft,
        onSuccessSoft: AppColors.successDark,
        surfaceSoft: AppColors.lightSurfaceSoft,
        textMuted: AppColors.lightTextMuted,
      ),
    ],
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.darkSurfaceSoft,
      onSecondary: AppColors.darkTextPrimary,
      error: AppColors.errorDark,
      onError: Colors.white,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      onSurfaceVariant: AppColors.darkTextSecondary,
      outline: AppColors.darkSurfaceSoft,
      outlineVariant: AppColors.darkTextSecondary,
      surfaceContainerHighest: AppColors.darkSurfaceSoft,
    ),
    scaffoldBackgroundColor: AppColors.darkSurface,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
      bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
      bodySmall: TextStyle(color: AppColors.darkTextSecondary),
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        color: AppColors.darkTextPrimary,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.darkTextPrimary,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
    ),
    cardColor: AppColors.darkSurfaceSoft,
    cardTheme: CardThemeData(
      color: AppColors.darkSurfaceSoft,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: _inputDecorationTheme(
      fillColor: AppColors.darkSurface,
      borderColor: AppColors.darkSurfaceSoft,
      hintColor: AppColors.darkTextSecondary,
      errorColor: AppColors.errorDark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkTextPrimary,
        side: const BorderSide(color: AppColors.darkSurfaceSoft),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.darkSurface,
      headerBackgroundColor: AppColors.primary,
      headerForegroundColor: Colors.white,
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return AppColors.darkTextPrimary;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return null;
      }),
      todayForegroundColor: const WidgetStatePropertyAll(AppColors.primary),
      todayBorder: const BorderSide(color: AppColors.primary),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: AppColors.darkSurface,
      dialHandColor: AppColors.primary,
      hourMinuteTextColor: AppColors.darkTextPrimary,
      dayPeriodTextColor: AppColors.darkTextPrimary,
    ),
    extensions: const [
      AppCustomColors(
        successSoft: AppColors.darkSuccessSoft,
        onSuccessSoft: AppColors.success,
        surfaceSoft: AppColors.darkSurfaceSoft,
        textMuted: AppColors.darkTextSecondary,
      ),
    ],
  );

  static InputDecorationTheme _inputDecorationTheme({
    required Color fillColor,
    required Color borderColor,
    required Color hintColor,
    required Color errorColor,
  }) {
    OutlineInputBorder border([Color? color, double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color ?? borderColor, width: width),
      );
    }

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      hintStyle: TextStyle(color: hintColor),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: border(),
      enabledBorder: border(),
      focusedBorder: border(AppColors.primary, 2),
      errorBorder: border(errorColor),
      focusedErrorBorder: border(errorColor, 2),
    );
  }
}

class AppCustomColors extends ThemeExtension<AppCustomColors> {
  final Color? successSoft;
  final Color? onSuccessSoft;
  final Color? surfaceSoft;
  final Color? textMuted;

  const AppCustomColors({
    required this.successSoft,
    required this.onSuccessSoft,
    required this.surfaceSoft,
    required this.textMuted,
  });

  static AppCustomColors of(BuildContext context) {
    return Theme.of(context).extension<AppCustomColors>()!;
  }

  @override
  AppCustomColors copyWith({
    Color? successSoft,
    Color? onSuccessSoft,
    Color? surfaceSoft,
    Color? textMuted,
  }) {
    return AppCustomColors(
      successSoft: successSoft ?? this.successSoft,
      onSuccessSoft: onSuccessSoft ?? this.onSuccessSoft,
      surfaceSoft: surfaceSoft ?? this.surfaceSoft,
      textMuted: textMuted ?? this.textMuted,
    );
  }

  @override
  AppCustomColors lerp(ThemeExtension<AppCustomColors>? other, double t) {
    if (other is! AppCustomColors) {
      return this;
    }
    return AppCustomColors(
      successSoft: Color.lerp(successSoft, other.successSoft, t),
      onSuccessSoft: Color.lerp(onSuccessSoft, other.onSuccessSoft, t),
      surfaceSoft: Color.lerp(surfaceSoft, other.surfaceSoft, t),
      textMuted: Color.lerp(textMuted, other.textMuted, t),
    );
  }
}
