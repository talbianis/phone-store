// lib/views/products/edit_product_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/layout/desktop_adaptive.dart';
import '../../core/localization/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProduct),
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
            label: Text(
              l10n.updateButton,
              style: const TextStyle(color: AppColors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.sidebarBackground,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final l10n = AppLocalizations.of(context);
          final narrow = constraints.maxWidth < 1040;
          final formBody = _buildFormBody(l10n);
          final imageBody = _buildImageSideContent(l10n);

          if (narrow) {
            return SingleChildScrollView(
              padding: desktopPagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  formBody,
                  const Divider(height: 40),
                  imageBody,
                ],
              ),
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  padding: desktopPagePadding(context),
                  child: formBody,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.grey[50],
                  child: SingleChildScrollView(
                    padding: desktopPagePadding(context),
                    child: imageBody,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFormBody(AppLocalizations l10n) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(l10n, l10n.basicInformation),
          const SizedBox(height: 16),
          _buildBasicInfo(l10n),
          const SizedBox(height: 32),
          _buildSectionTitle(l10n, l10n.pricingSection),
          const SizedBox(height: 16),
          _buildPricing(l10n),
          const SizedBox(height: 32),
          _buildSectionTitle(l10n, l10n.inventorySection),
          const SizedBox(height: 16),
          _buildInventory(l10n),
          const SizedBox(height: 32),
          _buildSectionTitle(l10n, l10n.additionalInformation),
          const SizedBox(height: 16),
          _buildAdditionalInfo(l10n),
        ],
      ),
    );
  }

  Widget _buildImageSideContent(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(l10n, l10n.productImage),
        const SizedBox(height: 16),
        _buildImagePicker(l10n),
        const SizedBox(height: 32),
        _buildSectionTitle(l10n, l10n.profitSummary),
        const SizedBox(height: 16),
        _buildProfitSummary(l10n),
      ],
    );
  }

  // Same widget methods as AddProductScreen...
  Widget _buildSectionTitle(AppLocalizations l10n, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: desktopSectionTitleFontSize(context),
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
                if (value == null) return l10n.pleaseSelectCategory;
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
            prefixIcon: const Icon(Icons.branding_watermark),
          ),
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget _buildPricing(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _purchasePriceController,
            decoration: InputDecoration(
              labelText: '${l10n.buyingPrice} *',
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
    );
  }

  Widget _buildInventory(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _quantityController,
            decoration: InputDecoration(
              labelText: l10n.quantityLabel,
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
              labelText: l10n.minQuantityLabel,
              prefixIcon: const Icon(Icons.warning_amber),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) => Validators.quantity(v, l10n),
          ),
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
            labelText: l10n.barcode,
            prefixIcon: const Icon(Icons.qr_code),
          ),
          validator: (v) => Validators.barcode(v, l10n),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _notesController,
          decoration: InputDecoration(
            labelText: l10n.notes,
            prefixIcon: const Icon(Icons.note),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildImagePicker(AppLocalizations l10n) {
    // Determine which image to display
    Widget imageWidget;

    if (_selectedImage != null) {
      // Priority 1: Show newly selected image
      imageWidget = Image.file(_selectedImage!, fit: BoxFit.cover);
    } else if (_isImageRemoved) {
      // Priority 2: Image was removed, show placeholder
      imageWidget = _buildPlaceholder(l10n);
    } else if (widget.product.imagePath != null &&
        widget.product.imagePath!.isNotEmpty) {
      // Priority 3: Show existing image
      imageWidget = Image.file(
        File(widget.product.imagePath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(l10n);
        },
      );
    } else {
      // Priority 4: No image at all
      imageWidget = _buildPlaceholder(l10n);
    }

    // Check if we have any image to show "Remove" button
    final hasImage = _selectedImage != null ||
        (!_isImageRemoved &&
            widget.product.imagePath != null &&
            widget.product.imagePath!.isNotEmpty);

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final previewHeight =
                (constraints.maxWidth * 0.72).clamp(200.0, 440.0);
            return Container(
              width: double.infinity,
              height: previewHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageWidget,
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // Image picker buttons
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
            label: Text(
              l10n.removeImage,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlaceholder(AppLocalizations l10n) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_outlined, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          l10n.noImageShort,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
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
              l10n.profitPerUnit, _calculatedProfit, AppColors.success, l10n),
          const Divider(height: 24),
          _buildProfitRow(l10n.profitMarginLabel, _profitMargin,
              AppColors.primary, l10n,
              isPercentage: true),
        ],
      ),
    );
  }

  Widget _buildProfitRow(
      String label, double value, Color color, AppLocalizations l10n,
      {bool isPercentage = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        Text(
          isPercentage
              ? '${value.toStringAsFixed(1)}%'
              : '${value.toStringAsFixed(2)} ${l10n.currency}',
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
        maxWidth: 1024,
        maxHeight: 1024,
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
      final l10n = AppLocalizations.of(context);
      if (success) {
        Helpers.showSnackBar(context, l10n.productUpdateSuccess);
        Navigator.pop(context);
      } else {
        if (productProvider.errorMessage != null) {
          debugPrint(productProvider.errorMessage);
        }
        Helpers.showSnackBar(
          context,
          l10n.failedUpdateProduct,
          isError: true,
        );
      }
    }
  }
}
