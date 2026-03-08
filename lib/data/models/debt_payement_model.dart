// lib/data/models/debt_payment_model.dart

class DebtPaymentModel {
  final int? id;
  final int debtId;
  final double amount;
  final DateTime paymentDate;
  final String? notes;

  DebtPaymentModel({
    this.id,
    required this.debtId,
    required this.amount,
    required this.paymentDate,
    this.notes,
  });

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'debt_id': debtId,
      'amount': amount,
      'payment_date': paymentDate.toIso8601String(),
      'notes': notes,
    };
  }

  // Create from Map (database)
  factory DebtPaymentModel.fromMap(Map<String, dynamic> map) {
    return DebtPaymentModel(
      id: map['id'],
      debtId: map['debt_id'],
      amount: (map['amount'] ?? 0.0).toDouble(),
      paymentDate: DateTime.parse(map['payment_date']),
      notes: map['notes'],
    );
  }

  // Copy with method
  DebtPaymentModel copyWith({
    int? id,
    int? debtId,
    double? amount,
    DateTime? paymentDate,
    String? notes,
  }) {
    return DebtPaymentModel(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'DebtPaymentModel(amount: $amount DA, date: $paymentDate)';
  }
}
