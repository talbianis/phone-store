// lib/views/dashboard/widgets/best_selling_products.dart

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../shared/themed_screen_sections.dart';

import 'package:provider/provider.dart';
import '../../../providers/dashborad_provider.dart'; // note the typo

class BestSellingProducts extends StatelessWidget {
  const BestSellingProducts({super.key});

  // Map index → color (same palette as before)
  static const _rankColors = [
    AppColors.primary,
    AppColors.chartTertiary,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final products = context.watch<DashboardProvider>().bestSellingProducts;
    final colors = Theme.of(context).colorScheme;

    // ... keep your Container/Column header the same ...

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: ThemedScreenSections.cardDecoration(
        context,
        radius: 12,
        borderColor: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header row — unchanged
          // ...

          const SizedBox(height: 24),

          if (products.isEmpty)
            Center(
              child: Text(
                l10n.noData, // or any empty-state string you have
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
            )
          else
            ...products.asMap().entries.map((entry) {
              final i = entry.key;
              final p = entry.value;
              final maxQty = (products.first['totalSold'] as num).toDouble();

              return _buildProductItem(context, {
                'rank': i + 1,
                'name': p['name'] ?? '',
                'brand': p['brand'] ?? '',
                'quantity': p['totalSold'],
                'color': _rankColors[i % _rankColors.length],
                'maxQuantity': maxQty,
              });
            }),
        ],
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, Map<String, dynamic> product) {
    final colors = Theme.of(context).colorScheme;
    final maxQuantity = (product['maxQuantity'] as double?) ?? 1.0;
    // final quantity = (product['quantity'] as num?)?.toDouble() ?? 0;

    // ... rest of the method unchanged, just replace:
    // value: product['quantity'] / maxQuantity
    // with:
    // value: maxQuantity > 0 ? quantity / maxQuantity : 0,

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: product['color'],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${product['rank']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product['brand'],
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: product['quantity'] / maxQuantity,
                    backgroundColor: colors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      product['color'],
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Quantity
          Text(
            '${product['quantity']}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
