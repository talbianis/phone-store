// lib/data/models/expense_model.dart

class ExpenseModel {
  final int? id;
  final String category;
  final double amount;
  final String? description;
  final DateTime expenseDate;
  final DateTime createdAt;

  ExpenseModel({
    this.id,
    required this.category,
    required this.amount,
    this.description,
    required this.expenseDate,
    required this.createdAt,
  });

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'description': description,
      'expense_date': expenseDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create from Map (database)
  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'],
      category: map['category'],
      amount: (map['amount'] ?? 0.0).toDouble(),
      description: map['description'],
      expenseDate: DateTime.parse(map['expense_date']),
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Copy with method
  ExpenseModel copyWith({
    int? id,
    String? category,
    double? amount,
    String? description,
    DateTime? expenseDate,
    DateTime? createdAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      expenseDate: expenseDate ?? this.expenseDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ExpenseModel(category: $category, amount: $amount DA, date: $expenseDate)';
  }
}

// Expense categories constants
class ExpenseCategories {
  static const String rent = 'Rent';
  static const String electricity = 'Electricity';
  static const String water = 'Water';
  static const String internet = 'Internet';
  static const String salaries = 'Salaries';
  static const String transportation = 'Transportation';
  static const String maintenance = 'Maintenance';
  static const String supplies = 'Supplies';
  static const String marketing = 'Marketing';
  static const String other = 'Other';

  static List<String> get all => [
    rent,
    electricity,
    water,
    internet,
    salaries,
    transportation,
    maintenance,
    supplies,
    marketing,
    other,
  ];
}
