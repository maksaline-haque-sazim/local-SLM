import 'package:flutter/material.dart';

void closeKeyboard([BuildContext? context]) {
  FocusManager.instance.primaryFocus?.unfocus();
  if (context != null && context.mounted) {
    FocusScope.of(context).unfocus();
  }
}
