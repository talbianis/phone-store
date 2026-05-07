// lib/views/stock/widgets/add_stock_adjustment_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_shop/providers/stock_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/stock_adjustment_model.dart';

class AddStockAdjustmentDialog extends StatefulWidget {
  final ProductModel product;

  const AddStockAdjustmentDialog({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<AddStockAdjustmentDialog> createState() =>
      _AddStockAdjustmentDialogState();
}

class _AddStockAdjustmentDialogState extends State<AddStockAdjustmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _reasonController = TextEditingController();

  String _adjustmentType = 'add'; // add, remove
  String _reason = 'Restock';
  bool _isProcessing = false;

  final List<String> _addReasons = [
    'Restock',
    'Return from Customer',
    'Correction',
    'Other',
  ];

  final List<String> _removeReasons = [
    'Damage',
    'Theft',
    'Return to Supplier',
    'Correction',
    'Other',
  ];

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      Icons.inventory,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Adjust Stock',
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

              // Product Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Current Stock:'),
                        Text(
                          '${widget.product.quantity} units',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Stock Value:'),
                        Text(
                          CurrencyFormatter.format(
                            widget.product.purchasePrice *
                                widget.product.quantity,
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
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
                    // Adjustment Type
                    const Text(
                      'Adjustment Type',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: _buildAdjustmentTypeOption(
                            'add',
                            'Add Stock',
                            Icons.add_circle,
                            AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildAdjustmentTypeOption(
                            'remove',
                            'Remove Stock',
                            Icons.remove_circle,
                            AppColors.error,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Quantity
                    TextFormField(
                      controller: _quantityController,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        labelText: 'Quantity *',
                        hintText: 'Enter quantity',
                        prefixIcon: const Icon(Icons.format_list_numbered),
                        suffixText: 'units',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter quantity';
                        }
                        final qty = int.tryParse(value);
                        if (qty == null || qty <= 0) {
                          return 'Please enter a valid quantity';
                        }
                        if (_adjustmentType == 'remove' &&
                            qty > widget.product.quantity) {
                          return 'Cannot remove more than current stock';
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: 16),

                    // Reason Dropdown
                    DropdownButtonFormField<String>(
                      value: _reason,
                      decoration: const InputDecoration(
                        labelText: 'Reason *',
                        prefixIcon: Icon(Icons.info_outline),
                        border: OutlineInputBorder(),
                      ),
                      items: (_adjustmentType == 'add'
                              ? _addReasons
                              : _removeReasons)
                          .map((reason) {
                        return DropdownMenuItem(
                          value: reason,
                          child: Text(reason),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _reason = value!);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Additional Notes
                    if (_reason == 'Other')
                      TextFormField(
                        controller: _reasonController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Additional Notes',
                          hintText: 'Specify the reason',
                          prefixIcon: Icon(Icons.notes),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (_reason == 'Other' &&
                              (value == null || value.trim().isEmpty)) {
                            return 'Please specify the reason';
                          }
                          return null;
                        },
                      ),

                    const SizedBox(height: 24),

                    // New Stock Preview
                    if (_quantityController.text.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (_adjustmentType == 'add'
                                  ? AppColors.success
                                  : AppColors.error)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: (_adjustmentType == 'add'
                                    ? AppColors.success
                                    : AppColors.error)
                                .withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'New Stock Level:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_calculateNewStock()} units',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _adjustmentType == 'add'
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                            ),
                          ],
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
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isProcessing ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _adjustmentType == 'add'
                          ? AppColors.success
                          : AppColors.error,
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
                        : Text(_adjustmentType == 'add'
                            ? 'Add Stock'
                            : 'Remove Stock'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdjustmentTypeOption(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = _adjustmentType == value;

    return InkWell(
      onTap: () {
        setState(() {
          _adjustmentType = value;
          _reason = value == 'add' ? 'Restock' : 'Damage';
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey[600],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateNewStock() {
    final qty = int.tryParse(_quantityController.text) ?? 0;
    if (_adjustmentType == 'add') {
      return widget.product.quantity + qty;
    } else {
      return widget.product.quantity - qty;
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    final quantity = int.parse(_quantityController.text);
    final finalReason =
        _reason == 'Other' ? _reasonController.text.trim() : _reason;

    final adjustment = StockAdjustmentModel(
      productId: widget.product.id!,
      userId: 1, // TODO: Replace with actual user ID from auth
      quantityChange: quantity,
      reason: finalReason,
      adjustmentDate: DateTime.now(),
    );

    final stockProvider = Provider.of<StockProvider>(context, listen: false);
    final success = await stockProvider.addAdjustment(adjustment);

    setState(() => _isProcessing = false);

    if (mounted) {
      if (success) {
        Helpers.showSnackBar(
          context,
          'Stock adjusted successfully! New stock: ${_calculateNewStock()} units',
        );
        Navigator.pop(context, true);
      } else {
        Helpers.showSnackBar(
          context,
          stockProvider.errorMessage ?? 'Failed to adjust stock',
          isError: true,
        );
      }
    }
  }
}
