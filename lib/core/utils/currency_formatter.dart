// lib/core/utils/currency_formatter.dart

import 'package:intl/intl.dart';
import '../constants/app_strings.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat('#,##0.00', 'fr_DZ');

  // Format amount to currency string
  static String format(double amount) {
    return '${_formatter.format(amount)} ${AppStrings.currency}';
  }

  // Format amount without currency symbol
  static String formatNumber(double amount) {
    return _formatter.format(amount);
  }

  // Parse currency string to double
  static double parse(String value) {
    try {
      // Remove currency symbol and spaces
      final cleaned = value
          .replaceAll(AppStrings.currency, '')
          .replaceAll(' ', '')
          .replaceAll(',', '.');
      return double.parse(cleaned);
    } catch (e) {
      return 0.0;
    }
  }

  // Format with compact notation (1K, 1M, etc.)
  static String formatCompact(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M ${AppStrings.currency}';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K ${AppStrings.currency}';
    }
    return format(amount);
  }

  // Format percentage
  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }
}
