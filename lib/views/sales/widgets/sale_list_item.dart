// lib/views/sales/widgets/sale_list_item.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/core/utils/date_formater.dart';
import 'package:phone_shop/data/models/sales_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../shared/themed_screen_sections.dart';

class SaleListItem extends StatelessWidget {
  final SaleModel sale;
  final VoidCallback onTap;

  const SaleListItem({
    super.key,
    required this.sale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: ThemedScreenSections.cardDecoration(context),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Invoice Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.receipt_long,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 16),

                // Sale Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Invoice Number
                      Text(
                        sale.invoiceNumber,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Customer & Date
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 14,
                            color: colors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            sale.customerName ?? l10n.walkInCustomer,
                            style: TextStyle(
                              fontSize: 13,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: colors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormatter.formatDateTime(sale.saleDate),
                            style: TextStyle(
                              fontSize: 13,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Payment Method Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getPaymentMethodColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _getPaymentMethodColor().withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getPaymentMethodIcon(),
                        size: 14,
                        color: _getPaymentMethodColor(),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getPaymentMethodLabel(l10n),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getPaymentMethodColor(),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Amounts
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Total
                    Text(
                      CurrencyFormatter.format(sale.total),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Profit
                    Row(
                      children: [
                        const Icon(
                          Icons.trending_up,
                          size: 14,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          CurrencyFormatter.format(sale.profit),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(width: 8),

                // Arrow
                Icon(
                  Icons.chevron_right,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPaymentMethodColor() {
    switch (sale.paymentMethod.toLowerCase()) {
      case 'cash':
        return AppColors.success;
      case 'card':
        return Colors.blue;
      case 'debt':
        return AppColors.error;
      case 'mixed':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getPaymentMethodIcon() {
    switch (sale.paymentMethod.toLowerCase()) {
      case 'cash':
        return Icons.money;
      case 'card':
        return Icons.credit_card;
      case 'debt':
        return Icons.schedule;
      case 'mixed':
        return Icons.payments;
      default:
        return Icons.payment;
    }
  }

  String _getPaymentMethodLabel(AppLocalizations l10n) {
    switch (sale.paymentMethod.toLowerCase()) {
      case 'cash':
        return l10n.cash;
      case 'card':
        return l10n.card;
      case 'debt':
        return l10n.debt;
      case 'mixed':
        return l10n.mixed;
      default:
        return sale.paymentMethod;
    }
  }
}
