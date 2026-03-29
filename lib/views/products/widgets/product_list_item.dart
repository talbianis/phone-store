// lib/views/products/widgets/product_list_item.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/views/products/edit_product_screen.dart';
import 'package:phone_shop/views/products/product_details_screen.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/product_model.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/category_provider.dart';

class ProductListItem extends StatelessWidget {
  final ProductModel product;

  const ProductListItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailsScreen(product: product),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Product Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: product.imagePath != null &&
                            product.imagePath!.isNotEmpty
                        ? Image.file(
                            File(product.imagePath!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholder();
                            },
                          )
                        : _buildPlaceholder(),
                  ),
                ),

                const SizedBox(width: 16),

                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Consumer<CategoryProvider>(
                        builder: (context, categoryProvider, child) {
                          final category = categoryProvider.getCategoryById(
                            product.categoryId,
                          );
                          return Text(
                            '${product.brand ?? 'No Brand'} • ${category?.name ?? 'Unknown'}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          );
                        },
                      ),
                      if (product.barcode != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Barcode: ${product.barcode}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      CurrencyFormatter.format(product.sellingPrice),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Profit: ${CurrencyFormatter.format(product.profitPerUnit)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 24),

                // Stock Badge
                SizedBox(
                  width: 120,
                  child: _buildStockBadge(),
                ),

                const SizedBox(width: 16),

                // Actions
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProductScreen(product: product),
                          ),
                        );
                      },
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _handleDelete(context),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 32,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildStockBadge() {
    Color badgeColor;
    String badgeText;
    IconData badgeIcon;

    if (product.isOutOfStock) {
      badgeColor = AppColors.error;
      badgeText = 'Out of Stock';
      badgeIcon = Icons.error_outline;
    } else if (product.isLowStock) {
      badgeColor = AppColors.warning;
      badgeText = 'Low: ${product.quantity}';
      badgeIcon = Icons.warning_amber;
    } else {
      badgeColor = AppColors.success;
      badgeText = 'Stock: ${product.quantity}';
      badgeIcon = Icons.check_circle_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, size: 16, color: badgeColor),
          const SizedBox(width: 6),
          Text(
            badgeText,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirm = await Helpers.showConfirmDialog(
      context,
      title: 'Delete Product',
      message: 'Are you sure you want to delete "${product.name}"?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    );

    if (confirm && context.mounted) {
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );

      final success = await productProvider.deleteProduct(product.id!);

      if (context.mounted) {
        if (success) {
          Helpers.showSnackBar(context, 'Product deleted successfully');
        } else {
          Helpers.showSnackBar(
            context,
            productProvider.errorMessage ?? 'Failed to delete product',
            isError: true,
          );
        }
      }
    }
  }
}
