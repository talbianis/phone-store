// lib/views/debts/widgets/debt_card.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/core/utils/date_formater.dart' show DateFormatter;
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/currency_formatter.dart';

import '../../../data/models/debt_model.dart';

class DebtCard extends StatelessWidget {
  final DebtModel debt;
  final VoidCallback onTap;
  final VoidCallback onAddPayment;

  const DebtCard({
    Key? key,
    required this.debt,
    required this.onTap,
    required this.onAddPayment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor().withOpacity(0.3),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Customer Avatar
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: _getStatusColor().withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        color: _getStatusColor(),
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Debt Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Customer Name
                          Text(
                            debt.customerName ?? l10n.unknownCustomer,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // Invoice & Date
                          Row(
                            children: [
                              Icon(
                                Icons.receipt,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                debt.invoiceNumber ??
                                    l10n.invoiceHashId(debt.saleId),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormatter.formatDate(debt.createdAt),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _getStatusColor().withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _statusLabel(l10n),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // Amounts Row
                Row(
                  children: [
                    // Total Amount
                    Expanded(
                      child: _buildAmountInfo(
                        l10n.total,
                        debt.totalAmount,
                        AppColors.error,
                      ),
                    ),

                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey[200],
                    ),

                    // Paid Amount
                    Expanded(
                      child: _buildAmountInfo(
                        l10n.paid,
                        debt.paidAmount,
                        AppColors.success,
                      ),
                    ),

                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey[200],
                    ),

                    // Remaining Amount
                    Expanded(
                      child: _buildAmountInfo(
                        l10n.remainingAmount,
                        debt.remainingAmount,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),

                if (debt.status != 'paid') ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onAddPayment,
                      icon: const Icon(Icons.payment, size: 18),
                      label: Text(l10n.addPayment),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountInfo(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          CurrencyFormatter.format(amount),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (debt.status) {
      case 'paid':
        return AppColors.success;
      case 'partial':
        return Colors.orange;
      case 'unpaid':
      default:
        return AppColors.error;
    }
  }

  String _statusLabel(AppLocalizations l10n) {
    switch (debt.status) {
      case 'paid':
        return l10n.paid;
      case 'partial':
        return l10n.partial;
      case 'unpaid':
      default:
        return l10n.unpaid;
    }
  }
}
