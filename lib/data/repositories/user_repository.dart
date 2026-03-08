// lib/data/repositories/user_repository.dart

import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/tables.dart';
import '../models/user_model.dart';

class UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create user
  Future<int> createUser(UserModel user) async {
    final db = await _dbHelper.database;
    return await db.insert(Tables.users, user.toMap());
  }

  // Get all users
  Future<List<UserModel>> getAllUsers() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.users,
      orderBy: 'full_name ASC',
    );
    return List.generate(maps.length, (i) => UserModel.fromMap(maps[i]));
  }

  // Get user by ID
  Future<UserModel?> getUserById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.users,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  // Get user by username
  Future<UserModel?> getUserByUsername(String username) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.users,
      where: 'username = ?',
      whereArgs: [username],
    );
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  // Login user (validate credentials)
  Future<UserModel?> login(String username, String password) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.users,
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  // Update user
  Future<int> updateUser(UserModel user) async {
    final db = await _dbHelper.database;
    return await db.update(
      Tables.users,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Change password
  Future<int> changePassword(int userId, String newPassword) async {
    final db = await _dbHelper.database;
    return await db.update(
      Tables.users,
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Delete user
  Future<int> deleteUser(int id) async {
    final db = await _dbHelper.database;

    // Prevent deleting the last admin
    final adminCount = await _getAdminCount();
    final user = await getUserById(id);

    if (user != null && user.isAdmin && adminCount <= 1) {
      throw Exception('Cannot delete the last admin user');
    }

    return await db.delete(Tables.users, where: 'id = ?', whereArgs: [id]);
  }

  // Get admin count
  Future<int> _getAdminCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${Tables.users} WHERE role = ?',
      ['admin'],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Check if username exists
  Future<bool> usernameExists(String username, {int? excludeUserId}) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.users,
      where: excludeUserId != null
          ? 'username = ? AND id != ?'
          : 'username = ?',
      whereArgs: excludeUserId != null ? [username, excludeUserId] : [username],
    );
    return maps.isNotEmpty;
  }

  // Get user count
  Future<int> getUserCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${Tables.users}',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Get users by role
  Future<List<UserModel>> getUsersByRole(String role) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.users,
      where: 'role = ?',
      whereArgs: [role],
      orderBy: 'full_name ASC',
    );
    return List.generate(maps.length, (i) => UserModel.fromMap(maps[i]));
  }
}
