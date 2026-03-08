// lib/providers/cart_provider.dart

import 'package:flutter/material.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/product_model.dart';
import '../data/models/customer_model.dart';

class CartProvider with ChangeNotifier {
  List<CartItemModel> _items = [];
  double _discount = 0.0;
  bool _isPercentageDiscount = false;
  CustomerModel? _selectedCustomer;

  List<CartItemModel> get items => _items;
  double get discount => _discount;
  bool get isPercentageDiscount => _isPercentageDiscount;
  CustomerModel? get selectedCustomer => _selectedCustomer;
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.length;

  // Calculate subtotal (before discount)
  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Calculate discount amount
  double get discountAmount {
    if (_isPercentageDiscount) {
      return subtotal * (_discount / 100);
    }
    return _discount;
  }

  // Calculate total (after discount)
  double get total {
    final afterDiscount = subtotal - discountAmount;
    return afterDiscount < 0 ? 0 : afterDiscount;
  }

  // Calculate total profit
  double get totalProfit {
    return _items.fold(0.0, (sum, item) => sum + item.totalProfit);
  }

  // Total items quantity
  int get totalQuantity {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Add product to cart
  void addProduct(ProductModel product, {int quantity = 1}) {
    // Check if product already in cart
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // Product exists, increase quantity
      final existingItem = _items[existingIndex];
      if (existingItem.quantity + quantity <= product.quantity) {
        existingItem.quantity += quantity;
      } else {
        // Can't add more than available stock
        return;
      }
    } else {
      // New product, add to cart
      if (quantity <= product.quantity) {
        _items.add(CartItemModel(product: product, quantity: quantity));
      }
    }

    notifyListeners();
  }

  // Remove product from cart
  void removeProduct(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  // Update item quantity
  bool updateQuantity(int productId, int newQuantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);

    if (index >= 0) {
      if (_items[index].setQuantity(newQuantity)) {
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  // Increment item quantity
  void incrementQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);

    if (index >= 0) {
      _items[index].incrementQuantity();
      notifyListeners();
    }
  }

  // Decrement item quantity
  void decrementQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);

    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].decrementQuantity();
      } else {
        removeProduct(productId);
      }
      notifyListeners();
    }
  }

  // Set discount
  void setDiscount(double discount, {bool isPercentage = false}) {
    _discount = discount;
    _isPercentageDiscount = isPercentage;
    notifyListeners();
  }

  // Clear discount
  void clearDiscount() {
    _discount = 0.0;
    _isPercentageDiscount = false;
    notifyListeners();
  }

  // Set selected customer
  void setCustomer(CustomerModel? customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  // Clear cart
  void clearCart() {
    _items.clear();
    _discount = 0.0;
    _isPercentageDiscount = false;
    _selectedCustomer = null;
    notifyListeners();
  }

  // Check if cart has low stock items
  bool hasLowStockItems() {
    return _items.any((item) => item.exceedsStock);
  }

  // Get cart item by product ID
  CartItemModel? getCartItem(int productId) {
    try {
      return _items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  // Check if product is in cart
  bool isInCart(int productId) {
    return _items.any((item) => item.product.id == productId);
  }
}
