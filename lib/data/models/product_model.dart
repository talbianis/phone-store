// lib/data/models/product_model.dart

class ProductModel {
  final int? id;
  final String name;
  final int categoryId;
  final String? brand;
  final double purchasePrice;
  final double sellingPrice;
  final int quantity;
  final int minQuantity;
  final String? barcode;
  final String? imagePath;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    this.id,
    required this.name,
    required this.categoryId,
    this.brand,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.quantity,
    this.minQuantity = 5,
    this.barcode,
    this.imagePath,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  double get profitPerUnit => sellingPrice - purchasePrice;
  double get profitMargin => ((profitPerUnit / purchasePrice) * 100);
  bool get isLowStock => quantity <= minQuantity && quantity > 0;
  bool get isOutOfStock => quantity <= 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'brand': brand,
      'purchase_price': purchasePrice,
      'selling_price': sellingPrice,
      'quantity': quantity,
      'min_quantity': minQuantity,
      'barcode': barcode,
      'image_path': imagePath,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      categoryId: map['category_id'],
      brand: map['brand'],
      purchasePrice: (map['purchase_price'] ?? 0.0).toDouble(),
      sellingPrice: (map['selling_price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 0,
      minQuantity: map['min_quantity'] ?? 5,
      barcode: map['barcode'],
      imagePath: map['image_path'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  // ⬅️ FIXED copyWith method
  ProductModel copyWith({
    int? id,
    String? name,
    int? categoryId,
    String? brand,
    double? purchasePrice,
    double? sellingPrice,
    int? quantity,
    int? minQuantity,
    String? barcode,
    Object? imagePath = _undefined, // ⬅️ Use Object? with marker
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      brand: brand ?? this.brand,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      quantity: quantity ?? this.quantity,
      minQuantity: minQuantity ?? this.minQuantity,
      barcode: barcode ?? this.barcode,
      imagePath: imagePath == _undefined
          ? this.imagePath
          : imagePath as String?, // ⬅️ Handle null properly
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// ⬅️ Add this marker class at the bottom of the file
class _Undefined {
  const _Undefined();
}

const _undefined = _Undefined();
