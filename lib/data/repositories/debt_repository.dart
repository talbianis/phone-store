// lib/data/repositories/debt_repository.dart

import 'package:phone_shop/data/models/debt_payement_model.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/tables.dart';
import '../models/debt_model.dart';

class DebtRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create debt
  Future<int> createDebt(DebtModel debt) async {
    final db = await _dbHelper.database;
    return await db.insert(Tables.debts, debt.toMap());
  }

  // Get all debts
  Future<List<DebtModel>> getAllDebts() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT d.*, c.name as customer_name, c.phone as customer_phone, s.invoice_number
      FROM ${Tables.debts} d
      LEFT JOIN ${Tables.customers} c ON d.customer_id = c.id
      LEFT JOIN ${Tables.sales} s ON d.sale_id = s.id
      ORDER BY d.created_at DESC
    ''');
    return List.generate(maps.length, (i) => DebtModel.fromMap(maps[i]));
  }

  // Get unpaid debts
  Future<List<DebtModel>> getUnpaidDebts() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT d.*, c.name as customer_name, c.phone as customer_phone, s.invoice_number
      FROM ${Tables.debts} d
      LEFT JOIN ${Tables.customers} c ON d.customer_id = c.id
      LEFT JOIN ${Tables.sales} s ON d.sale_id = s.id
      WHERE d.remaining_amount > 0
      ORDER BY d.created_at DESC
    ''');
    return List.generate(maps.length, (i) => DebtModel.fromMap(maps[i]));
  }

  // Get debt by ID
  Future<DebtModel?> getDebtById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT d.*, c.name as customer_name, c.phone as customer_phone, s.invoice_number
      FROM ${Tables.debts} d
      LEFT JOIN ${Tables.customers} c ON d.customer_id = c.id
      LEFT JOIN ${Tables.sales} s ON d.sale_id = s.id
      WHERE d.id = ?
    ''',
      [id],
    );

    if (maps.isEmpty) return null;
    return DebtModel.fromMap(maps.first);
  }

  // Get debts by customer
  Future<List<DebtModel>> getDebtsByCustomer(int customerId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT d.*, c.name as customer_name, c.phone as customer_phone, s.invoice_number
      FROM ${Tables.debts} d
      LEFT JOIN ${Tables.customers} c ON d.customer_id = c.id
      LEFT JOIN ${Tables.sales} s ON d.sale_id = s.id
      WHERE d.customer_id = ?
      ORDER BY d.created_at DESC
    ''',
      [customerId],
    );

    return List.generate(maps.length, (i) => DebtModel.fromMap(maps[i]));
  }

  // Add payment to debt
  Future<int> addPayment(DebtPaymentModel payment, int debtId) async {
    final db = await _dbHelper.database;

    return await db.transaction((txn) async {
      // 1. Insert payment
      final paymentId = await txn.insert(Tables.debtPayments, payment.toMap());

      // 2. Update debt
      await txn.rawUpdate(
        '''
        UPDATE ${Tables.debts}
        SET 
          paid_amount = paid_amount + ?,
          remaining_amount = remaining_amount - ?,
          status = CASE 
            WHEN remaining_amount - ? <= 0 THEN 'paid'
            WHEN paid_amount + ? > 0 THEN 'partial'
            ELSE 'unpaid'
          END
        WHERE id = ?
      ''',
        [
          payment.amount,
          payment.amount,
          payment.amount,
          payment.amount,
          debtId,
        ],
      );

      // 3. Update customer total debt
      final debt = await getDebtById(debtId);
      if (debt != null) {
        await txn.rawUpdate(
          'UPDATE ${Tables.customers} SET total_debt = total_debt - ? WHERE id = ?',
          [payment.amount, debt.customerId],
        );
      }

      return paymentId;
    });
  }

  // Get payment history for a debt
  Future<List<DebtPaymentModel>> getPaymentHistory(int debtId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.debtPayments,
      where: 'debt_id = ?',
      whereArgs: [debtId],
      orderBy: 'payment_date DESC',
    );
    return List.generate(maps.length, (i) => DebtPaymentModel.fromMap(maps[i]));
  }

  // Update debt
  Future<int> updateDebt(DebtModel debt) async {
    final db = await _dbHelper.database;
    return await db.update(
      Tables.debts,
      debt.toMap(),
      where: 'id = ?',
      whereArgs: [debt.id],
    );
  }

  // Get total debt amount
  Future<double> getTotalDebtAmount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(remaining_amount) as total FROM ${Tables.debts}',
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // Get debt count
  Future<int> getDebtCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${Tables.debts} WHERE remaining_amount > 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Delete debt (rarely used)
  Future<int> deleteDebt(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(Tables.debts, where: 'id = ?', whereArgs: [id]);
  }
}
