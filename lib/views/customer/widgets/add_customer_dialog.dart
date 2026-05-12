// lib/views/customers/widgets/add_customer_dialog.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/customer_model.dart';
import '../../../providers/customer_provider.dart';

class AddCustomerDialog extends StatefulWidget {
  const AddCustomerDialog({Key? key}) : super(key: key);

  @override
  State<AddCustomerDialog> createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  final _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();

    _addressController.dispose();
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_add,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    l10n.addCustomer,
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

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '${l10n.customerName} *',
                      hintText: l10n.hintFullNameExample,
                      prefixIcon: const Icon(Icons.person),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) => Validators.required(
                      value,
                      l10n,
                      fieldName: l10n.customerName,
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: '${l10n.phone} *',
                      hintText: l10n.hintPhoneExample,
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (v) => Validators.phone(v, l10n),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: l10n.addressOptional,
                      hintText: l10n.hintAddress,
                      prefixIcon: const Icon(Icons.location_on),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(l10n.addCustomer),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final customer = CustomerModel(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      totalDebt: 0.0,
      createdAt: DateTime.now(),
    );

    final customerProvider = Provider.of<CustomerProvider>(
      context,
      listen: false,
    );

    final success = await customerProvider.addCustomer(customer);

    setState(() => _isLoading = false);

    if (mounted) {
      final l10n = AppLocalizations.of(context);
      if (success) {
        Helpers.showSnackBar(context, l10n.customerAddSuccess);
        Navigator.pop(context);
      } else {
        if (customerProvider.errorMessage != null) {
          debugPrint(customerProvider.errorMessage);
        }
        Helpers.showSnackBar(
          context,
          l10n.failedAddCustomer,
          isError: true,
        );
      }
    }
  }
}
