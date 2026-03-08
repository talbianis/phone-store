// lib/core/utils/validators.dart

import '../constants/app_constants.dart';
import '../constants/app_strings.dart';

class Validators {
  // Required field
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName ${AppStrings.fieldRequired}'
          : AppStrings.fieldRequired;
    }
    return null;
  }

  // Username validation
  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value.length < AppConstants.minUsernameLength) {
      return 'Nom d\'utilisateur trop court (min ${AppConstants.minUsernameLength} caractères)';
    }

    if (value.length > AppConstants.maxUsernameLength) {
      return 'Nom d\'utilisateur trop long (max ${AppConstants.maxUsernameLength} caractères)';
    }

    return null;
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value.length < AppConstants.minPasswordLength) {
      return AppStrings.passwordTooShort;
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'Mot de passe trop long (max ${AppConstants.maxPasswordLength} caractères)';
    }

    return null;
  }

  // Phone validation (Algerian format)
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    final phoneRegex = RegExp(AppConstants.phonePattern);
    if (!phoneRegex.hasMatch(value)) {
      return AppStrings.invalidPhone;
    }

    return null;
  }

  // Number validation
  static String? number(String? value, {bool allowNegative = false}) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Veuillez entrer un nombre valide';
    }

    if (!allowNegative && number < 0) {
      return 'Le nombre ne peut pas être négatif';
    }

    return null;
  }

  // Price validation
  static String? price(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    final price = double.tryParse(value);
    if (price == null) {
      return 'Veuillez entrer un prix valide';
    }

    if (price < 0) {
      return 'Le prix ne peut pas être négatif';
    }

    return null;
  }

  // Quantity validation
  static String? quantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    final qty = int.tryParse(value);
    if (qty == null) {
      return 'Veuillez entrer une quantité valide';
    }

    if (qty < 0) {
      return 'La quantité ne peut pas être négative';
    }

    return null;
  }

  // Percentage validation
  static String? percentage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    final percent = double.tryParse(value);
    if (percent == null) {
      return 'Veuillez entrer un pourcentage valide';
    }

    if (percent < 0 || percent > 100) {
      return 'Le pourcentage doit être entre 0 et 100';
    }

    return null;
  }

  // Barcode validation (optional field)
  static String? barcode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    // Basic barcode validation (alphanumeric)
    final barcodeRegex = RegExp(r'^[a-zA-Z0-9]+$');
    if (!barcodeRegex.hasMatch(value)) {
      return 'Code-barres invalide (seulement lettres et chiffres)';
    }

    return null;
  }
}
