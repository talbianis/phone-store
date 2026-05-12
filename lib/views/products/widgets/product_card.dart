// lib/views/products/widgets/product_card.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/views/products/edit_product_screen.dart';
import 'package:phone_shop/views/products/product_details_screen.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/product_model.dart';
import '../../../providers/product_provider.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailsScreen(product: product),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              _buildProductImage(),

              // Product Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      if (product.brand != null) ...[
                        SizedBox(height: 8.h),
                        Text(
                          product.brand!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                      SizedBox(
                        height: 10.h,
                      ),

                      // Price
                      Text(
                        CurrencyFormatter.format(product.sellingPrice),
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Stock Badge
                      _buildStockBadge(l10n),

                      SizedBox(height: 8.h),

                      // Actions
                      _buildActions(context, l10n),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 170.h,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: product.imagePath != null && product.imagePath!.isNotEmpty
            ? Image.file(
                File(product.imagePath!),
                width: double.infinity,
                height: 150.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder();
                },
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 60.sp,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildStockBadge(AppLocalizations l10n) {
    Color badgeColor;
    String badgeText;
    IconData badgeIcon;

    if (product.isOutOfStock) {
      badgeColor = AppColors.error;
      badgeText = l10n.outOfStock;
      badgeIcon = Icons.error_outline;
    } else if (product.isLowStock) {
      badgeColor = AppColors.warning;
      badgeText = '${l10n.lowStock}: ${product.quantity}';
      badgeIcon = Icons.warning_amber;
    } else {
      badgeColor = AppColors.success;
      badgeText = '${l10n.inStock}: ${product.quantity}';
      badgeIcon = Icons.check_circle_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, size: 14, color: badgeColor),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              badgeText,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: badgeColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProductScreen(product: product),
                ),
              );
            },
            icon: Icon(Icons.edit, size: 20.sp),
            label: Text(l10n.edit, style: TextStyle(fontSize: 20.sp)),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              minimumSize: const Size(0, 32),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _handleDelete(context),
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(
            minWidth: 32.w,
            minHeight: 32.h,
          ),
        ),
      ],
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirm = await Helpers.showConfirmDialog(
      context,
      title: l10n.deleteProduct,
      message: l10n.deleteProductNamed(product.name),
      confirmText: l10n.delete,
      cancelText: l10n.cancel,
    );

    if (confirm && context.mounted) {
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );

      final success = await productProvider.deleteProduct(product.id!);

      if (context.mounted) {
        final loc = AppLocalizations.of(context);
        if (success) {
          Helpers.showSnackBar(context, loc.productDeleteSuccess);
        } else {
          if (productProvider.errorMessage != null) {
            debugPrint(productProvider.errorMessage);
          }
          Helpers.showSnackBar(
            context,
            loc.failedDeleteProduct,
            isError: true,
          );
        }
      }
    }
  }
}
