import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isArabic = false,
    this.enabled = true,
    this.isLoading = false,
    this.height = 36,
    this.horizontalPadding = 14,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isArabic;
  final bool enabled;
  final bool isLoading;
  final double height;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final custom = AppCustomColors.of(context);
    final bool isInteractive = enabled && !isLoading;

    final Color bgColor =
        isInteractive ? colors.primary : (custom.surfaceSoft ?? colors.secondary);
    final Color borderColor =
        isInteractive ? colors.primary : colors.primary.withValues(alpha: 0.16);
    final Color fgColor = isInteractive
        ? colors.onPrimary
        : (custom.textMuted ?? colors.onSurfaceVariant);

    return SizedBox(
      height: height,
      child: OutlinedButton(
        onPressed: isInteractive ? onPressed : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          side: BorderSide(color: borderColor),
          shape: const StadiumBorder(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2.3,
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                ),
              )
            else
              Text(
                label,
                style: AppTypography.getParagraphSmallBold(isArabic).copyWith(
                  color: fgColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
