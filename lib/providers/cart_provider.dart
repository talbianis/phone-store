// lib/providers/cart_provider.dart

import 'package:flutter/material.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/product_model.dart';
import '../data/models/customer_model.dart';

class CartProvider with ChangeNotifier {
  // Private state
  final List<CartItemModel> _items = [];
  double _discount = 0.0;
  CustomerModel? _selectedCustomer;

  // Getters
  List<CartItemModel> get items => _items;
  double get discount => _discount;
  CustomerModel? get selectedCustomer => _selectedCustomer;

  // Computed properties
  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get isEmpty => _items.isEmpty;

  double get subtotal {
    return _items.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get total {
    return subtotal - _discount;
  }

  double get totalProfit {
    return _items.fold<double>(0.0, (sum, item) => sum + item.totalProfit);
  }

  // Methods

  /// Add product to cart or increase quantity if already exists
  void addProduct(ProductModel product) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // Product already in cart, increase quantity
      final existingItem = _items[existingIndex];
      if (existingItem.quantity < product.quantity) {
        _items[existingIndex] = CartItemModel(
          product: product,
          quantity: existingItem.quantity + 1,
        );
        notifyListeners();
      }
    } else {
      // Add new product to cart
      _items.add(CartItemModel(
        product: product,
        quantity: 1,
      ));
      notifyListeners();
    }
  }

  /// Remove product from cart completely
  void removeProduct(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  /// Update quantity of a product in cart
  void updateQuantity(int productId, int newQuantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);

    if (index >= 0) {
      if (newQuantity <= 0) {
        removeProduct(productId);
      } else if (newQuantity <= _items[index].product.quantity) {
        _items[index] = CartItemModel(
          product: _items[index].product,
          quantity: newQuantity,
        );
        notifyListeners();
      }
    }
  }

  /// Get cart item by product ID
  CartItemModel? getCartItem(int productId) {
    try {
      return _items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  /// Apply discount to cart
  void applyDiscount(double discountAmount) {
    _discount = discountAmount;
    notifyListeners();
  }

  /// Remove discount from cart
  void removeDiscount() {
    _discount = 0.0;
    notifyListeners();
  }

  /// Select customer for this sale
  void selectCustomer(CustomerModel? customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  /// Clear entire cart (items, discount, customer)
  void clearCart() {
    _items.clear();
    _discount = 0.0;
    _selectedCustomer = null;
    notifyListeners();
  }

  /// Clear any error state
  void clearError() {
    notifyListeners();
  }
}
