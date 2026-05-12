// lib/views/categories/widgets/add_category_dialog.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/category_model.dart';
import '../../../providers/category_provider.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({Key? key}) : super(key: key);

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
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
                    Icons.category,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    l10n.addCategory,
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
                children: [
                  // Category Name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '${l10n.categoryName} *',
                      hintText: l10n.hintCategoryName,
                      prefixIcon: const Icon(Icons.label),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) => Validators.required(
                      value,
                      l10n,
                      fieldName: l10n.categoryName,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description (Optional)
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: l10n.descriptionOptional,
                      hintText: l10n.hintCategoryDesc,
                      prefixIcon: const Icon(Icons.description),
                    ),
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
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
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (states) {
                        if (states.contains(MaterialState.disabled)) {
                          return AppColors.sidebarBackground.withOpacity(0.5);
                        }
                        return AppColors.sidebarBackground;
                      },
                    ),
                  ),
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
                      : Text(
                          l10n.addCategory,
                          style: const TextStyle(color: AppColors.white),
                        ),
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

    final category = CategoryModel(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      createdAt: DateTime.now(),
    );

    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );

    final success = await categoryProvider.addCategory(category);

    setState(() => _isLoading = false);

    if (mounted) {
      final l10n = AppLocalizations.of(context);
      if (success) {
        Helpers.showSnackBar(context, l10n.categoryAddSuccess);
        Navigator.pop(context);
      } else {
        if (categoryProvider.errorMessage != null) {
          debugPrint(categoryProvider.errorMessage);
        }
        Helpers.showSnackBar(
          context,
          l10n.failedAddCategory,
          isError: true,
        );
      }
    }
  }
}
