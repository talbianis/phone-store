// lib/data/repositories/expense_repository.dart

import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/tables.dart';
import '../models/expense_model.dart';

class ExpenseRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create expense
  Future<int> createExpense(ExpenseModel expense) async {
    final db = await _dbHelper.database;
    return await db.insert(Tables.expenses, expense.toMap());
  }

  // Get all expenses
  Future<List<ExpenseModel>> getAllExpenses() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.expenses,
      orderBy: 'expense_date DESC',
    );
    return List.generate(maps.length, (i) => ExpenseModel.fromMap(maps[i]));
  }

  // Get expense by ID
  Future<ExpenseModel?> getExpenseById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.expenses,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return ExpenseModel.fromMap(maps.first);
  }

  // Get expenses by date range
  Future<List<ExpenseModel>> getExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.expenses,
      where: 'DATE(expense_date) BETWEEN DATE(?) AND DATE(?)',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'expense_date DESC',
    );
    return List.generate(maps.length, (i) => ExpenseModel.fromMap(maps[i]));
  }

  // Get today's expenses
  Future<List<ExpenseModel>> getTodayExpenses() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    return await getExpensesByDateRange(today, tomorrow);
  }

  // Get current month expenses
  Future<List<ExpenseModel>> getMonthExpenses() async {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    return await getExpensesByDateRange(firstDayOfMonth, lastDayOfMonth);
  }

  // Get expenses by category
  Future<List<ExpenseModel>> getExpensesByCategory(String category) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.expenses,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'expense_date DESC',
    );
    return List.generate(maps.length, (i) => ExpenseModel.fromMap(maps[i]));
  }

  // Update expense
  Future<int> updateExpense(ExpenseModel expense) async {
    final db = await _dbHelper.database;
    return await db.update(
      Tables.expenses,
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  // Delete expense
  Future<int> deleteExpense(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(Tables.expenses, where: 'id = ?', whereArgs: [id]);
  }

  // Get total expenses amount
  Future<double> getTotalExpensesAmount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM ${Tables.expenses}',
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // Get today's expenses total
  Future<double> getTodayExpensesAmount() async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM ${Tables.expenses} WHERE DATE(expense_date) = DATE(?)',
      [today.toIso8601String()],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // Get current month expenses total
  Future<double> getMonthExpensesAmount() async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM ${Tables.expenses} WHERE DATE(expense_date) >= DATE(?)',
      [firstDayOfMonth.toIso8601String()],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // Get expenses by category summary
  Future<Map<String, double>> getExpensesByCategorySummary() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT category, SUM(amount) as total
      FROM ${Tables.expenses}
      GROUP BY category
    ''');

    final Map<String, double> summary = {};
    for (var row in result) {
      summary[row['category'] as String] = (row['total'] as num).toDouble();
    }
    return summary;
  }

  // Get expense count
  Future<int> getExpenseCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${Tables.expenses}',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
