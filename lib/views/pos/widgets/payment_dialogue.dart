// lib/views/pos/widgets/payment_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/payment_method.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/sale_provider.dart';
import '../../../providers/auth_provider.dart';

class PaymentDialog extends StatefulWidget {
  const PaymentDialog({Key? key}) : super(key: key);

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  final _cashController = TextEditingController();
  final _cardController = TextEditingController();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    _cashController.text = cartProvider.total.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _cashController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                      Icons.payment,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Complete Payment',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed:
                        _isProcessing ? null : () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Order Summary
              _buildOrderSummary(),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),

              // Payment Method Selection
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _buildPaymentMethodOptions(),

              const SizedBox(height: 24),

              // Payment Input Fields
              _buildPaymentInputs(),

              const SizedBox(height: 24),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              _buildSummaryRow('Items', '${cartProvider.itemCount}'),
              const SizedBox(height: 8),
              _buildSummaryRow(
                'Subtotal',
                CurrencyFormatter.format(cartProvider.subtotal),
              ),
              if (cartProvider.discount > 0) ...[
                const SizedBox(height: 8),
                _buildSummaryRow(
                  'Discount',
                  '-${CurrencyFormatter.format(cartProvider.discount)}',
                  valueColor: AppColors.error,
                ),
              ],
              const Divider(height: 24),
              _buildSummaryRow(
                'Total',
                CurrencyFormatter.format(cartProvider.total),
                isBold: true,
                valueColor: AppColors.primary,
              ),
              const SizedBox(height: 8),
              _buildSummaryRow(
                'Profit',
                CurrencyFormatter.format(cartProvider.totalProfit),
                valueColor: AppColors.success,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodOptions() {
    return Column(
      children: [
        _buildPaymentMethodTile(
          method: PaymentMethod.cash,
          icon: Icons.money,
          label: 'Cash',
        ),
        const SizedBox(height: 8),
        _buildPaymentMethodTile(
          method: PaymentMethod.card,
          icon: Icons.credit_card,
          label: 'Card',
        ),
        const SizedBox(height: 8),
        _buildPaymentMethodTile(
          method: PaymentMethod.debt,
          icon: Icons.schedule,
          label: 'On Credit (Debt)',
        ),
        const SizedBox(height: 8),
        _buildPaymentMethodTile(
          method: PaymentMethod.mixed,
          icon: Icons.payments,
          label: 'Mixed (Cash + Card)',
        ),
      ],
    );
  }

  Widget _buildPaymentMethodTile({
    required PaymentMethod method,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedPaymentMethod == method;

    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = method),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInputs() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        switch (_selectedPaymentMethod) {
          case PaymentMethod.cash:
            return _buildCashInput(cartProvider.total);

          case PaymentMethod.card:
            return _buildCardInput(cartProvider.total);

          case PaymentMethod.debt:
            return _buildDebtInfo(cartProvider);

          case PaymentMethod.mixed:
            return _buildMixedInput(cartProvider.total);
        }
      },
    );
  }

  Widget _buildCashInput(double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _cashController,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            labelText: 'Cash Received',
            hintText: total.toStringAsFixed(2),
            prefixIcon: const Icon(Icons.attach_money),
            suffixText: 'DA',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        _buildChangeDisplay(total),
      ],
    );
  }

  Widget _buildCardInput(double total) {
    return TextField(
      controller: _cardController,
      enabled: false,
      decoration: InputDecoration(
        labelText: 'Card Payment',
        hintText: total.toStringAsFixed(2),
        prefixIcon: const Icon(Icons.credit_card),
        suffixText: 'DA',
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDebtInfo(CartProvider cartProvider) {
    if (cartProvider.selectedCustomer == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange[700]),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Please select a customer to use credit payment',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Text(
                cartProvider.selectedCustomer!.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Amount to be added to debt: ${CurrencyFormatter.format(cartProvider.total)}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMixedInput(double total) {
    return Column(
      children: [
        TextField(
          controller: _cashController,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: const InputDecoration(
            labelText: 'Cash Amount',
            prefixIcon: Icon(Icons.money),
            suffixText: 'DA',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _cardController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: const InputDecoration(
            labelText: 'Card Amount',
            prefixIcon: Icon(Icons.credit_card),
            suffixText: 'DA',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        _buildMixedSummary(total),
      ],
    );
  }

  Widget _buildChangeDisplay(double total) {
    final cashReceived = double.tryParse(_cashController.text) ?? 0;
    final change = cashReceived - total;

    if (change < 0) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 20),
            const SizedBox(width: 8),
            Text(
              'Insufficient: ${CurrencyFormatter.format(change.abs())} DA short',
              style: const TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Change',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            CurrencyFormatter.format(change),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMixedSummary(double total) {
    final cash = double.tryParse(_cashController.text) ?? 0;
    final card = double.tryParse(_cardController.text) ?? 0;
    final totalPaid = cash + card;
    final remaining = total - totalPaid;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Payment:'),
              Text(
                CurrencyFormatter.format(totalPaid),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Remaining:'),
              Text(
                CurrencyFormatter.format(remaining),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: remaining > 0 ? AppColors.error : AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isProcessing ? null : () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _completeSale,
            child: _isProcessing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Complete Sale'),
          ),
        ),
      ],
    );
  }

  Future<void> _completeSale() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Validation
    if (_selectedPaymentMethod == PaymentMethod.debt &&
        cartProvider.selectedCustomer == null) {
      Helpers.showSnackBar(
        context,
        'Please select a customer for credit payment',
        isError: true,
      );
      return;
    }

    double paidAmount = cartProvider.total;
    String paymentMethod = _selectedPaymentMethod.value;

    if (_selectedPaymentMethod == PaymentMethod.cash) {
      final cashReceived = double.tryParse(_cashController.text) ?? 0;
      if (cashReceived < cartProvider.total) {
        Helpers.showSnackBar(
          context,
          'Insufficient cash received',
          isError: true,
        );
        return;
      }
      paidAmount = cashReceived;
    } else if (_selectedPaymentMethod == PaymentMethod.mixed) {
      final cash = double.tryParse(_cashController.text) ?? 0;
      final card = double.tryParse(_cardController.text) ?? 0;
      paidAmount = cash + card;

      if (paidAmount < cartProvider.total) {
        Helpers.showSnackBar(
          context,
          'Total payment is less than order total',
          isError: true,
        );
        return;
      }
    } else if (_selectedPaymentMethod == PaymentMethod.debt) {
      paidAmount = 0; // Debt means nothing paid now
    }

    setState(() => _isProcessing = true);

    final saleProvider = Provider.of<SaleProvider>(context, listen: false);

    final success = await saleProvider.createSaleFromCart(
      cartItems: cartProvider.items,
      userId: authProvider.currentUser!.id!,
      subtotal: cartProvider.subtotal,
      discount: cartProvider.discount,
      total: cartProvider.total,
      paymentMethod: paymentMethod,
      paidAmount: paidAmount,
      customerId: cartProvider.selectedCustomer?.id,
    );

    setState(() => _isProcessing = false);

    if (mounted) {
      if (success) {
        // Clear cart
        cartProvider.clearCart();

        // Close dialog
        Navigator.pop(context);

        // Show success message
        Helpers.showSnackBar(
          context,
          'Sale completed successfully!',
        );

        // Show change if cash payment
        if (_selectedPaymentMethod == PaymentMethod.cash) {
          final change = paidAmount - cartProvider.total;
          if (change > 0) {
            _showChangeDialog(context, change);
          }
        }
      } else {
        Helpers.showSnackBar(
          context,
          saleProvider.errorMessage ?? 'Failed to complete sale',
          isError: true,
        );
      }
    }
  }

  void _showChangeDialog(BuildContext context, double change) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.attach_money,
              size: 64,
              color: AppColors.success,
            ),
            const SizedBox(height: 16),
            Text(
              CurrencyFormatter.format(change),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Change to return',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
