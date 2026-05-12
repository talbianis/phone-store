// lib/views/pos/pos_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/layout/desktop_adaptive.dart';
import '../../core/localization/app_localizations.dart';
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                final stackVertical = constraints.maxWidth < 780;
                final leftPane = Container(
                  color: Colors.grey[50],
                  child: Column(
                    children: [
                      Padding(
                        padding: desktopPagePadding(context).copyWith(
                          bottom: 12,
                          top: 12,
                        ),
                        child: ProductSearchBar(
                          onProductSelected: _addProductToCart,
                        ),
                      ),
                      _buildCategoryFilter(),
                      Expanded(
                        child: _buildProductGrid(),
                      ),
                    ],
                  ),
                );
                final cartPane = CartSection(
                  onCheckout: _handleCheckout,
                );
                if (stackVertical) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 3, child: leftPane),
                      const Divider(height: 1),
                      Expanded(flex: 2, child: cartPane),
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 3, child: leftPane),
                    Expanded(flex: 2, child: cartPane),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: desktopPagePadding(context),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.pos,
                  style: TextStyle(
                    fontSize: desktopPageTitleFontSize(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: desktopViewportHeight(context) * 0.005),
                Text(
                  l10n.posSubtitle,
                  style: TextStyle(
                    fontSize: desktopPageSubtitleFontSize(context),
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
                label: Text(AppLocalizations.of(context).clearCart),
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
    final l10n = AppLocalizations.of(context);
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
                  label: l10n.allProductsPos,
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
        final l10n = AppLocalizations.of(context);
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
                  l10n.noProductsAvailable,
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
                  l10n.noProductsInStockPos,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            int crossCount = 3;
            if (w >= 1100) {
              crossCount = 5;
            } else if (w >= 820) {
              crossCount = 4;
            } else if (w >= 520) {
              crossCount = 3;
            } else if (w >= 340) {
              crossCount = 2;
            } else {
              crossCount = 1;
            }
            final aspect = crossCount >= 4 ? 0.82 : 0.85;

            return GridView.builder(
              padding: desktopPagePadding(context).copyWith(top: 8, bottom: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: aspect,
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
      },
    );
  }

  void _addProductToCart(product) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context);

    // Check if product is already in cart at max quantity
    final existingItem = cartProvider.getCartItem(product.id!);
    if (existingItem != null && existingItem.quantity >= product.quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.cannotAddMoreInStockCount(product.quantity)),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    cartProvider.addProduct(product);

    // Show brief feedback
    final mq = MediaQuery.sizeOf(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.productAddedToCartName(product.name)),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        width: (mq.width * 0.28).clamp(260.0, 440.0),
      ),
    );
  }

  void _clearCart(CartProvider cartProvider) {
    final parentL10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(parentL10n.clearCart),
          content: Text(parentL10n.clearCartConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                cartProvider.clearCart();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(l10n.clearCart),
            ),
          ],
        );
      },
    );
  }

  void _handleCheckout() {
    // This will be handled in the CartSection widget
    // We'll implement the payment dialog there
  }
}
