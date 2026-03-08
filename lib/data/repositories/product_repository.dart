// lib/data/repositories/product_repository.dart

import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/tables.dart';
import '../models/product_model.dart';

class ProductRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create product
  Future<int> createProduct(ProductModel product) async {
    final db = await _dbHelper.database;
    return await db.insert(Tables.products, product.toMap());
  }

  // Get all products
  Future<List<ProductModel>> getAllProducts() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.products,
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
  }

  // Get product by ID
  Future<ProductModel?> getProductById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.products,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return ProductModel.fromMap(maps.first);
  }

  // Get products by category
  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.products,
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
  }

  // Search products
  Future<List<ProductModel>> searchProducts(String query) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.products,
      where: 'name LIKE ? OR barcode LIKE ? OR brand LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
  }

  // Get low stock products
  Future<List<ProductModel>> getLowStockProducts() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.products,
      where: 'quantity <= min_quantity AND quantity > 0',
      orderBy: 'quantity ASC',
    );
    return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
  }

  // Get out of stock products
  Future<List<ProductModel>> getOutOfStockProducts() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.products,
      where: 'quantity <= 0',
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
  }

  // Update product
  Future<int> updateProduct(ProductModel product) async {
    final db = await _dbHelper.database;
    return await db.update(
      Tables.products,
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Update stock quantity
  Future<int> updateStock(int productId, int newQuantity) async {
    final db = await _dbHelper.database;
    return await db.update(
      Tables.products,
      {'quantity': newQuantity, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  // Delete product
  Future<int> deleteProduct(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(Tables.products, where: 'id = ?', whereArgs: [id]);
  }

  // Get product count
  Future<int> getProductCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${Tables.products}',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Check if barcode exists
  Future<bool> barcodeExists(String barcode, {int? excludeProductId}) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      Tables.products,
      where: excludeProductId != null
          ? 'barcode = ? AND id != ?'
          : 'barcode = ?',
      whereArgs: excludeProductId != null
          ? [barcode, excludeProductId]
          : [barcode],
    );
    return maps.isNotEmpty;
  }
}
