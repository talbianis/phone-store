// lib/data/models/cart_item_model.dart

import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({required this.product, this.quantity = 1});

  // Calculate total price for this item
  double get totalPrice => product.sellingPrice * quantity;

  // Calculate total profit for this item
  double get totalProfit => product.profitPerUnit * quantity;

  // Check if quantity exceeds available stock
  bool get exceedsStock => quantity > product.quantity;

  // Increment quantity
  void incrementQuantity() {
    if (quantity < product.quantity) {
      quantity++;
    }
  }

  // Decrement quantity
  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }

  // Set quantity with validation
  bool setQuantity(int newQuantity) {
    if (newQuantity > 0 && newQuantity <= product.quantity) {
      quantity = newQuantity;
      return true;
    }
    return false;
  }

  // Copy with method
  CartItemModel copyWith({ProductModel? product, int? quantity}) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'CartItemModel(product: ${product.name}, qty: $quantity, total: $totalPrice DA)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItemModel && other.product.id == product.id;
  }

  @override
  int get hashCode => product.id.hashCode;
}
