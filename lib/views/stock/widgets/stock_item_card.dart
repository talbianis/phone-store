// lib/views/stock/widgets/stock_item_card.dart

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/product_model.dart';

class StockItemCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onAdjust;

  const StockItemCard({
    Key? key,
    required this.product,
    required this.onAdjust,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStockStatusColor().withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: product.imagePath == null
                  ? Icon(Icons.phone_android, color: Colors.grey[400], size: 32)
                  : null,
            ),

            const SizedBox(width: 16),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Barcode
                  Text(
                    '${l10n.barcodePrefix} ${product.barcode ?? '-'}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Stock Value
                  Text(
                    '${l10n.valuePrefix} ${CurrencyFormatter.format(product.purchasePrice * product.quantity)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Stock Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Stock Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStockStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _getStockStatusColor(),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStockStatusIcon(),
                        size: 16,
                        color: _getStockStatusColor(),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.unitsCountLabel(product.quantity),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getStockStatusColor(),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Adjust Stock Button
                ElevatedButton.icon(
                  onPressed: onAdjust,
                  icon: const Icon(Icons.edit, size: 16),
                  label: Text(l10n.adjust),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStockStatusColor() {
    if (product.quantity == 0) {
      return AppColors.error;
    } else if (product.quantity <= 10) {
      return Colors.orange;
    } else {
      return AppColors.success;
    }
  }

  IconData _getStockStatusIcon() {
    if (product.quantity == 0) {
      return Icons.remove_circle;
    } else if (product.quantity <= 10) {
      return Icons.warning_amber;
    } else {
      return Icons.check_circle;
    }
  }
}
