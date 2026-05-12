// lib/views/products/product_details_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:phone_shop/core/utils/date_formater.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/layout/desktop_adaptive.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/currency_formatter.dart';

import '../../data/models/product_model.dart';
import '../../providers/category_provider.dart';
import 'edit_product_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.productDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProductScreen(product: product),
                ),
              );
            },
            tooltip: l10n.editProduct,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Section
            _buildImageSection(context),

            // Product Info
            Padding(
              padding: desktopPagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Brand
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: desktopPageTitleFontSize(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  if (product.brand != null) ...[
                    SizedBox(height: desktopViewportHeight(context) * 0.01),
                    Text(
                      product.brand!,
                      style: TextStyle(
                        fontSize: desktopSectionTitleFontSize(context),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],

                  SizedBox(height: desktopViewportHeight(context) * 0.01),

                  // Category
                  Consumer<CategoryProvider>(
                    builder: (context, categoryProvider, child) {
                      final category = categoryProvider.getCategoryById(
                        product.categoryId,
                      );
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          category?.name ?? l10n.unknownCategory,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: desktopViewportHeight(context) * 0.028),

                  // Info Cards
                  _buildInfoCards(context, l10n),

                  SizedBox(height: desktopViewportHeight(context) * 0.022),

                  // Details Section
                  _buildDetailsSection(context, l10n),

                  if (product.notes != null && product.notes!.isNotEmpty) ...[
                    SizedBox(height: desktopViewportHeight(context) * 0.022),
                    _buildNotesSection(l10n),
                  ],

                  SizedBox(height: desktopViewportHeight(context) * 0.022),

                  // Timestamps
                  _buildTimestamps(l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    final imgHeight =
        (desktopViewportHeight(context) * 0.34).clamp(220.0, 520.0);
    return SizedBox(
      width: double.infinity,
      height: imgHeight,
      child: ColoredBox(
        color: Colors.grey[100]!,
        child: product.imagePath != null && product.imagePath!.isNotEmpty
            ? Image.file(
                File(product.imagePath!),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImagePlaceholder();
                },
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 120,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildInfoCards(BuildContext context, AppLocalizations l10n) {
    final cards = <Widget>[
      _buildInfoCard(
        l10n.sellingPrice,
        CurrencyFormatter.format(product.sellingPrice),
        AppColors.primary,
        Icons.sell,
      ),
      _buildInfoCard(
        l10n.buyingPrice,
        CurrencyFormatter.format(product.purchasePrice),
        Colors.orange,
        Icons.shopping_cart,
      ),
      _buildInfoCard(
        l10n.profit,
        CurrencyFormatter.format(product.profitPerUnit),
        AppColors.success,
        Icons.trending_up,
      ),
      _buildInfoCard(
        l10n.stock,
        l10n.unitsCountLabel(product.quantity),
        _getStockColor(),
        Icons.inventory,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        const gap = 16.0;
        if (w >= 1100) {
          return Row(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(width: gap),
                Expanded(child: cards[i]),
              ],
            ],
          );
        }
        final cols = w >= 640 ? 2 : 1;
        final tileW = cols == 1 ? w : (w - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: cards
              .map((c) => SizedBox(width: tileW, child: c))
              .toList(),
        );
      },
    );
  }

  Widget _buildInfoCard(
      String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.all(
        desktopPagePadding(context).left.clamp(16.0, 24.0),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.productDetails,
            style: TextStyle(
              fontSize: desktopSectionTitleFontSize(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailRow(l10n.productIdLabel, '#${product.id}'),
          const Divider(height: 24),
          if (product.barcode != null)
            _buildDetailRow(l10n.barcode, product.barcode!),
          if (product.barcode != null) const Divider(height: 24),
          _buildDetailRow(
            l10n.profitMarginLabel,
            '${product.profitMargin.toStringAsFixed(1)}%',
          ),
          const Divider(height: 24),
          _buildDetailRow(
            l10n.minStockLevel,
            l10n.unitsCountLabel(product.minQuantity),
          ),
          const Divider(height: 24),
          _buildDetailRow(
            l10n.stockStatus,
            _getStockStatus(l10n),
            statusColor: _getStockColor(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? statusColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: statusColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note, color: Colors.amber[700], size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.notes,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            product.notes!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.amber[900],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimestamps(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.timestampsCreated,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                DateFormatter.formatDateTime(product.createdAt),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.timestampsLastUpdated,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                DateFormatter.formatDateTime(product.updatedAt),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStockColor() {
    if (product.isOutOfStock) return AppColors.error;
    if (product.isLowStock) return AppColors.warning;
    return AppColors.success;
  }

  String _getStockStatus(AppLocalizations l10n) {
    if (product.isOutOfStock) return l10n.outOfStock;
    if (product.isLowStock) return l10n.lowStock;
    return l10n.inStock;
  }
}
