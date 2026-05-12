// lib/views/categories/categories_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/core/constants/app_colors.dart';
import 'package:phone_shop/views/categories/widgets/add_category_dialog.dart';
import 'package:phone_shop/views/categories/widgets/category_card.dart';
import 'package:phone_shop/views/categories/widgets/edit_category_dialog.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/helpers.dart';
import '../../providers/category_provider.dart';
import '../../providers/product_provider.dart';
import '../shared/main_layout.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    // Load categories on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentRoute: AppRoutes.categories,
      child: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          final l10n = AppLocalizations.of(context);
          return Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(24),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.categories,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.categoriesSubtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Add Category Button
                    ElevatedButton.icon(
                      onPressed: () => _showAddCategoryDialog(context),
                      icon: const Icon(Icons.add, color: AppColors.white),
                      label: Text(
                        l10n.addCategory,
                        style: const TextStyle(color: AppColors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.sidebarBackground,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Content
              Expanded(
                child: categoryProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : categoryProvider.categories.isEmpty
                        ? _buildEmptyState(context)
                        : _buildCategoriesGrid(context, categoryProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noCategoriesYet,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.addFirstCategoryHint,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddCategoryDialog(context),
            icon: const Icon(Icons.add),
            label: Text(l10n.addCategory),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid(
    BuildContext context,
    CategoryProvider categoryProvider,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 20.w,
          mainAxisSpacing: 20.h,
          childAspectRatio: 1.5,
        ),
        itemCount: categoryProvider.categories.length,
        itemBuilder: (context, index) {
          final category = categoryProvider.categories[index];
          return CategoryCard(
            category: category,
            onEdit: () => _showEditCategoryDialog(context, category),
            onDelete: () => _deleteCategory(context, category.id!),
          );
        },
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddCategoryDialog(),
    );
  }

  void _showEditCategoryDialog(BuildContext context, category) {
    showDialog(
      context: context,
      builder: (context) => EditCategoryDialog(category: category),
    );
  }

  Future<void> _deleteCategory(BuildContext context, int categoryId) async {
    // Check if category has products
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    await productProvider.loadProducts();

    final hasProducts = productProvider.products
        .any((product) => product.categoryId == categoryId);

    final l10n = AppLocalizations.of(context);
    if (hasProducts) {
      Helpers.showSnackBar(
        context,
        l10n.cannotDeleteCategoryHasProducts,
        isError: true,
      );
      return;
    }

    final confirm = await Helpers.showConfirmDialog(
      context,
      title: l10n.deleteCategory,
      message: l10n.deleteCategoryMessage,
      confirmText: l10n.delete,
      cancelText: l10n.cancel,
    );

    if (confirm && context.mounted) {
      final categoryProvider = Provider.of<CategoryProvider>(
        context,
        listen: false,
      );

      final success = await categoryProvider.deleteCategory(categoryId);

      if (context.mounted) {
        final loc = AppLocalizations.of(context);
        if (success) {
          Helpers.showSnackBar(context, loc.categoryDeleteSuccess);
        } else {
          if (categoryProvider.errorMessage != null) {
            debugPrint(categoryProvider.errorMessage);
          }
          Helpers.showSnackBar(
            context,
            loc.failedDeleteCategory,
            isError: true,
          );
        }
      }
    }
  }
}
