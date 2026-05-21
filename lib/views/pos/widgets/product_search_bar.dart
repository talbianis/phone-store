// lib/views/pos/widgets/product_search_bar.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../data/models/product_model.dart';
import '../../../providers/product_provider.dart';

class ProductSearchBar extends StatefulWidget {
  final Function(ProductModel) onProductSelected;

  const ProductSearchBar({
    super.key,
    required this.onProductSelected,
  });

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  List<ProductModel> _searchResults = [];
  bool _showResults = false;

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showResults = false;
      });
      return;
    }

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final results = productProvider.products.where((product) {
      final nameMatch =
          product.name.toLowerCase().contains(query.toLowerCase());
      final brandMatch =
          product.brand?.toLowerCase().contains(query.toLowerCase()) ?? false;
      final barcodeMatch = product.barcode?.contains(query) ?? false;

      return (nameMatch || brandMatch || barcodeMatch) && product.quantity > 0;
    }).toList();

    setState(() {
      _searchResults = results;
      _showResults = results.isNotEmpty;
    });
  }

  void _selectProduct(ProductModel product) {
    widget.onProductSelected(product);
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _showResults = false;
    });
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Column(
      children: [
        // Search Input
        TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: l10n.searchPosHint,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _performSearch('');
                    },
                  )
                : const Icon(Icons.qr_code_scanner),
            filled: true,
            fillColor: colors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          onChanged: _performSearch,
        ),

        // Search Results Dropdown
        if (_showResults) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final product = _searchResults[index];
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.inventory_2,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    product.name,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${product.brand ?? l10n.noBrand} • ${l10n.stockQtyShort} ${product.quantity}',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  trailing: Text(
                    '${product.sellingPrice.toStringAsFixed(0)} ${l10n.currency}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  onTap: () => _selectProduct(product),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
