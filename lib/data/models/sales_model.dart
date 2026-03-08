// lib/data/models/sale_model.dart

class SaleModel {
  final int? id;
  final String invoiceNumber;
  final int? customerId;
  final int userId;
  final double subtotal;
  final double discount;
  final double total;
  final String paymentMethod; // 'cash', 'card', 'mixed', 'debt'
  final double paidAmount;
  final double remainingDebt;
  final double profit;
  final DateTime saleDate;

  // Additional fields for display (not stored in DB)
  String? customerName;
  String? userName;

  SaleModel({
    this.id,
    required this.invoiceNumber,
    this.customerId,
    required this.userId,
    required this.subtotal,
    this.discount = 0.0,
    required this.total,
    required this.paymentMethod,
    required this.paidAmount,
    this.remainingDebt = 0.0,
    required this.profit,
    required this.saleDate,
    this.customerName,
    this.userName,
  });

  // Check if fully paid
  bool get isFullyPaid => remainingDebt == 0;

  // Check if has debt
  bool get hasDebt => remainingDebt > 0;

  // Get payment status
  String get paymentStatus {
    if (isFullyPaid) return 'Paid';
    if (paidAmount > 0) return 'Partial';
    return 'Unpaid';
  }

  // Calculate profit margin percentage
  double get profitMargin => (profit / total) * 100;

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoice_number': invoiceNumber,
      'customer_id': customerId,
      'user_id': userId,
      'subtotal': subtotal,
      'discount': discount,
      'total': total,
      'payment_method': paymentMethod,
      'paid_amount': paidAmount,
      'remaining_debt': remainingDebt,
      'profit': profit,
      'sale_date': saleDate.toIso8601String(),
    };
  }

  // Create from Map (database)
  factory SaleModel.fromMap(Map<String, dynamic> map) {
    return SaleModel(
      id: map['id'],
      invoiceNumber: map['invoice_number'],
      customerId: map['customer_id'],
      userId: map['user_id'],
      subtotal: (map['subtotal'] ?? 0.0).toDouble(),
      discount: (map['discount'] ?? 0.0).toDouble(),
      total: (map['total'] ?? 0.0).toDouble(),
      paymentMethod: map['payment_method'],
      paidAmount: (map['paid_amount'] ?? 0.0).toDouble(),
      remainingDebt: (map['remaining_debt'] ?? 0.0).toDouble(),
      profit: (map['profit'] ?? 0.0).toDouble(),
      saleDate: DateTime.parse(map['sale_date']),
      customerName: map['customer_name'],
      userName: map['user_name'],
    );
  }

  // Copy with method
  SaleModel copyWith({
    int? id,
    String? invoiceNumber,
    int? customerId,
    int? userId,
    double? subtotal,
    double? discount,
    double? total,
    String? paymentMethod,
    double? paidAmount,
    double? remainingDebt,
    double? profit,
    DateTime? saleDate,
    String? customerName,
    String? userName,
  }) {
    return SaleModel(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customerId: customerId ?? this.customerId,
      userId: userId ?? this.userId,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paidAmount: paidAmount ?? this.paidAmount,
      remainingDebt: remainingDebt ?? this.remainingDebt,
      profit: profit ?? this.profit,
      saleDate: saleDate ?? this.saleDate,
      customerName: customerName ?? this.customerName,
      userName: userName ?? this.userName,
    );
  }

  @override
  String toString() {
    return 'SaleModel(invoice: $invoiceNumber, total: $total DA, profit: $profit DA)';
  }
}
