// lib/providers/sale_provider.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/data/models/sales_item_model.dart';
import 'package:phone_shop/data/models/sales_model.dart';

import '../data/models/cart_item_model.dart';
import '../data/repositories/sale_repository.dart';

class SaleProvider with ChangeNotifier {
  final SaleRepository _repository = SaleRepository();

  List<SaleModel> _sales = [];
  List<SaleModel> _filteredSales = [];
  List<SaleItemModel> _currentSaleItems = [];
  bool _isLoading = false;
  String? _errorMessage;
  SaleModel? _selectedSale;

  List<SaleModel> get sales => _filteredSales;
  List<SaleItemModel> get currentSaleItems => _currentSaleItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  SaleModel? get selectedSale => _selectedSale;

  // Load all sales
  Future<void> loadSales() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _sales = await _repository.getAllSales();
      _filteredSales = _sales;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load sales: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load today's sales
  Future<void> loadTodaySales() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _sales = await _repository.getTodaySales();
      _filteredSales = _sales;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load today\'s sales: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create sale from cart
  Future<bool> createSaleFromCart({
    required List<CartItemModel> cartItems,
    required int userId,
    required double subtotal,
    required double discount,
    required double total,
    required String paymentMethod,
    required double paidAmount,
    int? customerId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Generate invoice number
      final invoiceNumber = await _repository.generateInvoiceNumber();

      // Calculate profit
      final profit =
          cartItems.fold<double>(0.0, (sum, item) => sum + item.totalProfit);

      // Calculate remaining debt
      final remainingDebt = total - paidAmount;

      // Create sale model
      final sale = SaleModel(
        invoiceNumber: invoiceNumber,
        customerId: customerId,
        userId: userId,
        subtotal: subtotal,
        discount: discount,
        total: total,
        paymentMethod: paymentMethod,
        paidAmount: paidAmount,
        remainingDebt: remainingDebt,
        profit: profit,
        saleDate: DateTime.now(),
      );

      // Create sale items
      final saleItems = cartItems.map((cartItem) {
        return SaleItemModel(
          saleId: 0, // Will be set by repository
          productId: cartItem.product.id!,
          productName: cartItem.product.name,
          quantity: cartItem.quantity,
          unitPrice: cartItem.product.sellingPrice,
          totalPrice: cartItem.totalPrice,
          profit: cartItem.totalProfit,
        );
      }).toList();

      // Save to database
      await _repository.createSale(sale, saleItems);

      await loadSales();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create sale: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Load sale items
  Future<void> loadSaleItems(int saleId) async {
    try {
      _currentSaleItems = await _repository.getSaleItems(saleId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load sale items: $e';
      notifyListeners();
    }
  }

  // Search sales
  void searchSales(String query) {
    if (query.isEmpty) {
      _filteredSales = _sales;
    } else {
      _filteredSales = _sales
          .where(
            (sale) =>
                sale.invoiceNumber.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                (sale.customerName?.toLowerCase().contains(
                          query.toLowerCase(),
                        ) ??
                    false),
          )
          .toList();
    }
    notifyListeners();
  }

  // Filter by date
  Future<void> filterByDate(DateTime startDate, DateTime endDate) async {
    _isLoading = true;
    notifyListeners();

    try {
      _sales = await _repository.getSalesByDateRange(startDate, endDate);
      _filteredSales = _sales;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to filter sales: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Select sale
  void selectSale(SaleModel? sale) {
    _selectedSale = sale;
    if (sale != null) {
      loadSaleItems(sale.id!);
    }
    notifyListeners();
  }

  // Get today's statistics
  Future<Map<String, dynamic>> getTodayStatistics() async {
    try {
      final totalSales = await _repository.getTodaySalesAmount();
      final totalProfit = await _repository.getTodayProfit();
      final salesCount = await _repository.getTodaySalesCount();

      return {
        'totalSales': totalSales,
        'totalProfit': totalProfit,
        'salesCount': salesCount,
      };
    } catch (e) {
      return {'totalSales': 0.0, 'totalProfit': 0.0, 'salesCount': 0};
    }
  }

  // Get month statistics
  Future<Map<String, dynamic>> getMonthStatistics() async {
    try {
      final monthSales = await _repository.getMonthSales();
      final totalSales =
          monthSales.fold<double>(0.0, (sum, sale) => sum + sale.total);
      final totalProfit = monthSales.fold<double>(
        0.0,
        (sum, sale) => sum + sale.profit,
      );

      return {
        'totalSales': totalSales,
        'totalProfit': totalProfit,
        'salesCount': monthSales.length,
      };
    } catch (e) {
      return {'totalSales': 0.0, 'totalProfit': 0.0, 'salesCount': 0};
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
