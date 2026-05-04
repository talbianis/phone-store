// lib/data/models/debt_payment_model.dart

class DebtPaymentModel {
  final int? id;
  final int debtId;
  final double amount;
  final String paymentMethod; // ⬅️ ADD THIS FIELD
  final DateTime paymentDate;
  final String? notes;

  DebtPaymentModel({
    this.id,
    required this.debtId,
    required this.amount,
    required this.paymentMethod, // ⬅️ ADD THIS
    required this.paymentDate,
    this.notes,
  });

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'debt_id': debtId,
      'amount': amount,
      'payment_method': paymentMethod, // ⬅️ ADD THIS
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
      paymentMethod: map['payment_method'] ?? 'cash', // ⬅️ ADD THIS
      paymentDate: DateTime.parse(map['payment_date']),
      notes: map['notes'],
    );
  }

  // Copy with method
  DebtPaymentModel copyWith({
    int? id,
    int? debtId,
    double? amount,
    String? paymentMethod, // ⬅️ ADD THIS
    DateTime? paymentDate,
    String? notes,
  }) {
    return DebtPaymentModel(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod, // ⬅️ ADD THIS
      paymentDate: paymentDate ?? this.paymentDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'DebtPaymentModel(debt: $debtId, amount: $amount DA, method: $paymentMethod)';
  }
}
