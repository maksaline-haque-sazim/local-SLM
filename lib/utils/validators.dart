import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:get/get.dart';

class Validators {
  Validators._();

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return TranslationKeys.validationRequired.tr;
    }
    return null;
  }

  static String? minLength(String? value, int min) {
    final requiredError = required(value);
    if (requiredError != null) {
      return requiredError;
    }
    if (value!.trim().length < min) {
      return TranslationKeys.validationMinLength.trParams({
        'min': min.toString(),
      });
    }
    return null;
  }

  static String? positiveNumber(String? value) {
    final requiredError = required(value);
    if (requiredError != null) {
      return requiredError;
    }
    final parsed = double.tryParse(value!.trim().replaceAll(',', ''));
    if (parsed == null || parsed <= 0) {
      return TranslationKeys.validationPositiveNumber.tr;
    }
    return null;
  }

  static String? nonNegativeInteger(String? value) {
    final requiredError = required(value);
    if (requiredError != null) {
      return requiredError;
    }
    final parsed = int.tryParse(value!.trim());
    if (parsed == null || parsed < 0) {
      return TranslationKeys.validationNonNegativeInteger.tr;
    }
    return null;
  }
}
