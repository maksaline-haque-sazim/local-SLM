import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isArabic = false,
    this.height = 56,
    this.borderRadius = 14,
    this.enabled = true,
    this.isLoading = false,
    this.enableGradient = false,
    this.textStyle,
    this.leading,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isArabic;
  final double height;
  final double borderRadius;
  final bool enabled;
  final bool isLoading;
  final bool enableGradient;
  final TextStyle? textStyle;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final custom = AppCustomColors.of(context);
    final textDirection = Directionality.of(context);
    final bool isInteractive = enabled && !isLoading;

    final Color bgColor = isInteractive
        ? colors.primary
        : (custom.surfaceSoft ?? colors.secondary);
    final Color fgColor = isInteractive
        ? colors.onPrimary
        : (custom.textMuted ?? colors.onSurfaceVariant);

    final Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          Padding(
            padding: textDirection == TextDirection.rtl
                ? const EdgeInsets.only(left: 8)
                : const EdgeInsets.only(right: 8),
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(fgColor),
              ),
            ),
          )
        else if (leading != null) ...[
          leading!,
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle ??
                AppTypography.getParagraphRegular(isArabic)
                    .copyWith(color: fgColor),
          ),
        ),
      ],
    );

    if (enableGradient) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: isInteractive
                ? LinearGradient(
                    colors: [
                      colors.primary,
                      Color.lerp(colors.primary, colors.secondary, 0.35)!,
                    ],
                  )
                : null,
            color: isInteractive ? null : bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isInteractive ? onPressed : null,
              borderRadius: BorderRadius.circular(borderRadius),
              child: SizedBox(
                height: height,
                child: Center(child: content),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isInteractive ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          disabledBackgroundColor: bgColor,
          disabledForegroundColor: fgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        ),
        child: content,
      ),
    );
  }
}
