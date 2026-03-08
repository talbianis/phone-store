// lib/core/constants/app_constants.dart

class AppConstants {
  // Database
  static const String databaseName = 'magasin.db';
  static const int databaseVersion = 1;

  // Pagination
  static const int itemsPerPage = 20;

  // Stock Levels
  static const int lowStockThreshold = 5;
  static const int outOfStockThreshold = 0;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;

  // Phone
  static const String phonePattern = r'^(0)(5|6|7)[0-9]{8}$'; // Algerian phone

  // Invoice
  static const String invoicePrefix = 'INV-';
  static const int invoiceNumberLength = 6;

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';

  // Image
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];

  // Discount
  static const double maxDiscountPercent = 100;
  static const double minDiscountPercent = 0;
}
