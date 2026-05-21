// lib/providers/product_provider.dart

import 'package:flutter/material.dart';
import '../data/models/product_model.dart';
import '../data/repositories/product_repository.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = false;
  bool _hasLoaded = false;
  String _searchQuery = '';
  bool _availableNameOnly = false;
  String? _errorMessage;

  List<ProductModel> get products => _filteredProducts;
  List<ProductModel> get allProducts => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  bool get hasLoaded => _hasLoaded;
  String? get errorMessage => _errorMessage;

  // Load all products
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _repository.getAllProducts();
      _applySearch();
      _hasLoaded = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load products: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> ensureProductsLoaded() async {
    if (_hasLoaded || _isLoading) return;
    await loadProducts();
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
    _searchQuery = query.trim();
    _availableNameOnly = false;
    _applySearch();
    notifyListeners();
  }

  void searchAvailableProductsByName(String query) {
    _searchQuery = query.trim();
    _availableNameOnly = true;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredProducts = List<ProductModel>.from(_products);
    } else {
      final lowerQuery = _searchQuery.toLowerCase();
      if (_availableNameOnly) {
        _filteredProducts = _products
            .where(
              (product) =>
                  product.quantity > 0 &&
                  product.name.toLowerCase().contains(lowerQuery),
            )
            .toList();
      } else {
        _filteredProducts = _products
            .where(
              (product) =>
                  product.name.toLowerCase().contains(lowerQuery) ||
                  (product.brand?.toLowerCase().contains(lowerQuery) ??
                      false) ||
                  (product.barcode?.contains(_searchQuery) ?? false),
            )
            .toList();
      }
    }
  }

  // Filter by category
  void filterByCategory(int? categoryId) {
    if (categoryId == null) {
      _filteredProducts = _products;
    } else {
      _filteredProducts =
          _products.where((p) => p.categoryId == categoryId).toList();
    }
    notifyListeners();
  }

  void filterLowStock() {
    _filteredProducts = _products
        .where((product) => product.quantity > 0 && product.quantity <= 10)
        .toList();
    notifyListeners();
  }

  /// Filter out of stock products (quantity == 0)
  void filterOutOfStock() {
    _filteredProducts =
        _products.where((product) => product.quantity == 0).toList();
    notifyListeners();
  }

  /// Filter normal stock products (quantity > 10)
  void filterNormalStock() {
    _filteredProducts =
        _products.where((product) => product.quantity > 10).toList();
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
