// lib/views/debts/widgets/add_debt_payment_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/data/models/debt_payement_model.dart';

import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/debt_model.dart';

import '../../../providers/debt_provider.dart';

class AddDebtPaymentDialog extends StatefulWidget {
  final DebtModel debt;

  const AddDebtPaymentDialog({
    Key? key,
    required this.debt,
  }) : super(key: key);

  @override
  State<AddDebtPaymentDialog> createState() => _AddDebtPaymentDialogState();
}

class _AddDebtPaymentDialogState extends State<AddDebtPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _paymentMethod = 'cash';
  bool _isProcessing = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.payment,
                  color: AppColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Add Payment',
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

          // Debt Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Customer',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      widget.debt.customerName ?? 'Unknown Customer',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Invoice',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      widget.debt.invoiceNumber ??
                          'Invoice #${widget.debt.saleId}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Debt',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      CurrencyFormatter.format(widget.debt.totalAmount),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Already Paid',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      CurrencyFormatter.format(widget.debt.paidAmount),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Remaining',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(widget.debt.remainingAmount),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Form
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Payment Amount
                TextFormField(
                  controller: _amountController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Payment Amount *',
                    hintText: widget.debt.remainingAmount.toStringAsFixed(0),
                    prefixIcon: const Icon(Icons.attach_money),
                    suffixText: 'DA',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter payment amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    if (amount > widget.debt.remainingAmount) {
                      return 'Payment cannot exceed remaining debt';
                    }
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 16),

                // Payment Method
                const Text(
                  'Payment Method',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: _buildPaymentMethodOption(
                        'cash',
                        'Cash',
                        Icons.money,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPaymentMethodOption(
                        'card',
                        'Card',
                        Icons.credit_card,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // New Remaining Preview
                if (_amountController.text.isNotEmpty)
                  Container(
                    height: 150.h,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Payment Amount'),
                            Text(
                              CurrencyFormatter.format(
                                double.tryParse(_amountController.text) ?? 0,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'New Remaining Debt',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              CurrencyFormatter.format(
                                widget.debt.remainingAmount -
                                    (double.tryParse(_amountController.text) ??
                                        0),
                              ),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: (widget.debt.remainingAmount -
                                            (double.tryParse(
                                                    _amountController.text) ??
                                                0)) ==
                                        0
                                    ? AppColors.success
                                    : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _isProcessing ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _isProcessing ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Add Payment'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption(String value, String label, IconData icon) {
    final isSelected = _paymentMethod == value;

    return InkWell(
      onTap: () => setState(() => _paymentMethod = value),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // lib/views/debts/widgets/add_debt_payment_dialog.dart
// In the _handleSubmit method:

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    final paymentAmount = double.parse(_amountController.text);

    try {
      // ✅ CREATE payment with payment method
      final payment = DebtPaymentModel(
        debtId: widget.debt.id!,
        amount: paymentAmount,
        paymentMethod: _paymentMethod, // ⬅️ THIS IS CRITICAL!
        paymentDate: DateTime.now(),
      );

      final debtProvider = Provider.of<DebtProvider>(context, listen: false);

      print('💳 Adding payment: ${payment.toMap()}'); // Debug log

      final success = await debtProvider.addPayment(payment);

      setState(() => _isProcessing = false);

      if (mounted) {
        if (success) {
          final newRemaining = widget.debt.remainingAmount - paymentAmount;

          print('✅ Payment successful! New remaining: $newRemaining');

          Helpers.showSnackBar(
            context,
            'Payment recorded! Remaining: ${CurrencyFormatter.format(newRemaining)}',
          );

          Navigator.pop(context, true);
        } else {
          print('❌ Payment failed: ${debtProvider.errorMessage}');

          Helpers.showSnackBar(
            context,
            debtProvider.errorMessage ?? 'Failed to add payment',
            isError: true,
          );
        }
      }
    } catch (e) {
      setState(() => _isProcessing = false);

      print('❌ Exception adding payment: $e');

      if (mounted) {
        Helpers.showSnackBar(
          context,
          'Error: $e',
          isError: true,
        );
      }
    }
  }
}
