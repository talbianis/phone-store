// lib/data/repositories/customer_repository.dart

import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/tables.dart';
import '../models/customer_model.dart';

class CustomerRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Get all customers
  Future<List<CustomerModel>> getAllCustomers() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.customers,
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return CustomerModel.fromMap(maps[i]);
    });
  }

  // Get customer by ID
  Future<CustomerModel?> getCustomerById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.customers,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return CustomerModel.fromMap(maps.first);
  }

  // ⬅️ ADD THIS METHOD: Add customer
  Future<int> addCustomer(CustomerModel customer) async {
    final db = await _dbHelper.database;
    return await db.insert(
      Tables.customers,
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ⬅️ ADD THIS METHOD: Update customer
  Future<int> updateCustomer(CustomerModel customer) async {
    final db = await _dbHelper.database;
    return await db.update(
      Tables.customers,
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  // ⬅️ ADD THIS METHOD: Delete customer
  Future<int> deleteCustomer(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      Tables.customers,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Search customers by name, phone, or email
  Future<List<CustomerModel>> searchCustomers(String query) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.customers,
      where: 'name LIKE ? OR phone LIKE ? OR email LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) {
      return CustomerModel.fromMap(maps[i]);
    });
  }

  // Get customers with debt
  Future<List<CustomerModel>> getCustomersWithDebt() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.customers,
      where: 'total_debt > ?',
      whereArgs: [0],
      orderBy: 'total_debt DESC',
    );

    return List.generate(maps.length, (i) {
      return CustomerModel.fromMap(maps[i]);
    });
  }

  // Get top customers by total purchases
  Future<List<CustomerModel>> getTopCustomers({int limit = 5}) async {
    final db = await _dbHelper.database;

    // This query gets customers with their total purchase amount
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT c.*, COALESCE(SUM(s.total), 0) as total_purchases
      FROM ${Tables.customers} c
      LEFT JOIN ${Tables.sales} s ON c.id = s.customer_id
      GROUP BY c.id
      ORDER BY total_purchases DESC
      LIMIT ?
    ''', [limit]);

    return List.generate(maps.length, (i) {
      return CustomerModel.fromMap(maps[i]);
    });
  }

  // Update customer debt
  Future<int> updateCustomerDebt(int customerId, double newDebt) async {
    final db = await _dbHelper.database;
    return await db.update(
      Tables.customers,
      {'total_debt': newDebt},
      where: 'id = ?',
      whereArgs: [customerId],
    );
  }

  // Add to customer debt
  Future<void> addToCustomerDebt(int customerId, double amount) async {
    final db = await _dbHelper.database;
    await db.rawUpdate('''
      UPDATE ${Tables.customers}
      SET total_debt = total_debt + ?
      WHERE id = ?
    ''', [amount, customerId]);
  }

  // Reduce customer debt
  Future<void> reduceCustomerDebt(int customerId, double amount) async {
    final db = await _dbHelper.database;
    await db.rawUpdate('''
      UPDATE ${Tables.customers}
      SET total_debt = total_debt - ?
      WHERE id = ?
    ''', [amount, customerId]);
  }

  // Get customer count
  Future<int> getCustomerCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${Tables.customers}',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Get total debt across all customers
  Future<double> getTotalDebt() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(total_debt) as total FROM ${Tables.customers}',
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // Check if phone number already exists
  Future<bool> phoneExists(String phone, {int? excludeCustomerId}) async {
    final db = await _dbHelper.database;

    String whereClause = 'phone = ?';
    List<dynamic> whereArgs = [phone];

    if (excludeCustomerId != null) {
      whereClause += ' AND id != ?';
      whereArgs.add(excludeCustomerId);
    }

    final result = await db.query(
      Tables.customers,
      where: whereClause,
      whereArgs: whereArgs,
    );

    return result.isNotEmpty;
  }

  // Get customer purchase history
  Future<List<Map<String, dynamic>>> getCustomerPurchaseHistory(
    int customerId,
  ) async {
    final db = await _dbHelper.database;
    return await db.query(
      Tables.sales,
      where: 'customer_id = ?',
      whereArgs: [customerId],
      orderBy: 'sale_date DESC',
    );
  }

  // Get customer total spent
  Future<double> getCustomerTotalSpent(int customerId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT COALESCE(SUM(total), 0) as total_spent
      FROM ${Tables.sales}
      WHERE customer_id = ?
    ''', [customerId]);

    return (result.first['total_spent'] as num?)?.toDouble() ?? 0.0;
  }

  // Get customer purchase count
  Future<int> getCustomerPurchaseCount(int customerId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT COUNT(*) as count
      FROM ${Tables.sales}
      WHERE customer_id = ?
    ''', [customerId]);

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Get customer last purchase date
  Future<DateTime?> getCustomerLastPurchase(int customerId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      Tables.sales,
      columns: ['sale_date'],
      where: 'customer_id = ?',
      whereArgs: [customerId],
      orderBy: 'sale_date DESC',
      limit: 1,
    );

    if (result.isEmpty) return null;
    return DateTime.parse(result.first['sale_date'] as String);
  }
}
