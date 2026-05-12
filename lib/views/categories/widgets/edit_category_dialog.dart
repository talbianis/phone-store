// lib/views/categories/widgets/edit_category_dialog.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/category_model.dart';
import '../../../providers/category_provider.dart';

class EditCategoryDialog extends StatefulWidget {
  final CategoryModel category;

  const EditCategoryDialog({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _descriptionController = TextEditingController(
      text: widget.category.description ?? '',
    );
  }

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
                    Icons.edit,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    l10n.editCategory,
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
                      : Text(l10n.updateCategory),
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

    final updatedCategory = widget.category.copyWith(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );

    final success = await categoryProvider.updateCategory(updatedCategory);

    setState(() => _isLoading = false);

    if (mounted) {
      final l10n = AppLocalizations.of(context);
      if (success) {
        Helpers.showSnackBar(context, l10n.categoryUpdateSuccess);
        Navigator.pop(context);
      } else {
        if (categoryProvider.errorMessage != null) {
          debugPrint(categoryProvider.errorMessage);
        }
        Helpers.showSnackBar(
          context,
          l10n.failedUpdateCategory,
          isError: true,
        );
      }
    }
  }
}
