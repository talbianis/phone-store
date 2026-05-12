// lib/views/pos/widgets/discount_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.applyDiscount),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Discount Type Toggle
          Row(
            children: [
              Expanded(
                child: _buildTypeButton(
                  label: l10n.fixedDiscount,
                  isSelected: !_isPercentage,
                  onTap: () => setState(() => _isPercentage = false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTypeButton(
                  label: l10n.percentageDiscount,
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
              labelText: _isPercentage
                  ? l10n.discountFieldPercent
                  : l10n.discountFieldAmount,
              hintText: _isPercentage
                  ? l10n.hintDiscountPercentEx
                  : l10n.hintDiscountAmountEx,
              prefixIcon: Icon(
                _isPercentage ? Icons.percent : Icons.attach_money,
              ),
              suffixText: _isPercentage ? '%' : l10n.currency,
              border: const OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          // Preview
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              final loc = AppLocalizations.of(context);
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
                        Text(loc.subtotalColon),
                        Text(
                          '${cartProvider.subtotal.toStringAsFixed(2)} ${loc.currency}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(loc.discountColon),
                        Text(
                          '-${discount.toStringAsFixed(2)} ${loc.currency}',
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
                        Text(
                          loc.totalColon,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${(cartProvider.subtotal - discount).toStringAsFixed(2)} ${loc.currency}',
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
          child: Text(l10n.removeDiscount),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _applyDiscount,
          child: Text(l10n.apply),
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
    final l10n = AppLocalizations.of(context);
    final discount = _calculateDiscount(cartProvider.subtotal);

    if (discount > cartProvider.subtotal) {
      Helpers.showSnackBar(
        context,
        l10n.discountExceedsSubtotal,
        isError: true,
      );
      return;
    }

    cartProvider.applyDiscount(discount);
    Navigator.pop(context);
  }
}
