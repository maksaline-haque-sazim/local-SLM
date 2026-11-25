import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/utils/constants/functions.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';
import 'package:get/get.dart';

class IosKeyboardDoneToolbar {
  IosKeyboardDoneToolbar(this.focusNode);

  final FocusNode focusNode;
  OverlayEntry? _overlayEntry;
  BuildContext? _hostContext;

  void attach(BuildContext context) {
    if (!Platform.isIOS || _hostContext != null) {
      return;
    }
    _hostContext = context;
    focusNode.addListener(_onFocusChanged);
  }

  void dispose() {
    if (!Platform.isIOS) {
      return;
    }
    focusNode.removeListener(_onFocusChanged);
    _removeOverlay();
    _hostContext = null;
  }

  void _onFocusChanged() {
    if (focusNode.hasFocus) {
      _showOverlay();
      return;
    }
    _removeOverlay();
  }

  void _showOverlay() {
    final context = _hostContext;
    if (context == null || !context.mounted) {
      return;
    }
    _removeOverlay();
    _overlayEntry = OverlayEntry(
      builder: (overlayContext) => _IosKeyboardDoneBar(focusNode: focusNode),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _IosKeyboardDoneBar extends StatefulWidget {
  const _IosKeyboardDoneBar({required this.focusNode});

  final FocusNode focusNode;

  @override
  State<_IosKeyboardDoneBar> createState() => _IosKeyboardDoneBarState();
}

class _IosKeyboardDoneBarState extends State<_IosKeyboardDoneBar>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    if (bottomInset <= 0) {
      return const SizedBox.shrink();
    }

    final bool isArabic = Get.locale?.languageCode == 'ar';
    final colors = context.colors;
    final Color toolbarColor = colors.surfaceContainerHighest;
    final Color borderColor = colors.outlineVariant.withValues(alpha: 0.4);

    return Positioned(
      left: 0,
      right: 0,
      bottom: bottomInset,
      child: Material(
        color: toolbarColor,
        elevation: 4,
        shadowColor: colors.shadow.withValues(alpha: 0.2),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.md,
            vertical: Sizes.xs,
          ),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: borderColor)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                color: colors.primary,
                borderRadius: BorderRadius.circular(10),
                elevation: 2,
                shadowColor: colors.primary.withValues(alpha: 0.45),
                child: InkWell(
                  onTap: () {
                    closeKeyboard(context);
                    widget.focusNode.unfocus();
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.md,
                      vertical: Sizes.sm,
                    ),
                    child: Text(
                      TranslationKeys.commonDone.tr,
                      style: AppTypography.getParagraphSmallBold(isArabic)
                          .copyWith(color: colors.onPrimary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
