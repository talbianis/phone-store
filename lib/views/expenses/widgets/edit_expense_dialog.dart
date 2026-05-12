// lib/views/expenses/widgets/edit_expense_dialog.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/expense_model.dart';
import '../../../providers/expense_provider.dart';

class EditExpenseDialog extends StatefulWidget {
  final ExpenseModel expense;

  const EditExpenseDialog({
    Key? key,
    required this.expense,
  }) : super(key: key);

  @override
  State<EditExpenseDialog> createState() => _EditExpenseDialogState();
}

class _EditExpenseDialogState extends State<EditExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;

  late String _selectedCategory;
  late DateTime _selectedDate;
  bool _isProcessing = false;

  final List<String> _categories = [
    'Rent',
    'Utilities',
    'Salaries',
    'Supplies',
    'Marketing',
    'Maintenance',
    'Transport',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.expense.amount.toStringAsFixed(2),
    );
    _descriptionController = TextEditingController(
      text: widget.expense.description ?? '',
    );
    _selectedCategory = widget.expense.category;
    _selectedDate = widget.expense.expenseDate;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
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
                      Icons.edit,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      l10n.editExpense,
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

              // Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: l10n.categoryRequired,
                        prefixIcon: const Icon(Icons.category),
                        border: const OutlineInputBorder(),
                      ),
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(l10n.expenseCategoryLabel(category)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedCategory = value!);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Amount
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: '${l10n.amount} *',
                        hintText: l10n.hintExpenseAmountEx,
                        prefixIcon: const Icon(Icons.attach_money),
                        suffixText: l10n.currency,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.valEnterAmount;
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return l10n.valValidAmount;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: l10n.descriptionOptional,
                        hintText: l10n.expenseDescriptionHint,
                        prefixIcon: const Icon(Icons.description),
                        border: const OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Date Picker
                    InkWell(
                      onTap: _selectDate,
                      borderRadius: BorderRadius.circular(8),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: l10n.expenseDate,
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: const OutlineInputBorder(),
                        ),
                        child: Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        _isProcessing ? null : () => Navigator.pop(context),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isProcessing ? null : _handleSubmit,
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
                        : Text(l10n.updateExpense),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    final updatedExpense = widget.expense.copyWith(
      category: _selectedCategory,
      amount: double.parse(_amountController.text),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      expenseDate: _selectedDate,
    );

    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    final success = await expenseProvider.updateExpense(updatedExpense);

    setState(() => _isProcessing = false);

    if (mounted) {
      final l10n = AppLocalizations.of(context);
      if (success) {
        Helpers.showSnackBar(context, l10n.expenseUpdateSuccess);
        Navigator.pop(context, true);
      } else {
        debugPrint('updateExpense error: ${expenseProvider.errorMessage}');
        Helpers.showSnackBar(
          context,
          l10n.failedUpdateExpense,
          isError: true,
        );
      }
    }
  }
}
