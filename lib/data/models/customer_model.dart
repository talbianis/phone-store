// lib/data/models/customer_model.dart

class CustomerModel {
  final int? id;
  final String name;
  final String phone;
  final String? address;
  final double totalPurchases;
  final double totalDebt;
  final DateTime createdAt;

  CustomerModel({
    this.id,
    required this.name,
    required this.phone,
    this.address,
    this.totalPurchases = 0.0,
    this.totalDebt = 0.0,
    required this.createdAt,
  });

  // Check if customer has debt
  bool get hasDebt => totalDebt > 0;

  // Check if customer is a regular (has purchases)
  bool get isRegularCustomer => totalPurchases > 0;

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'total_purchases': totalPurchases,
      'total_debt': totalDebt,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create from Map (database)
  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      address: map['address'],
      totalPurchases: (map['total_purchases'] ?? 0.0).toDouble(),
      totalDebt: (map['total_debt'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Copy with method
  CustomerModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    double? totalPurchases,
    double? totalDebt,
    DateTime? createdAt,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      totalPurchases: totalPurchases ?? this.totalPurchases,
      totalDebt: totalDebt ?? this.totalDebt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'CustomerModel(id: $id, name: $name, phone: $phone, debt: $totalDebt DA)';
  }
}
