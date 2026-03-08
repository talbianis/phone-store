// lib/data/repositories/customer_repository.dart

import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/tables.dart';
import '../models/customer_model.dart';

class CustomerRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create customer
  Future<int> createCustomer(CustomerModel customer) async {
    final db = await _dbHelper.database;
    return await db.insert(Tables.customers, customer.toMap());
  }

  // Get all customers
  Future<List<CustomerModel>> getAllCustomers() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.customers,
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => CustomerModel.fromMap(maps[i]));
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

  // Get customer by phone
  Future<CustomerModel?> getCustomerByPhone(String phone) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.customers,
      where: 'phone = ?',
      whereArgs: [phone],
    );
    if (maps.isEmpty) return null;
    return CustomerModel.fromMap(maps.first);
  }

  // Search customers
  Future<List<CustomerModel>> searchCustomers(String query) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.customers,
      where: 'name LIKE ? OR phone LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => CustomerModel.fromMap(maps[i]));
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
    return List.generate(maps.length, (i) => CustomerModel.fromMap(maps[i]));
  }

  // Get top customers (by total purchases)
  Future<List<CustomerModel>> getTopCustomers({int limit = 10}) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.customers,
      orderBy: 'total_purchases DESC',
      limit: limit,
    );
    return List.generate(maps.length, (i) => CustomerModel.fromMap(maps[i]));
  }

  // Update customer
  Future<int> updateCustomer(CustomerModel customer) async {
    final db = await _dbHelper.database;
    return await db.update(
      Tables.customers,
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  // Update customer debt
  Future<int> updateCustomerDebt(int customerId, double newDebtAmount) async {
    final db = await _dbHelper.database;
    return await db.update(
      Tables.customers,
      {'total_debt': newDebtAmount},
      where: 'id = ?',
      whereArgs: [customerId],
    );
  }

  // Increment customer purchases
  Future<int> incrementCustomerPurchases(int customerId, double amount) async {
    final db = await _dbHelper.database;
    return await db.rawUpdate(
      'UPDATE ${Tables.customers} SET total_purchases = total_purchases + ? WHERE id = ?',
      [amount, customerId],
    );
  }

  // Delete customer
  Future<int> deleteCustomer(int id) async {
    final db = await _dbHelper.database;

    // Check if customer has unpaid debts
    final customer = await getCustomerById(id);
    if (customer != null && customer.totalDebt > 0) {
      throw Exception('Cannot delete customer with unpaid debts');
    }

    return await db.delete(Tables.customers, where: 'id = ?', whereArgs: [id]);
  }

  // Check if phone exists
  Future<bool> phoneExists(String phone, {int? excludeCustomerId}) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.customers,
      where: excludeCustomerId != null ? 'phone = ? AND id != ?' : 'phone = ?',
      whereArgs: excludeCustomerId != null
          ? [phone, excludeCustomerId]
          : [phone],
    );
    return maps.isNotEmpty;
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
}
