import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';

class PhoneInputField extends StatefulWidget {
  const PhoneInputField({
    super.key,
    required this.controller,
    this.initialCountryCode = '+966',
    this.onCountryCodeTap,
    this.hintText,
    this.labelText,
    this.validator,
    this.maxDigits = 9,
  });

  final TextEditingController controller;
  final String initialCountryCode;
  final VoidCallback? onCountryCodeTap;
  final String? hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final int maxDigits;

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  int _lastLength = 0;

  void _handleChanged(String value) {
    final length = value.length;
    if (_lastLength < widget.maxDigits && length == widget.maxDigits) {
      FocusScope.of(context).unfocus();
    }
    _lastLength = length;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final textField = Directionality(
      textDirection: TextDirection.ltr,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.done,
        textDirection: TextDirection.ltr,
        style: context.texts.bodyLarge?.copyWith(color: colors.onSurface),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,
        onChanged: _handleChanged,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(widget.maxDigits),
        ],
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: GestureDetector(
              onTap: widget.onCountryCodeTap,
              child: Text(
                widget.initialCountryCode,
                style: context.texts.bodyLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          hintText: widget.hintText,
        ),
      ),
    );

    if (widget.labelText == null) {
      return textField;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText!,
          style: context.texts.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        textField,
      ],
    );
  }
}
