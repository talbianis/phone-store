// lib/views/products/add_product_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../providers/category_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minQuantityController = TextEditingController(text: '5');
  final _barcodeController = TextEditingController();
  final _notesController = TextEditingController();

  int? _selectedCategoryId;
  File? _selectedImage;
  bool _isLoading = false;
  double _calculatedProfit = 0.0;
  double _profitMargin = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).loadCategories();
    });

    // Listen to price changes for profit calculation
    _purchasePriceController.addListener(_calculateProfit);
    _sellingPriceController.addListener(_calculateProfit);
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
        title: const Text('Add New Product'),
        actions: [
          TextButton.icon(
            onPressed: _isLoading ? null : _handleSubmit,
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: const Text('Save'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form Section
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
                    const SizedBox(height: 16),
                    _buildBasicInfo(),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Pricing'),
                    const SizedBox(height: 16),
                    _buildPricing(),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Inventory'),
                    const SizedBox(height: 16),
                    _buildInventory(),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Additional Information'),
                    const SizedBox(height: 16),
                    _buildAdditionalInfo(),
                  ],
                ),
              ),
            ),
          ),

          // Image Section
          Container(
            width: 400,
            color: Colors.grey[50],
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Product Image'),
                const SizedBox(height: 16),
                _buildImagePicker(),
                const SizedBox(height: 32),
                _buildSectionTitle('Profit Summary'),
                const SizedBox(height: 16),
                _buildProfitSummary(),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
        // Product Name
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Product Name *',
            hintText: 'e.g., iPhone 15 Pro Max',
            prefixIcon: Icon(Icons.inventory_2),
          ),
          textCapitalization: TextCapitalization.words,
          validator: (value) =>
              Validators.required(value, fieldName: 'Product name'),
        ),

        const SizedBox(height: 16),

        // Category
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
                if (value == null) {
                  return 'Please select a category';
                }
                return null;
              },
            );
          },
        ),

        const SizedBox(height: 16),

        // Brand
        TextFormField(
          controller: _brandController,
          decoration: const InputDecoration(
            labelText: 'Brand',
            hintText: 'e.g., Apple, Samsung',
            prefixIcon: Icon(Icons.branding_watermark),
          ),
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget _buildPricing() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _purchasePriceController,
                decoration: const InputDecoration(
                  labelText: 'Purchase Price *',
                  hintText: '0.00',
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
                  hintText: '0.00',
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
        ),
      ],
    );
  }

  Widget _buildInventory() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Initial Quantity *',
                  hintText: '0',
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
                  labelText: 'Min Quantity (Alert)',
                  hintText: '5',
                  prefixIcon: Icon(Icons.warning_amber),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: Validators.quantity,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      children: [
        // Barcode
        TextFormField(
          controller: _barcodeController,
          decoration: const InputDecoration(
            labelText: 'Barcode (Optional)',
            hintText: 'Scan or enter barcode',
            prefixIcon: Icon(Icons.qr_code),
          ),
          validator: Validators.barcode,
        ),

        const SizedBox(height: 16),

        // Notes
        TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'Notes (Optional)',
            hintText: 'Additional details about the product',
            prefixIcon: Icon(Icons.note),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: _selectedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No image selected',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 16),
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
        if (_selectedImage != null) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              setState(() => _selectedImage = null);
            },
            icon: const Icon(Icons.delete, color: Colors.red),
            label:
                const Text('Remove Image', style: TextStyle(color: Colors.red)),
          ),
        ],
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
            'Profit per Unit',
            _calculatedProfit,
            AppColors.success,
          ),
          const Divider(height: 24),
          _buildProfitRow(
            'Profit Margin',
            _profitMargin,
            AppColors.primary,
            isPercentage: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProfitRow(String label, double value, Color color,
      {bool isPercentage = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        Text(
          isPercentage
              ? '${value.toStringAsFixed(1)}%'
              : '${value.toStringAsFixed(2)} DA',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final product = ProductModel(
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
      imagePath: _selectedImage?.path,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );

    final success = await productProvider.addProduct(product);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        Helpers.showSnackBar(context, 'Product added successfully');
        Navigator.pop(context);
      } else {
        Helpers.showSnackBar(
          context,
          productProvider.errorMessage ?? 'Failed to add product',
          isError: true,
        );
      }
    }
  }
}
