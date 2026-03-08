// lib/data/repositories/sale_repository.dart

import 'package:phone_shop/data/models/sales_item_model.dart';
import 'package:phone_shop/data/models/sales_model.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/tables.dart';

class SaleRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create sale with items (transaction)
  Future<int> createSale(SaleModel sale, List<SaleItemModel> items) async {
    final db = await _dbHelper.database;

    return await db.transaction((txn) async {
      // 1. Insert sale
      final saleId = await txn.insert(Tables.sales, sale.toMap());

      // 2. Insert sale items
      for (var item in items) {
        final itemWithSaleId = item.copyWith(saleId: saleId);
        await txn.insert(Tables.saleItems, itemWithSaleId.toMap());

        // 3. Update product stock
        await txn.rawUpdate(
          'UPDATE ${Tables.products} SET quantity = quantity - ?, updated_at = ? WHERE id = ?',
          [item.quantity, DateTime.now().toIso8601String(), item.productId],
        );
      }

      // 4. Update customer if provided
      if (sale.customerId != null) {
        await txn.rawUpdate(
          'UPDATE ${Tables.customers} SET total_purchases = total_purchases + ?, total_debt = total_debt + ? WHERE id = ?',
          [sale.total, sale.remainingDebt, sale.customerId],
        );
      }

      return saleId;
    });
  }

  // Get all sales
  Future<List<SaleModel>> getAllSales() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT s.*, c.name as customer_name, u.full_name as user_name
      FROM ${Tables.sales} s
      LEFT JOIN ${Tables.customers} c ON s.customer_id = c.id
      LEFT JOIN ${Tables.users} u ON s.user_id = u.id
      ORDER BY s.sale_date DESC
    ''');
    return List.generate(maps.length, (i) => SaleModel.fromMap(maps[i]));
  }

  // Get sale by ID
  Future<SaleModel?> getSaleById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT s.*, c.name as customer_name, u.full_name as user_name
      FROM ${Tables.sales} s
      LEFT JOIN ${Tables.customers} c ON s.customer_id = c.id
      LEFT JOIN ${Tables.users} u ON s.user_id = u.id
      WHERE s.id = ?
    ''',
      [id],
    );

    if (maps.isEmpty) return null;
    return SaleModel.fromMap(maps.first);
  }

  // Get sale by invoice number
  Future<SaleModel?> getSaleByInvoiceNumber(String invoiceNumber) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT s.*, c.name as customer_name, u.full_name as user_name
      FROM ${Tables.sales} s
      LEFT JOIN ${Tables.customers} c ON s.customer_id = c.id
      LEFT JOIN ${Tables.users} u ON s.user_id = u.id
      WHERE s.invoice_number = ?
    ''',
      [invoiceNumber],
    );

    if (maps.isEmpty) return null;
    return SaleModel.fromMap(maps.first);
  }

  // Get sale items for a sale
  Future<List<SaleItemModel>> getSaleItems(int saleId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.saleItems,
      where: 'sale_id = ?',
      whereArgs: [saleId],
    );
    return List.generate(maps.length, (i) => SaleItemModel.fromMap(maps[i]));
  }

  // Get sales by date range
  Future<List<SaleModel>> getSalesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT s.*, c.name as customer_name, u.full_name as user_name
      FROM ${Tables.sales} s
      LEFT JOIN ${Tables.customers} c ON s.customer_id = c.id
      LEFT JOIN ${Tables.users} u ON s.user_id = u.id
      WHERE DATE(s.sale_date) BETWEEN DATE(?) AND DATE(?)
      ORDER BY s.sale_date DESC
    ''',
      [startDate.toIso8601String(), endDate.toIso8601String()],
    );

    return List.generate(maps.length, (i) => SaleModel.fromMap(maps[i]));
  }

  // Get today's sales
  Future<List<SaleModel>> getTodaySales() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    return await getSalesByDateRange(today, tomorrow);
  }

  // Get sales for current month
  Future<List<SaleModel>> getMonthSales() async {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    return await getSalesByDateRange(firstDayOfMonth, lastDayOfMonth);
  }

  // Get sales by customer
  Future<List<SaleModel>> getSalesByCustomer(int customerId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT s.*, c.name as customer_name, u.full_name as user_name
      FROM ${Tables.sales} s
      LEFT JOIN ${Tables.customers} c ON s.customer_id = c.id
      LEFT JOIN ${Tables.users} u ON s.user_id = u.id
      WHERE s.customer_id = ?
      ORDER BY s.sale_date DESC
    ''',
      [customerId],
    );

    return List.generate(maps.length, (i) => SaleModel.fromMap(maps[i]));
  }

  // Search sales
  Future<List<SaleModel>> searchSales(String query) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT s.*, c.name as customer_name, u.full_name as user_name
      FROM ${Tables.sales} s
      LEFT JOIN ${Tables.customers} c ON s.customer_id = c.id
      LEFT JOIN ${Tables.users} u ON s.user_id = u.id
      WHERE s.invoice_number LIKE ? OR c.name LIKE ?
      ORDER BY s.sale_date DESC
    ''',
      ['%$query%', '%$query%'],
    );

    return List.generate(maps.length, (i) => SaleModel.fromMap(maps[i]));
  }

  // Get total sales amount
  Future<double> getTotalSalesAmount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(total) as total FROM ${Tables.sales}',
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // Get total sales for today
  Future<double> getTodaySalesAmount() async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final result = await db.rawQuery(
      'SELECT SUM(total) as total FROM ${Tables.sales} WHERE DATE(sale_date) = DATE(?)',
      [today.toIso8601String()],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // Get total profit for today
  Future<double> getTodayProfit() async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final result = await db.rawQuery(
      'SELECT SUM(profit) as profit FROM ${Tables.sales} WHERE DATE(sale_date) = DATE(?)',
      [today.toIso8601String()],
    );
    return (result.first['profit'] as num?)?.toDouble() ?? 0.0;
  }

  // Get total profit for current month
  Future<double> getMonthProfit() async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    final result = await db.rawQuery(
      'SELECT SUM(profit) as profit FROM ${Tables.sales} WHERE DATE(sale_date) >= DATE(?)',
      [firstDayOfMonth.toIso8601String()],
    );
    return (result.first['profit'] as num?)?.toDouble() ?? 0.0;
  }

  // Get sales count for today
  Future<int> getTodaySalesCount() async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${Tables.sales} WHERE DATE(sale_date) = DATE(?)',
      [today.toIso8601String()],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Generate unique invoice number
  Future<String> generateInvoiceNumber() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${Tables.sales}',
    );
    final count = Sqflite.firstIntValue(result) ?? 0;
    final invoiceNumber = 'INV-${(count + 1).toString().padLeft(6, '0')}';
    return invoiceNumber;
  }

  // Get last 7 days sales data (for chart)
  Future<List<Map<String, dynamic>>> getLast7DaysSales() async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 6));

    final result = await db.rawQuery(
      '''
      SELECT 
        DATE(sale_date) as date,
        SUM(total) as sales,
        SUM(profit) as profit
      FROM ${Tables.sales}
      WHERE DATE(sale_date) >= DATE(?)
      GROUP BY DATE(sale_date)
      ORDER BY date ASC
    ''',
      [sevenDaysAgo.toIso8601String()],
    );

    return result;
  }

  // Delete sale (admin only, rarely used)
  Future<int> deleteSale(int id) async {
    final db = await _dbHelper.database;

    return await db.transaction((txn) async {
      // Get sale items first to restore stock
      final items = await getSaleItems(id);

      // Restore product stock
      for (var item in items) {
        await txn.rawUpdate(
          'UPDATE ${Tables.products} SET quantity = quantity + ?, updated_at = ? WHERE id = ?',
          [item.quantity, DateTime.now().toIso8601String(), item.productId],
        );
      }

      // Delete sale (sale_items will be deleted automatically with CASCADE)
      return await txn.delete(Tables.sales, where: 'id = ?', whereArgs: [id]);
    });
  }
}
