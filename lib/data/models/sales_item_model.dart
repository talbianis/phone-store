// lib/data/models/sale_item_model.dart

class SaleItemModel {
  final int? id;
  final int saleId;
  final int productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final double profit;

  // Additional field for display
  String? productImage;

  SaleItemModel({
    this.id,
    required this.saleId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.profit,
    this.productImage,
  });

  // Calculate profit per unit
  double get profitPerUnit => profit / quantity;

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sale_id': saleId,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'profit': profit,
    };
  }

  // Create from Map (database)
  factory SaleItemModel.fromMap(Map<String, dynamic> map) {
    return SaleItemModel(
      id: map['id'],
      saleId: map['sale_id'],
      productId: map['product_id'],
      productName: map['product_name'],
      quantity: map['quantity'],
      unitPrice: (map['unit_price'] ?? 0.0).toDouble(),
      totalPrice: (map['total_price'] ?? 0.0).toDouble(),
      profit: (map['profit'] ?? 0.0).toDouble(),
      productImage: map['product_image'],
    );
  }

  // Copy with method
  SaleItemModel copyWith({
    int? id,
    int? saleId,
    int? productId,
    String? productName,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    double? profit,
    String? productImage,
  }) {
    return SaleItemModel(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      profit: profit ?? this.profit,
      productImage: productImage ?? this.productImage,
    );
  }

  @override
  String toString() {
    return 'SaleItemModel(product: $productName, qty: $quantity, total: $totalPrice DA)';
  }
}
