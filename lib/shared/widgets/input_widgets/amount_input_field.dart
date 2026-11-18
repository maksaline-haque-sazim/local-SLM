import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getx_starter_template/shared/widgets/input_widgets/ios_keyboard_done_toolbar.dart';
import 'package:flutter_getx_starter_template/utils/constants/functions.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';
import 'package:get/get.dart';

class _DecimalAmountFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(',', '');
    if (text.isEmpty) {
      return newValue.copyWith(text: text);
    }
    if (!RegExp(r'^\d*\.?\d{0,2}$').hasMatch(text)) {
      return oldValue;
    }
    return newValue.copyWith(text: text);
  }
}

class AmountInputField extends StatefulWidget {
  const AmountInputField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.validator,
    this.textDirection,
    this.focusNode,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextDirection? textDirection;
  final FocusNode? focusNode;

  @override
  State<AmountInputField> createState() => _AmountInputFieldState();
}

class _AmountInputFieldState extends State<AmountInputField> {
  late final FocusNode _focusNode;
  late final bool _ownsFocusNode;
  IosKeyboardDoneToolbar? _iosDoneToolbar;

  @override
  void initState() {
    super.initState();
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _iosDoneToolbar = IosKeyboardDoneToolbar(_focusNode);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _iosDoneToolbar?.attach(context);
  }

  @override
  void dispose() {
    _iosDoneToolbar?.dispose();
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _dismissKeyboard() {
    closeKeyboard(context);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Get.locale?.languageCode == 'ar';
    final colors = context.colors;
    final TextDirection effectiveTextDirection =
        widget.textDirection ?? TextDirection.ltr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTypography.getParagraphSmallMedium(isArabic).copyWith(
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          onEditingComplete: _dismissKeyboard,
          onFieldSubmitted: (_) => _dismissKeyboard(),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            _DecimalAmountFormatter(),
          ],
          validator: widget.validator,
          textDirection: effectiveTextDirection,
          textAlign: TextAlign.left,
          style: AppTypography.getParagraphRegular(isArabic).copyWith(
            color: colors.onSurface,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle:
                AppTypography.getParagraphSmallRegular(isArabic).copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
