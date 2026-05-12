// lib/views/products/add_product_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addNewProduct),
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
            label: Text(l10n.save),
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
                    _buildSectionTitle(l10n.basicInformation),
                    const SizedBox(height: 16),
                    _buildBasicInfo(l10n),
                    const SizedBox(height: 32),
                    _buildSectionTitle(l10n.pricingSection),
                    const SizedBox(height: 16),
                    _buildPricing(l10n),
                    const SizedBox(height: 32),
                    _buildSectionTitle(l10n.inventorySection),
                    const SizedBox(height: 16),
                    _buildInventory(l10n),
                    const SizedBox(height: 32),
                    _buildSectionTitle(l10n.additionalInformation),
                    const SizedBox(height: 16),
                    _buildAdditionalInfo(l10n),
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(l10n.productImage),
                  const SizedBox(height: 16),
                  _buildImagePicker(l10n),
                  const SizedBox(height: 32),
                  _buildSectionTitle(l10n.profitSummary),
                  const SizedBox(height: 16),
                  _buildProfitSummary(l10n),
                ],
              ),
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

  Widget _buildBasicInfo(AppLocalizations l10n) {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: l10n.productNameRequired,
            hintText: l10n.hintProductNameEx,
            prefixIcon: const Icon(Icons.inventory_2),
          ),
          textCapitalization: TextCapitalization.words,
          validator: (value) => Validators.required(
            value,
            l10n,
            fieldName: l10n.productName,
          ),
        ),

        const SizedBox(height: 16),

        Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            return DropdownButtonFormField<int>(
              value: _selectedCategoryId,
              decoration: InputDecoration(
                labelText: l10n.selectCategory,
                prefixIcon: const Icon(Icons.category),
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
                  return l10n.pleaseSelectCategory;
                }
                return null;
              },
            );
          },
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _brandController,
          decoration: InputDecoration(
            labelText: l10n.brand,
            hintText: l10n.hintBrandEx,
            prefixIcon: const Icon(Icons.branding_watermark),
          ),
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget _buildPricing(AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _purchasePriceController,
                decoration: InputDecoration(
                  labelText: '${l10n.buyingPrice} *',
                  hintText: l10n.hintPriceZero,
                  prefixIcon: const Icon(Icons.shopping_cart),
                  suffixText: l10n.currency,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (v) => Validators.price(v, l10n),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _sellingPriceController,
                decoration: InputDecoration(
                  labelText: '${l10n.sellingPrice} *',
                  hintText: l10n.hintPriceZero,
                  prefixIcon: const Icon(Icons.sell),
                  suffixText: l10n.currency,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (v) => Validators.price(v, l10n),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInventory(AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: l10n.initialQuantity,
                  hintText: l10n.hintQuantityZero,
                  prefixIcon: const Icon(Icons.inventory),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => Validators.quantity(v, l10n),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _minQuantityController,
                decoration: InputDecoration(
                  labelText: l10n.minQuantityAlert,
                  hintText: l10n.hintMinStock,
                  prefixIcon: const Icon(Icons.warning_amber),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => Validators.quantity(v, l10n),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo(AppLocalizations l10n) {
    return Column(
      children: [
        TextFormField(
          controller: _barcodeController,
          decoration: InputDecoration(
            labelText: l10n.barcodeOptional,
            hintText: l10n.hintBarcode,
            prefixIcon: const Icon(Icons.qr_code),
          ),
          validator: (v) => Validators.barcode(v, l10n),
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _notesController,
          decoration: InputDecoration(
            labelText: l10n.notesOptional,
            hintText: l10n.hintProductNotes,
            prefixIcon: const Icon(Icons.note),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildImagePicker(AppLocalizations l10n) {
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
                      l10n.noImageSelected,
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
                label: Text(l10n.gallery),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: Text(l10n.camera),
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
            label: Text(
              l10n.removeImage,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProfitSummary(AppLocalizations l10n) {
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
            l10n.profitPerUnit,
            _calculatedProfit,
            AppColors.success,
            l10n,
          ),
          const Divider(height: 24),
          _buildProfitRow(
            l10n.profitMarginLabel,
            _profitMargin,
            AppColors.primary,
            l10n,
            isPercentage: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProfitRow(
    String label,
    double value,
    Color color,
    AppLocalizations l10n, {
    bool isPercentage = false,
  }) {
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
              : '${value.toStringAsFixed(2)} ${l10n.currency}',
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
        final l10n = AppLocalizations.of(context);
        debugPrint('$e');
        Helpers.showSnackBar(
          context,
          l10n.failedPickImage,
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
      final l10n = AppLocalizations.of(context);
      if (success) {
        Helpers.showSnackBar(context, l10n.productAddSuccess);
        Navigator.pop(context);
      } else {
        if (productProvider.errorMessage != null) {
          debugPrint(productProvider.errorMessage);
        }
        Helpers.showSnackBar(
          context,
          l10n.failedAddProduct,
          isError: true,
        );
      }
    }
  }
}
