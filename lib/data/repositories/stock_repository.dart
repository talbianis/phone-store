// lib/data/repositories/stock_repository.dart

import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/tables.dart';
import '../models/stock_adjustment_model.dart';

class StockRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create stock adjustment
  Future<int> createStockAdjustment(StockAdjustmentModel adjustment) async {
    final db = await _dbHelper.database;

    return await db.transaction((txn) async {
      // 1. Insert stock adjustment record
      final adjustmentId = await txn.insert(
        Tables.stockAdjustments,
        adjustment.toMap(),
      );

      // 2. Update product quantity
      await txn.rawUpdate(
        'UPDATE ${Tables.products} SET quantity = quantity + ?, updated_at = ? WHERE id = ?',
        [
          adjustment.quantityChange,
          DateTime.now().toIso8601String(),
          adjustment.productId,
        ],
      );

      return adjustmentId;
    });
  }

  // Get all stock adjustments
  Future<List<StockAdjustmentModel>> getAllAdjustments() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT sa.*, p.name as product_name, u.full_name as user_name
      FROM ${Tables.stockAdjustments} sa
      LEFT JOIN ${Tables.products} p ON sa.product_id = p.id
      LEFT JOIN ${Tables.users} u ON sa.user_id = u.id
      ORDER BY sa.adjustment_date DESC
    ''');
    return List.generate(
      maps.length,
      (i) => StockAdjustmentModel.fromMap(maps[i]),
    );
  }

  // Get adjustments by product
  Future<List<StockAdjustmentModel>> getAdjustmentsByProduct(
    int productId,
  ) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT sa.*, p.name as product_name, u.full_name as user_name
      FROM ${Tables.stockAdjustments} sa
      LEFT JOIN ${Tables.products} p ON sa.product_id = p.id
      LEFT JOIN ${Tables.users} u ON sa.user_id = u.id
      WHERE sa.product_id = ?
      ORDER BY sa.adjustment_date DESC
    ''',
      [productId],
    );

    return List.generate(
      maps.length,
      (i) => StockAdjustmentModel.fromMap(maps[i]),
    );
  }

  // Get adjustments by date range
  Future<List<StockAdjustmentModel>> getAdjustmentsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT sa.*, p.name as product_name, u.full_name as user_name
      FROM ${Tables.stockAdjustments} sa
      LEFT JOIN ${Tables.products} p ON sa.product_id = p.id
      LEFT JOIN ${Tables.users} u ON sa.user_id = u.id
      WHERE DATE(sa.adjustment_date) BETWEEN DATE(?) AND DATE(?)
      ORDER BY sa.adjustment_date DESC
    ''',
      [startDate.toIso8601String(), endDate.toIso8601String()],
    );

    return List.generate(
      maps.length,
      (i) => StockAdjustmentModel.fromMap(maps[i]),
    );
  }

  // Get adjustments by reason
  Future<List<StockAdjustmentModel>> getAdjustmentsByReason(
    String reason,
  ) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT sa.*, p.name as product_name, u.full_name as user_name
      FROM ${Tables.stockAdjustments} sa
      LEFT JOIN ${Tables.products} p ON sa.product_id = p.id
      LEFT JOIN ${Tables.users} u ON sa.user_id = u.id
      WHERE sa.reason = ?
      ORDER BY sa.adjustment_date DESC
    ''',
      [reason],
    );

    return List.generate(
      maps.length,
      (i) => StockAdjustmentModel.fromMap(maps[i]),
    );
  }

  // Get recent adjustments
  Future<List<StockAdjustmentModel>> getRecentAdjustments({
    int limit = 20,
  }) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT sa.*, p.name as product_name, u.full_name as user_name
      FROM ${Tables.stockAdjustments} sa
      LEFT JOIN ${Tables.products} p ON sa.product_id = p.id
      LEFT JOIN ${Tables.users} u ON sa.user_id = u.id
      ORDER BY sa.adjustment_date DESC
      LIMIT ?
    ''',
      [limit],
    );

    return List.generate(
      maps.length,
      (i) => StockAdjustmentModel.fromMap(maps[i]),
    );
  }

  // Get adjustment count
  Future<int> getAdjustmentCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${Tables.stockAdjustments}',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Delete stock adjustment (rarely used, admin only)
  Future<int> deleteAdjustment(int id) async {
    final db = await _dbHelper.database;

    return await db.transaction((txn) async {
      // Get adjustment to reverse the quantity change
      final maps = await txn.query(
        Tables.stockAdjustments,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) return 0;

      final adjustment = StockAdjustmentModel.fromMap(maps.first);

      // Reverse the quantity change
      await txn.rawUpdate(
        'UPDATE ${Tables.products} SET quantity = quantity - ?, updated_at = ? WHERE id = ?',
        [
          adjustment.quantityChange,
          DateTime.now().toIso8601String(),
          adjustment.productId,
        ],
      );

      // Delete the adjustment record
      return await txn.delete(
        Tables.stockAdjustments,
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }
}
