// lib/views/stock/stock_screen.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/providers/stock_provider.dart';
import 'package:phone_shop/core/localization/app_localizations.dart';
import 'package:phone_shop/views/stock/widgets/add_stock_adjustment_dialog.dart';
import 'package:phone_shop/views/stock/widgets/stock_history_dialog.dart';
import 'package:phone_shop/views/stock/widgets/stock_item_card.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/layout/desktop_adaptive.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/product_provider.dart';
import '../shared/main_layout.dart';
import '../shared/themed_screen_sections.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'all'; // all, low_stock, out_of_stock, normal

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
      Provider.of<StockProvider>(context, listen: false).loadAdjustments();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentRoute: AppRoutes.stock,
      child: Column(
        children: [
          // Header Section
          _buildHeader(),
          const Divider(height: 1),

          // Filters Section
          _buildFilters(),
          const Divider(height: 1),

          // Stats Summary
          _buildStatsSummary(),
          const Divider(height: 1),

          // Products List
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (productProvider.products.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildProductsList(productProvider);
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
      color: ThemedScreenSections.surface(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.stock,
                  style: ThemedScreenSections.titleStyle(
                    context,
                    fontSize: desktopPageTitleFontSize(context),
                  ),
                ),
                SizedBox(height: desktopViewportHeight(context) * 0.005),
                Consumer<ProductProvider>(
                  builder: (context, provider, child) {
                    return Text(
                      l10n.productsCountInventory(provider.products.length),
                      style: ThemedScreenSections.subtitleStyle(
                        context,
                        fontSize: desktopPageSubtitleFontSize(context),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Flexible(
            child: ElevatedButton.icon(
              onPressed: _showStockHistory,
              icon: const Icon(Icons.history, size: 20, color: AppColors.white),
              label: Text(l10n.viewHistory,
                  style: const TextStyle(color: AppColors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sidebarBackground,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        desktopPagePadding(context).left,
        12,
        desktopPagePadding(context).right,
        12,
      ),
      color: ThemedScreenSections.surface(context),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.stockSearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _handleSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: _handleSearch,
            ),
          ),

          const SizedBox(width: 16),

          // Stock Filter Dropdown
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedFilter,
              decoration: InputDecoration(
                labelText: l10n.stockStatus,
                prefixIcon: const Icon(Icons.filter_list),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(l10n.allProducts)),
                DropdownMenuItem(
                    value: 'low_stock', child: Text(l10n.lowStock)),
                DropdownMenuItem(
                    value: 'out_of_stock', child: Text(l10n.outOfStock)),
                DropdownMenuItem(
                    value: 'normal', child: Text(l10n.normalStock)),
              ],
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
                _handleFilterChange(value!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final l10n = AppLocalizations.of(context);
        final totalProducts = productProvider.products.length;

        final lowStock = productProvider.products
            .where((p) => p.quantity > 0 && p.quantity <= 10)
            .length;

        final outOfStock =
            productProvider.products.where((p) => p.quantity == 0).length;

        final totalValue = productProvider.products.fold<double>(
          0.0,
          (sum, p) => sum + (p.purchasePrice * p.quantity),
        );

        return Container(
          padding: EdgeInsets.fromLTRB(
            desktopPagePadding(context).left,
            16,
            desktopPagePadding(context).right,
            16,
          ),
          decoration: BoxDecoration(
            color: ThemedScreenSections.subtleSurface(
              context,
              accentColor: AppColors.primary,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  l10n.totalProducts,
                  '$totalProducts',
                  Icons.inventory,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  l10n.lowStock,
                  '$lowStock',
                  Icons.warning_amber,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  l10n.outOfStock,
                  '$outOfStock',
                  Icons.remove_circle,
                  AppColors.error,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  l10n.stockValue,
                  CurrencyFormatter.format(totalValue),
                  Icons.attach_money,
                  AppColors.success,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ThemedScreenSections.cardDecoration(context,
          radius: 8, shadow: false),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemedScreenSections.mutedText(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: ThemedScreenSections.emptyIcon(context),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noProducts,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.stockEmptySubtitle,
            style: TextStyle(
              fontSize: 14,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(ProductProvider productProvider) {
    return ListView.separated(
      padding: desktopPagePadding(context),
      itemCount: productProvider.products.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final product = productProvider.products[index];
        return StockItemCard(
          product: product,
          onAdjust: () => _showAdjustStockDialog(product),
        );
      },
    );
  }

  void _handleSearch(String query) {
    Provider.of<ProductProvider>(context, listen: false).searchProducts(query);
  }

  void _handleFilterChange(String filter) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    switch (filter) {
      case 'low_stock':
        productProvider.filterLowStock();
        break;
      case 'out_of_stock':
        productProvider.filterOutOfStock();
        break;
      case 'normal':
        productProvider.filterNormalStock();
        break;
      case 'all':
      default:
        productProvider.loadProducts();
        break;
    }
  }

  void _showAdjustStockDialog(product) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AddStockAdjustmentDialog(product: product),
    );

    if (result == true) {
      if (mounted) {
        Provider.of<ProductProvider>(context, listen: false).loadProducts();
        Provider.of<StockProvider>(context, listen: false).loadAdjustments();
      }
    }
  }

  void _showStockHistory() {
    showDialog(
      context: context,
      builder: (context) => const StockHistoryDialog(),
    );
  }
}
