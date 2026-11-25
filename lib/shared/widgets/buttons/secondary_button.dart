import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';

enum SecondaryButtonVariant { outline, filled }

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isArabic = false,
    this.height = 56,
    this.borderRadius = 14,
    this.enabled = true,
    this.isLoading = false,
    this.textStyle,
    this.leading,
    this.trailing,
    this.variant = SecondaryButtonVariant.outline,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isArabic;
  final double height;
  final double borderRadius;
  final bool enabled;
  final bool isLoading;
  final TextStyle? textStyle;
  final Widget? leading;
  final Widget? trailing;
  final SecondaryButtonVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final custom = AppCustomColors.of(context);

    final Color effectiveBorderColor = borderColor ?? colors.outline;
    final Color effectiveBgColor =
        backgroundColor ??
        (variant == SecondaryButtonVariant.filled
            ? (custom.surfaceSoft ?? colors.secondary)
            : Colors.transparent);
    final Color effectiveFgColor = foregroundColor ?? colors.onSurface;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: (enabled && !isLoading) ? onPressed : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: effectiveBgColor,
          foregroundColor: effectiveFgColor,
          disabledForegroundColor:
              (custom.textMuted ?? colors.onSurfaceVariant),
          side: BorderSide(
            color: enabled
                ? effectiveBorderColor
                : effectiveBorderColor.withValues(alpha: 0.35),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(effectiveFgColor),
                  ),
                ),
              )
            else if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style:
                  textStyle ??
                  AppTypography.getParagraphLargeBold(isArabic)
                      .copyWith(color: effectiveFgColor),
            ),
            if (!isLoading && trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
