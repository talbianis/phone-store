// lib/views/stock/widgets/stock_history_dialog.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/core/utils/date_formater.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';

import '../../../data/models/stock_adjustment_model.dart';
import '../../../providers/stock_provider.dart';

class StockHistoryDialog extends StatelessWidget {
  const StockHistoryDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 700,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.history,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Stock Adjustment History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // History List
            Expanded(
              child: Consumer<StockProvider>(
                builder: (context, stockProvider, child) {
                  if (stockProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (stockProvider.adjustments.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.separated(
                    itemCount: stockProvider.adjustments.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final adjustment = stockProvider.adjustments[index];
                      return _buildHistoryItem(adjustment);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No adjustment history',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(StockAdjustmentModel adjustment) {
    final isAddition = adjustment.adjustmentType == 'add';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        children: [
          // Type Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isAddition ? AppColors.success : AppColors.error)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isAddition ? Icons.add_circle : Icons.remove_circle,
              color: isAddition ? AppColors.success : AppColors.error,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Adjustment Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  adjustment.productName ?? 'Product #${adjustment.productId}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  adjustment.reason,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormatter.formatDateTime(adjustment.adjustmentDate),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Quantity Change
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isAddition ? '+' : '-'}${adjustment.quantityChange}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isAddition ? AppColors.success : AppColors.error,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'units',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
