// lib/data/models/debt_model.dart

class DebtModel {
  final int? id;
  final int customerId;
  final int saleId;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final String status; // 'unpaid', 'partial', 'paid'
  final DateTime createdAt;

  // Additional fields for display
  String? customerName;
  String? customerPhone;
  String? invoiceNumber;

  DebtModel({
    this.id,
    required this.customerId,
    required this.saleId,
    required this.totalAmount,
    this.paidAmount = 0.0,
    required this.remainingAmount,
    required this.status,
    required this.createdAt,
    this.customerName,
    this.customerPhone,
    this.invoiceNumber,
  });

  // Check if fully paid
  bool get isFullyPaid => status == 'paid' || remainingAmount == 0;

  // Check if partially paid
  bool get isPartiallyPaid => status == 'partial' && paidAmount > 0;

  // Check if unpaid
  bool get isUnpaid => status == 'unpaid' || paidAmount == 0;

  // Calculate payment percentage
  double get paymentPercentage => (paidAmount / totalAmount) * 100;

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'sale_id': saleId,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'remaining_amount': remainingAmount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create from Map (database)
  factory DebtModel.fromMap(Map<String, dynamic> map) {
    return DebtModel(
      id: map['id'],
      customerId: map['customer_id'],
      saleId: map['sale_id'],
      totalAmount: (map['total_amount'] ?? 0.0).toDouble(),
      paidAmount: (map['paid_amount'] ?? 0.0).toDouble(),
      remainingAmount: (map['remaining_amount'] ?? 0.0).toDouble(),
      status: map['status'],
      createdAt: DateTime.parse(map['created_at']),
      customerName: map['customer_name'],
      customerPhone: map['customer_phone'],
      invoiceNumber: map['invoice_number'],
    );
  }

  // Copy with method
  DebtModel copyWith({
    int? id,
    int? customerId,
    int? saleId,
    double? totalAmount,
    double? paidAmount,
    double? remainingAmount,
    String? status,
    DateTime? createdAt,
    String? customerName,
    String? customerPhone,
    String? invoiceNumber,
  }) {
    return DebtModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      saleId: saleId ?? this.saleId,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
    );
  }

  @override
  String toString() {
    return 'DebtModel(customer: $customerName, total: $totalAmount DA, remaining: $remainingAmount DA)';
  }
}
