import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';
import 'package:get/get.dart';

class CoreTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextDirection? textDirection;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final int maxLines;

  const CoreTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.maxLength,
    this.textDirection,
    this.readOnly = false,
    this.onTap,
    this.textInputAction,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Get.locale?.languageCode == 'ar';
    final colors = context.colors;
    final bool isNumericKeyboard =
        keyboardType == TextInputType.number ||
        keyboardType == TextInputType.phone ||
        keyboardType == const TextInputType.numberWithOptions();

    final TextDirection? effectiveTextDirection =
        textDirection ??
        (isArabic && isNumericKeyboard ? TextDirection.ltr : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.getParagraphSmallMedium(isArabic)
              .copyWith(color: colors.onSurface),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction ?? TextInputAction.done,
          maxLength: maxLength,
          maxLines: obscureText ? 1 : maxLines,
          readOnly: readOnly,
          onTap: onTap,
          textDirection: effectiveTextDirection,
          textAlign: effectiveTextDirection == TextDirection.ltr
              ? TextAlign.left
              : TextAlign.start,
          buildCounter: (
            context, {
            required currentLength,
            required isFocused,
            required maxLength,
          }) => null,
          style: AppTypography.getParagraphRegular(isArabic)
              .copyWith(color: colors.onSurface),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.getParagraphSmallRegular(isArabic)
                .copyWith(color: colors.onSurfaceVariant),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
