// lib/views/expenses/widgets/expense_card.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/core/utils/date_formater.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';

import '../../../data/models/expense_model.dart';

class ExpenseCard extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExpenseCard({
    Key? key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Category Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getCategoryColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getCategoryIcon(),
                color: _getCategoryColor(),
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Expense Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Text(
                    expense.category,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Description
                  if (expense.description != null &&
                      expense.description!.isNotEmpty)
                    Text(
                      expense.description!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 4),

                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormatter.formatDate(expense.expenseDate),
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

            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(expense.amount),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Edit Button
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 20),
                      color: AppColors.primary,
                      tooltip: 'Edit',
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      padding: const EdgeInsets.all(8),
                    ),
                    const SizedBox(width: 4),
                    // Delete Button
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, size: 20),
                      color: AppColors.error,
                      tooltip: 'Delete',
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      padding: const EdgeInsets.all(8),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    switch (expense.category.toLowerCase()) {
      case 'rent':
        return Colors.purple;
      case 'utilities':
        return Colors.orange;
      case 'salaries':
        return Colors.green;
      case 'supplies':
        return Colors.blue;
      case 'marketing':
        return Colors.pink;
      case 'maintenance':
        return Colors.brown;
      case 'transport':
        return Colors.teal;
      case 'other':
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon() {
    switch (expense.category.toLowerCase()) {
      case 'rent':
        return Icons.home;
      case 'utilities':
        return Icons.bolt;
      case 'salaries':
        return Icons.people;
      case 'supplies':
        return Icons.shopping_cart;
      case 'marketing':
        return Icons.campaign;
      case 'maintenance':
        return Icons.build;
      case 'transport':
        return Icons.local_shipping;
      case 'other':
      default:
        return Icons.category;
    }
  }
}
