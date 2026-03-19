// lib/views/products/edit_product_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../providers/category_provider.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel product;

  const EditProductScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _quantityController;
  late TextEditingController _minQuantityController;
  late TextEditingController _barcodeController;
  late TextEditingController _notesController;

  int? _selectedCategoryId;
  File? _selectedImage;
  bool _isLoading = false;
  double _calculatedProfit = 0.0;
  double _profitMargin = 0.0;
  bool _isImageRemoved = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data
    _nameController = TextEditingController(text: widget.product.name);
    _brandController = TextEditingController(text: widget.product.brand ?? '');
    _purchasePriceController = TextEditingController(
      text: widget.product.purchasePrice.toString(),
    );
    _sellingPriceController = TextEditingController(
      text: widget.product.sellingPrice.toString(),
    );
    _quantityController = TextEditingController(
      text: widget.product.quantity.toString(),
    );
    _minQuantityController = TextEditingController(
      text: widget.product.minQuantity.toString(),
    );
    _barcodeController =
        TextEditingController(text: widget.product.barcode ?? '');
    _notesController = TextEditingController(text: widget.product.notes ?? '');

    _selectedCategoryId = widget.product.categoryId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).loadCategories();
    });

    // Listen to price changes
    _purchasePriceController.addListener(_calculateProfit);
    _sellingPriceController.addListener(_calculateProfit);

    // Calculate initial profit
    _calculateProfit();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _quantityController.dispose();
    _minQuantityController.dispose();
    _barcodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _calculateProfit() {
    final purchase = double.tryParse(_purchasePriceController.text) ?? 0;
    final selling = double.tryParse(_sellingPriceController.text) ?? 0;

    setState(() {
      _calculatedProfit = selling - purchase;
      _profitMargin = purchase > 0 ? ((_calculatedProfit / purchase) * 100) : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          TextButton.icon(
            onPressed: _isLoading ? null : _handleSubmit,
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(
                    Icons.check,
                    color: AppColors.white,
                  ),
            label: const Text(
              'Update',
              style: TextStyle(color: AppColors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.sidebarBackground,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form Section (same as Add Product)
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Basic Information'),
                    SizedBox(height: 20.h),
                    _buildBasicInfo(),
                    SizedBox(height: 38.h),
                    _buildSectionTitle('Pricing'),
                    SizedBox(height: 22.h),
                    _buildPricing(),
                    SizedBox(height: 38.h),
                    _buildSectionTitle('Inventory'),
                    SizedBox(height: 22.h),
                    _buildInventory(),
                    SizedBox(height: 38.h),
                    _buildSectionTitle('Additional Information'),
                    SizedBox(height: 22.h),
                    _buildAdditionalInfo(),
                  ],
                ),
              ),
            ),
          ),

          // Image Section
          Container(
            width: 600.w,
            color: Colors.grey[50],
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Product Image'),
                  SizedBox(height: 20.h),
                  _buildImagePicker(),
                  SizedBox(height: 40.h),
                  _buildSectionTitle('Profit Summary'),
                  SizedBox(height: 22.h),
                  _buildProfitSummary(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Same widget methods as AddProductScreen...
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Product Name *',
            prefixIcon: Icon(Icons.inventory_2),
          ),
          textCapitalization: TextCapitalization.words,
          validator: (value) =>
              Validators.required(value, fieldName: 'Product name'),
        ),
        const SizedBox(height: 16),
        Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            return DropdownButtonFormField<int>(
              value: _selectedCategoryId,
              decoration: const InputDecoration(
                labelText: 'Category *',
                prefixIcon: Icon(Icons.category),
              ),
              items: categoryProvider.categories.map((category) {
                return DropdownMenuItem(
                  value: category.id,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCategoryId = value);
              },
              validator: (value) {
                if (value == null) return 'Please select a category';
                return null;
              },
            );
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _brandController,
          decoration: const InputDecoration(
            labelText: 'Brand',
            prefixIcon: Icon(Icons.branding_watermark),
          ),
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget _buildPricing() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _purchasePriceController,
            decoration: const InputDecoration(
              labelText: 'Purchase Price *',
              prefixIcon: Icon(Icons.shopping_cart),
              suffixText: 'DA',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: Validators.price,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _sellingPriceController,
            decoration: const InputDecoration(
              labelText: 'Selling Price *',
              prefixIcon: Icon(Icons.sell),
              suffixText: 'DA',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: Validators.price,
          ),
        ),
      ],
    );
  }

  Widget _buildInventory() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: 'Quantity *',
              prefixIcon: Icon(Icons.inventory),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: Validators.quantity,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _minQuantityController,
            decoration: const InputDecoration(
              labelText: 'Min Quantity',
              prefixIcon: Icon(Icons.warning_amber),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: Validators.quantity,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      children: [
        TextFormField(
          controller: _barcodeController,
          decoration: const InputDecoration(
            labelText: 'Barcode',
            prefixIcon: Icon(Icons.qr_code),
          ),
          validator: Validators.barcode,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'Notes',
            prefixIcon: Icon(Icons.note),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  // lib/views/products/edit_product_screen.dart

  Widget _buildImagePicker() {
    // Determine which image to display
    Widget imageWidget;

    if (_selectedImage != null) {
      // Priority 1: Show newly selected image
      imageWidget = Image.file(_selectedImage!, fit: BoxFit.cover);
    } else if (_isImageRemoved) {
      // Priority 2: Image was removed, show placeholder
      imageWidget = _buildPlaceholder();
    } else if (widget.product.imagePath != null &&
        widget.product.imagePath!.isNotEmpty) {
      // Priority 3: Show existing image
      imageWidget = Image.file(
        File(widget.product.imagePath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    } else {
      // Priority 4: No image at all
      imageWidget = _buildPlaceholder();
    }

    // Check if we have any image to show "Remove" button
    final hasImage = _selectedImage != null ||
        (!_isImageRemoved &&
            widget.product.imagePath != null &&
            widget.product.imagePath!.isNotEmpty);

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 400.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageWidget,
          ),
        ),

        SizedBox(height: 16.h),

        // Image picker buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('Gallery'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera'),
              ),
            ),
          ],
        ),

        // Remove button (only show if there's an image)
        if (hasImage) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _selectedImage = null;
                _isImageRemoved = true;
              });
            },
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text(
              'Remove Image',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_outlined, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          'No image',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildProfitSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          _buildProfitRow(
              'Profit per Unit', _calculatedProfit, AppColors.success),
          const Divider(height: 24),
          _buildProfitRow('Profit Margin', _profitMargin, AppColors.primary,
              isPercentage: true),
        ],
      ),
    );
  }

  Widget _buildProfitRow(String label, double value, Color color,
      {bool isPercentage = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        Text(
          isPercentage
              ? '${value.toStringAsFixed(1)}%'
              : '${value.toStringAsFixed(2)} DA',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024.w,
        maxHeight: 1024.h,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _isImageRemoved = false; // ⬅️ ADD THIS LINE
        });
      }
    } catch (e) {
      if (mounted) {
        Helpers.showSnackBar(
          context,
          'Failed to pick image: $e',
          isError: true,
        );
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Determine the final image path
    String? finalImagePath;

    if (_selectedImage != null) {
      // User selected a new image
      finalImagePath = _selectedImage!.path;
    } else if (_isImageRemoved) {
      // User removed the image
      finalImagePath = null;
    } else {
      // Keep the existing image
      finalImagePath = widget.product.imagePath;
    }

    final updatedProduct = widget.product.copyWith(
      name: _nameController.text.trim(),
      categoryId: _selectedCategoryId!,
      brand: _brandController.text.trim().isEmpty
          ? null
          : _brandController.text.trim(),
      purchasePrice: double.parse(_purchasePriceController.text),
      sellingPrice: double.parse(_sellingPriceController.text),
      quantity: int.parse(_quantityController.text),
      minQuantity: int.parse(_minQuantityController.text),
      barcode: _barcodeController.text.trim().isEmpty
          ? null
          : _barcodeController.text.trim(),
      imagePath: finalImagePath, // ⬅️ Use the determined path
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      updatedAt: DateTime.now(),
    );

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final success = await productProvider.updateProduct(updatedProduct);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        Helpers.showSnackBar(context, 'Product updated successfully');
        Navigator.pop(context);
      } else {
        Helpers.showSnackBar(
          context,
          productProvider.errorMessage ?? 'Failed to update product',
          isError: true,
        );
      }
    }
  }
}
