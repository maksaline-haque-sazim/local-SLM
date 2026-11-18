import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class CoreMultiSelectOption<T> {
  const CoreMultiSelectOption({
    required this.value,
    required this.label,
    this.icon,
    this.disabled = false,
  });

  final T value;
  final String label;
  final IconData? icon;
  final bool disabled;
}

class CoreMultiSelectDropdown<T extends Object> extends StatelessWidget {
  const CoreMultiSelectDropdown({
    super.key,
    required this.options,
    required this.hintText,
    this.onSelectionChange,
    this.validator,
    this.controller,
    this.enabled = true,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.searchEnabled = false,
  });

  final List<CoreMultiSelectOption<T>> options;
  final String hintText;
  final void Function(List<T>)? onSelectionChange;
  final String? Function(List<T>?)? validator;
  final MultiSelectController<T>? controller;
  final bool enabled;
  final AutovalidateMode autovalidateMode;
  final bool searchEnabled;

  @override
  Widget build(BuildContext context) {
    final isArabic = Get.locale?.languageCode == 'ar';
    final colors = context.colors;
    final borderColor = colors.outline;
    final fillColor = colors.surface;
    final hintStyle = AppTypography.getParagraphSmallRegular(isArabic).copyWith(
      color: colors.onSurfaceVariant,
    );
    final textStyle = AppTypography.getParagraphRegular(isArabic).copyWith(
      color: colors.onSurface,
    );
    final chipLabelStyle =
        AppTypography.getParagraphSmallMedium(isArabic).copyWith(
      color: colors.primary,
    );
    final iconByValue = <T, IconData>{
      for (final option in options)
        if (option.icon != null) option.value: option.icon!,
    };
    final showIcons = iconByValue.isNotEmpty;
    final chipBg = colors.primary.withValues(alpha: context.isDark ? 0.2 : 0.12);

    return MultiDropdown<T>(
      items: options
          .map(
            (option) => DropdownItem<T>(
              label: option.label,
              value: option.value,
              disabled: option.disabled,
            ),
          )
          .toList(),
      controller: controller,
      enabled: enabled,
      searchEnabled: searchEnabled,
      autovalidateMode: autovalidateMode,
      validator: validator == null
          ? null
          : (selectedItems) {
              final values = selectedItems
                      ?.map((item) => item.value)
                      .toList(growable: false) ??
                  <T>[];
              return validator!(values);
            },
      onSelectionChange: onSelectionChange,
      itemBuilder: showIcons
          ? (item, index, onTap) {
              final icon = iconByValue[item.value];
              return ListTile(
                onTap: onTap,
                dense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Sizes.md,
                  vertical: Sizes.xs,
                ),
                leading: icon == null
                    ? null
                    : Icon(
                        icon,
                        size: 22,
                        color: item.selected
                            ? colors.primary
                            : colors.onSurfaceVariant,
                      ),
                title: Text(
                  item.label,
                  style: item.selected
                      ? textStyle.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        )
                      : textStyle,
                ),
                trailing: item.selected
                    ? Icon(
                        Icons.check_rounded,
                        color: colors.primary,
                        size: 20,
                      )
                    : null,
              );
            }
          : null,
      selectedItemBuilder: showIcons
          ? (item) {
              final icon = iconByValue[item.value];
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.sm,
                  vertical: Sizes.xs,
                ),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 16, color: colors.primary),
                      const SizedBox(width: Sizes.xs),
                    ],
                    Text(item.label, style: chipLabelStyle),
                    if (enabled && controller != null) ...[
                      const SizedBox(width: Sizes.xs),
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          controller!.unselectWhere(
                            (element) => element.value == item.value,
                          );
                        },
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }
          : null,
      fieldDecoration: FieldDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        borderRadius: 12,
        backgroundColor: fillColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: colors.onSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.error),
        ),
        selectedItemTextStyle: textStyle,
      ),
      chipDecoration: ChipDecoration(
        backgroundColor: chipBg,
        labelStyle: chipLabelStyle,
        borderRadius: BorderRadius.circular(12),
        spacing: 8,
        runSpacing: 8,
        wrap: true,
      ),
      dropdownDecoration: DropdownDecoration(
        backgroundColor: fillColor,
        borderRadius: BorderRadius.circular(12),
        maxHeight: 280,
      ),
      dropdownItemDecoration: DropdownItemDecoration(
        textStyle: textStyle,
        selectedTextStyle: textStyle.copyWith(
          color: colors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
