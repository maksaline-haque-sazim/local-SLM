import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/shared/widgets/input_widgets/core_text_field.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';
import 'package:intl/intl.dart';

enum CoreDateTimePickerMode { date, time, dateAndTime }

class CoreDateTimePicker extends StatelessWidget {
  const CoreDateTimePicker({
    super.key,
    required this.label,
    required this.controller,
    this.mode = CoreDateTimePickerMode.date,
    this.hintText,
    this.validator,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.dateFormat,
    this.timeFormat,
    this.use24HourFormat,
  });

  final String label;
  final TextEditingController controller;
  final CoreDateTimePickerMode mode;
  final String? hintText;
  final String? Function(String?)? validator;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?>? onChanged;
  final String? dateFormat;
  final String? timeFormat;
  final bool? use24HourFormat;

  DateTime get _fallbackDate => initialDate ?? DateTime.now();

  String _format(DateTime value, BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    switch (mode) {
      case CoreDateTimePickerMode.date:
        return DateFormat(dateFormat ?? 'yyyy-MM-dd', locale).format(value);
      case CoreDateTimePickerMode.time:
        return DateFormat(
          timeFormat ??
              (use24HourFormat ?? MediaQuery.alwaysUse24HourFormatOf(context)
                  ? 'HH:mm'
                  : 'hh:mm a'),
          locale,
        ).format(value);
      case CoreDateTimePickerMode.dateAndTime:
        final date = DateFormat(dateFormat ?? 'yyyy-MM-dd', locale).format(value);
        final time = DateFormat(
          timeFormat ??
              (use24HourFormat ?? MediaQuery.alwaysUse24HourFormatOf(context)
                  ? 'HH:mm'
                  : 'hh:mm a'),
          locale,
        ).format(value);
        return '$date $time';
    }
  }

  Future<void> _pick(BuildContext context) async {
    DateTime selected = _fallbackDate;

    if (mode == CoreDateTimePickerMode.date ||
        mode == CoreDateTimePickerMode.dateAndTime) {
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: selected,
        firstDate: firstDate ?? DateTime(1900),
        lastDate: lastDate ?? DateTime(2100),
      );
      if (pickedDate == null) {
        return;
      }
      selected = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        selected.hour,
        selected.minute,
      );
    }

    if (mode == CoreDateTimePickerMode.time ||
        mode == CoreDateTimePickerMode.dateAndTime) {
      if (!context.mounted) {
        return;
      }
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selected),
        builder: (context, child) {
          final use24 = use24HourFormat ??
              MediaQuery.alwaysUse24HourFormatOf(context);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: use24),
            child: child ?? const SizedBox.shrink(),
          );
        },
      );
      if (pickedTime == null) {
        return;
      }
      selected = DateTime(
        selected.year,
        selected.month,
        selected.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }

    if (!context.mounted) {
      return;
    }
    controller.text = _format(selected, context);
    onChanged?.call(selected);
  }

  IconData get _icon {
    switch (mode) {
      case CoreDateTimePickerMode.date:
        return Icons.calendar_today_outlined;
      case CoreDateTimePickerMode.time:
        return Icons.access_time;
      case CoreDateTimePickerMode.dateAndTime:
        return Icons.event_available_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return CoreTextField(
      label: label,
      controller: controller,
      hintText: hintText,
      validator: validator,
      readOnly: true,
      onTap: () => _pick(context),
      suffixIcon: IconButton(
        onPressed: () => _pick(context),
        icon: Icon(_icon, color: colors.onSurfaceVariant),
      ),
    );
  }
}
