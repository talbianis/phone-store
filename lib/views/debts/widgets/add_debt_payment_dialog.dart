// lib/views/debts/widgets/add_debt_payment_dialog.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/data/models/debt_payement_model.dart';

import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
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
              Expanded(
                child: Text(
                  l10n.addPaymentTitle,
                  style: const TextStyle(
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
                    Text(
                      l10n.customerSectionLabel,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      widget.debt.customerName ?? l10n.unknownCustomer,
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
                    Text(
                      l10n.invoiceNumber,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      widget.debt.invoiceNumber ??
                          l10n.invoiceHashId(widget.debt.saleId),
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
                    Text(
                      l10n.totalDebt,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.grey),
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
                    Text(
                      l10n.alreadyPaid,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.grey),
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
                    Text(
                      l10n.remainingAmount,
                      style: const TextStyle(
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
                    labelText: l10n.paymentAmountField,
                    hintText: widget.debt.remainingAmount.toStringAsFixed(0),
                    prefixIcon: const Icon(Icons.attach_money),
                    suffixText: l10n.currency,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.valEnterPaymentAmount;
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return l10n.valValidPaymentAmount;
                    }
                    if (amount > widget.debt.remainingAmount) {
                      return l10n.valPaymentExceedsDebt;
                    }
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 16),

                // Payment Method
                Text(
                  l10n.paymentMethod,
                  style: const TextStyle(
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
                        l10n.cash,
                        Icons.money,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPaymentMethodOption(
                        'card',
                        l10n.card,
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
                            Text(l10n.paymentAmount),
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
                            Text(
                              l10n.newRemainingDebt,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                child: Text(l10n.cancel),
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
                    : Text(l10n.addPaymentTitle),
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

      debugPrint('Adding payment: ${payment.toMap()}');

      final success = await debtProvider.addPayment(payment);

      setState(() => _isProcessing = false);

      if (mounted) {
        final l10n = AppLocalizations.of(context);
        if (success) {
          final newRemaining = widget.debt.remainingAmount - paymentAmount;

          debugPrint('Payment successful. New remaining: $newRemaining');

          Helpers.showSnackBar(
            context,
            l10n.paymentRecordedRemainingFormatted(
                CurrencyFormatter.format(newRemaining)),
          );

          Navigator.pop(context, true);
        } else {
          debugPrint('Payment failed: ${debtProvider.errorMessage}');

          Helpers.showSnackBar(
            context,
            l10n.failedAddPayment,
            isError: true,
          );
        }
      }
    } catch (e) {
      setState(() => _isProcessing = false);

      debugPrint('Exception adding payment: $e');

      if (mounted) {
        final l10n = AppLocalizations.of(context);
        Helpers.showSnackBar(
          context,
          l10n.operationFailed,
          isError: true,
        );
      }
    }
  }
}
