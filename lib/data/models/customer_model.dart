// lib/data/models/customer_model.dart

class CustomerModel {
  final int? id;
  final String name;
  final String phone;

  final String? address;
  final double totalDebt;
  final DateTime createdAt;

  CustomerModel({
    this.id,
    required this.name,
    required this.phone,
    this.address,
    this.totalDebt = 0.0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'total_debt': totalDebt,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      address: map['address'],
      totalDebt: (map['total_debt'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // ⬅️ MAKE SURE YOU HAVE THIS METHOD
  CustomerModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    double? totalDebt,
    DateTime? createdAt,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      totalDebt: totalDebt ?? this.totalDebt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'CustomerModel(id: $id, name: $name, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomerModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
