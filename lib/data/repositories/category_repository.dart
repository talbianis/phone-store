// lib/data/repositories/category_repository.dart

import 'package:phone_shop/data/models/category_model.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/tables.dart';

class CategoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create category
  Future<int> createCategory(CategoryModel category) async {
    final db = await _dbHelper.database;
    return await db.insert(Tables.categories, category.toMap());
  }

  // Get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.categories,
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }

  // Get category by ID
  Future<CategoryModel?> getCategoryById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.categories,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return CategoryModel.fromMap(maps.first);
  }

  // Get category by name
  Future<CategoryModel?> getCategoryByName(String name) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.categories,
      where: 'name = ?',
      whereArgs: [name],
    );
    if (maps.isEmpty) return null;
    return CategoryModel.fromMap(maps.first);
  }

  // Update category
  Future<int> updateCategory(CategoryModel category) async {
    final db = await _dbHelper.database;
    return await db.update(
      Tables.categories,
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  // Delete category
  Future<int> deleteCategory(int id) async {
    final db = await _dbHelper.database;

    // Check if category has products
    final productCount = await _getProductCountByCategory(id);
    if (productCount > 0) {
      throw Exception('Cannot delete category with existing products');
    }

    return await db.delete(Tables.categories, where: 'id = ?', whereArgs: [id]);
  }

  // Get product count for a category
  Future<int> _getProductCountByCategory(int categoryId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${Tables.products} WHERE category_id = ?',
      [categoryId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Get category count
  Future<int> getCategoryCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${Tables.categories}',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Check if category name exists (for validation)
  Future<bool> categoryExists(String name, {int? excludeCategoryId}) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.categories,
      where: excludeCategoryId != null ? 'name = ? AND id != ?' : 'name = ?',
      whereArgs: excludeCategoryId != null ? [name, excludeCategoryId] : [name],
    );
    return maps.isNotEmpty;
  }

  // Search categories
  Future<List<CategoryModel>> searchCategories(String query) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.categories,
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }
}
