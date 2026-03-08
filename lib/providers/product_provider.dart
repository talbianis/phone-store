// lib/providers/product_provider.dart

import 'package:flutter/material.dart';
import '../data/models/product_model.dart';
import '../data/repositories/product_repository.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load all products
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _repository.getAllProducts();
      _filteredProducts = _products;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load products: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add product
  Future<bool> addProduct(ProductModel product) async {
    try {
      await _repository.createProduct(product);
      await loadProducts();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add product: $e';
      notifyListeners();
      return false;
    }
  }

  // Update product
  Future<bool> updateProduct(ProductModel product) async {
    try {
      await _repository.updateProduct(product);
      await loadProducts();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update product: $e';
      notifyListeners();
      return false;
    }
  }

  // Delete product
  Future<bool> deleteProduct(int id) async {
    try {
      await _repository.deleteProduct(id);
      await loadProducts();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete product: $e';
      notifyListeners();
      return false;
    }
  }

  // Search products
  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products
          .where(
            (product) =>
                product.name.toLowerCase().contains(query.toLowerCase()) ||
                (product.brand?.toLowerCase().contains(query.toLowerCase()) ??
                    false) ||
                (product.barcode?.contains(query) ?? false),
          )
          .toList();
    }
    notifyListeners();
  }

  // Filter by category
  void filterByCategory(int? categoryId) {
    if (categoryId == null) {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products
          .where((p) => p.categoryId == categoryId)
          .toList();
    }
    notifyListeners();
  }

  // Get low stock count
  int getLowStockCount() {
    return _products.where((p) => p.isLowStock).length;
  }

  // Get out of stock count
  int getOutOfStockCount() {
    return _products.where((p) => p.isOutOfStock).length;
  }
}
