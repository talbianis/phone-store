// lib/data/models/stock_adjustment_model.dart

class StockAdjustmentModel {
  final int? id;
  final int productId;
  final int quantityChange; // positive for increase, negative for decrease
  final String reason;
  final String? notes;
  final int userId;
  final DateTime adjustmentDate;

  // Additional fields for display
  String? productName;
  String? userName;

  StockAdjustmentModel({
    this.id,
    required this.productId,
    required this.quantityChange,
    required this.reason,
    this.notes,
    required this.userId,
    required this.adjustmentDate,
    this.productName,
    this.userName,
  });

  // Check if this is an increase
  bool get isIncrease => quantityChange > 0;

  // Check if this is a decrease
  bool get isDecrease => quantityChange < 0;

  // Get adjustment type
  String get adjustmentType => isIncrease ? 'Added' : 'Removed';

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'quantity_change': quantityChange,
      'reason': reason,
      'notes': notes,
      'user_id': userId,
      'adjustment_date': adjustmentDate.toIso8601String(),
    };
  }

  // Create from Map (database)
  factory StockAdjustmentModel.fromMap(Map<String, dynamic> map) {
    return StockAdjustmentModel(
      id: map['id'],
      productId: map['product_id'],
      quantityChange: map['quantity_change'],
      reason: map['reason'],
      notes: map['notes'],
      userId: map['user_id'],
      adjustmentDate: DateTime.parse(map['adjustment_date']),
      productName: map['product_name'],
      userName: map['user_name'],
    );
  }

  // Copy with method
  StockAdjustmentModel copyWith({
    int? id,
    int? productId,
    int? quantityChange,
    String? reason,
    String? notes,
    int? userId,
    DateTime? adjustmentDate,
    String? productName,
    String? userName,
  }) {
    return StockAdjustmentModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantityChange: quantityChange ?? this.quantityChange,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      userId: userId ?? this.userId,
      adjustmentDate: adjustmentDate ?? this.adjustmentDate,
      productName: productName ?? this.productName,
      userName: userName ?? this.userName,
    );
  }

  @override
  String toString() {
    return 'StockAdjustmentModel(product: $productName, change: $quantityChange, reason: $reason)';
  }
}

// Stock adjustment reasons constants
class StockAdjustmentReasons {
  static const String restock = 'Restock';
  static const String damage = 'Damage';
  static const String theft = 'Theft';
  static const String returned = 'Customer Return';
  static const String found = 'Found Item';
  static const String correction = 'Inventory Correction';
  static const String expired = 'Expired';
  static const String other = 'Other';

  static List<String> get all => [
    restock,
    damage,
    theft,
    returned,
    found,
    correction,
    expired,
    other,
  ];
}
