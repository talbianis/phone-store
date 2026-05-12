// lib/core/utils/validators.dart

import '../constants/app_constants.dart';
import '../localization/app_localizations.dart';

class Validators {
  static String? required(
    String? value,
    AppLocalizations l10n, {
    String? fieldName,
  }) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? l10n.fieldRequiredNamed(fieldName)
          : l10n.required;
    }
    return null;
  }

  static String? username(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.required;
    }

    if (value.length < AppConstants.minUsernameLength) {
      return l10n.usernameTooShortMsg(AppConstants.minUsernameLength);
    }

    if (value.length > AppConstants.maxUsernameLength) {
      return l10n.usernameTooLongMsg(AppConstants.maxUsernameLength);
    }

    return null;
  }

  static String? password(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.required;
    }

    if (value.length < AppConstants.minPasswordLength) {
      return l10n.passwordTooShortMsg(AppConstants.minPasswordLength);
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return l10n.passwordTooLongMsg(AppConstants.maxPasswordLength);
    }

    return null;
  }

  static String? phone(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.required;
    }

    final phoneRegex = RegExp(AppConstants.phonePattern);
    if (!phoneRegex.hasMatch(value)) {
      return l10n.invalidPhone;
    }

    return null;
  }

  static String? number(
    String? value,
    AppLocalizations l10n, {
    bool allowNegative = false,
  }) {
    if (value == null || value.trim().isEmpty) {
      return l10n.required;
    }

    final number = double.tryParse(value);
    if (number == null) {
      return l10n.enterValidNumber;
    }

    if (!allowNegative && number < 0) {
      return l10n.numberCannotBeNegative;
    }

    return null;
  }

  static String? price(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.required;
    }

    final price = double.tryParse(value);
    if (price == null) {
      return l10n.enterValidPriceMsg;
    }

    if (price < 0) {
      return l10n.priceCannotBeNegative;
    }

    return null;
  }

  static String? quantity(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.required;
    }

    final qty = int.tryParse(value);
    if (qty == null) {
      return l10n.enterValidQuantityMsg;
    }

    if (qty < 0) {
      return l10n.quantityCannotBeNegative;
    }

    return null;
  }

  static String? percentage(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.required;
    }

    final percent = double.tryParse(value);
    if (percent == null) {
      return l10n.enterValidPercentage;
    }

    if (percent < 0 || percent > 100) {
      return l10n.percentageRange;
    }

    return null;
  }

  static String? barcode(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final barcodeRegex = RegExp(r'^[a-zA-Z0-9]+$');
    if (!barcodeRegex.hasMatch(value)) {
      return l10n.invalidBarcodeFormat;
    }

    return null;
  }
}
