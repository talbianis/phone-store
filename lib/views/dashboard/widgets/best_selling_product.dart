// lib/views/dashboard/widgets/best_selling_products.dart

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class BestSellingProducts extends StatelessWidget {
  const BestSellingProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data - you'll replace with actual data from provider
    final products = [
      {
        'rank': 1,
        'name': 'iPhone 15 Pro Max',
        'brand': 'Apple',
        'quantity': 48,
        'color': AppColors.primary,
      },
      {
        'rank': 2,
        'name': 'Samsung Galaxy S24 ...',
        'brand': 'Samsung',
        'quantity': 35,
        'color': AppColors.chartTertiary,
      },
      {
        'rank': 3,
        'name': 'iPhone 15',
        'brand': 'Apple',
        'quantity': 29,
        'color': Colors.orange,
      },
      {
        'rank': 4,
        'name': 'Xiaomi 14 Pro',
        'brand': 'Xiaomi',
        'quantity': 22,
        'color': Colors.purple,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Best Selling Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "This month's top sellers",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.trending_up,
                color: Colors.green,
                size: 24,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Products List
          ...products.map((product) => _buildProductItem(product)).toList(),
        ],
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    final maxQuantity = 48; // Maximum for progress bar calculation

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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product['brand'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: product['quantity'] / maxQuantity,
                    backgroundColor: Colors.grey[200],
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
