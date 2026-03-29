// lib/views/pos/pos_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/product_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/customer_provider.dart';
import '../shared/main_layout.dart';
import 'widgets/product_search_bar.dart';
import 'widgets/product_grid_item.dart';
import 'widgets/cart_section.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({Key? key}) : super(key: key);

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
      Provider.of<CategoryProvider>(context, listen: false).loadCategories();
      Provider.of<CustomerProvider>(context, listen: false).loadCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentRoute: AppRoutes.pos,
      child: Column(
        children: [
          // Header
          _buildHeader(),
          const Divider(height: 1),

          // Main Content
          Expanded(
            child: Row(
              children: [
                // Left Side - Product Selection (60%)
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.grey[50],
                    child: Column(
                      children: [
                        // Search Bar
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: ProductSearchBar(
                            onProductSelected: _addProductToCart,
                          ),
                        ),

                        // Category Filter
                        _buildCategoryFilter(),

                        // Product Grid
                        Expanded(
                          child: _buildProductGrid(),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right Side - Cart (40%)
                Expanded(
                  flex: 2,
                  child: CartSection(
                    onCheckout: _handleCheckout,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Point of Sale',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Scan or select products to add to cart',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Clear Cart Button
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return OutlinedButton.icon(
                onPressed: cartProvider.isEmpty
                    ? null
                    : () => _clearCart(cartProvider),
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear Cart'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // All Categories
                _buildCategoryChip(
                  label: 'All Products',
                  isSelected: _selectedCategoryId == null,
                  onTap: () {
                    setState(() => _selectedCategoryId = null);
                    Provider.of<ProductProvider>(context, listen: false)
                        .filterByCategory(null);
                  },
                ),

                const SizedBox(width: 8),

                // Category Chips
                ...categoryProvider.categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildCategoryChip(
                      label: category.name,
                      isSelected: _selectedCategoryId == category.id,
                      onTap: () {
                        setState(() => _selectedCategoryId = category.id);
                        Provider.of<ProductProvider>(context, listen: false)
                            .filterByCategory(category.id);
                      },
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.white,
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : Colors.grey[300]!,
      ),
    );
  }

  Widget _buildProductGrid() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (productProvider.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No products available',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        // Filter out of stock products
        final availableProducts = productProvider.products
            .where((product) => product.quantity > 0)
            .toList();

        if (availableProducts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.remove_shopping_cart,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No products in stock',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: availableProducts.length,
          itemBuilder: (context, index) {
            final product = availableProducts[index];
            return ProductGridItem(
              product: product,
              onTap: () => _addProductToCart(product),
            );
          },
        );
      },
    );
  }

  void _addProductToCart(product) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Check if product is already in cart at max quantity
    final existingItem = cartProvider.getCartItem(product.id!);
    if (existingItem != null && existingItem.quantity >= product.quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot add more. Only ${product.quantity} in stock.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    cartProvider.addProduct(product);

    // Show brief feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        width: 300,
      ),
    );
  }

  void _clearCart(CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
            'Are you sure you want to remove all items from the cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              cartProvider.clearCart();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Clear Cart'),
          ),
        ],
      ),
    );
  }

  void _handleCheckout() {
    // This will be handled in the CartSection widget
    // We'll implement the payment dialog there
  }
}
