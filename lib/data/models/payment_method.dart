// lib/data/models/payment_method.dart

enum PaymentMethod {
  cash,
  card,
  mixed,
  debt;

  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.mixed:
        return 'Mixed (Cash + Card)';
      case PaymentMethod.debt:
        return 'Debt';
    }
  }

  String get value {
    switch (this) {
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.card:
        return 'card';
      case PaymentMethod.mixed:
        return 'mixed';
      case PaymentMethod.debt:
        return 'debt';
    }
  }

  static PaymentMethod fromString(String value) {
    switch (value.toLowerCase()) {
      case 'cash':
        return PaymentMethod.cash;
      case 'card':
        return PaymentMethod.card;
      case 'mixed':
        return PaymentMethod.mixed;
      case 'debt':
        return PaymentMethod.debt;
      default:
        return PaymentMethod.cash;
    }
  }
}
