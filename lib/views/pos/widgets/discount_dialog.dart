// lib/views/pos/widgets/discount_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../providers/cart_provider.dart';

class DiscountDialog extends StatefulWidget {
  const DiscountDialog({Key? key}) : super(key: key);

  @override
  State<DiscountDialog> createState() => _DiscountDialogState();
}

class _DiscountDialogState extends State<DiscountDialog> {
  final _amountController = TextEditingController();
  bool _isPercentage = false;

  @override
  void initState() {
    super.initState();
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    if (cartProvider.discount > 0) {
      _amountController.text = cartProvider.discount.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Apply Discount'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Discount Type Toggle
          Row(
            children: [
              Expanded(
                child: _buildTypeButton(
                  label: 'Fixed Amount',
                  isSelected: !_isPercentage,
                  onTap: () => setState(() => _isPercentage = false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTypeButton(
                  label: 'Percentage',
                  isSelected: _isPercentage,
                  onTap: () => setState(() => _isPercentage = true),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Discount Input
          TextField(
            controller: _amountController,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: _isPercentage ? 'Discount (%)' : 'Discount Amount',
              hintText: _isPercentage ? 'e.g., 10' : 'e.g., 5000',
              prefixIcon: Icon(
                _isPercentage ? Icons.percent : Icons.attach_money,
              ),
              suffixText: _isPercentage ? '%' : 'DA',
              border: const OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          // Preview
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              final discount = _calculateDiscount(cartProvider.subtotal);
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal:'),
                        Text(
                          '${cartProvider.subtotal.toStringAsFixed(2)} DA',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Discount:'),
                        Text(
                          '-${discount.toStringAsFixed(2)} DA',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${(cartProvider.subtotal - discount).toStringAsFixed(2)} DA',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            //was remove duscount and i put cleardiscount
            Provider.of<CartProvider>(context, listen: false).removeDiscount();
            Navigator.pop(context);
          },
          child: const Text('Remove Discount'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _applyDiscount,
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildTypeButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  double _calculateDiscount(double subtotal) {
    final value = double.tryParse(_amountController.text) ?? 0;
    if (_isPercentage) {
      return (subtotal * value) / 100;
    }
    return value;
  }

  void _applyDiscount() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final discount = _calculateDiscount(cartProvider.subtotal);

    if (discount > cartProvider.subtotal) {
      Helpers.showSnackBar(
        context,
        'Discount cannot exceed subtotal',
        isError: true,
      );
      return;
    }

    cartProvider.applyDiscount(discount);
    Navigator.pop(context);
  }
}
