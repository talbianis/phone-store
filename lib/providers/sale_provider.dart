// lib/providers/sale_provider.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/data/models/sales_item_model.dart';
import 'package:phone_shop/data/models/sales_model.dart';

import '../data/models/cart_item_model.dart';
import '../data/models/debt_model.dart';
import '../data/repositories/sale_repository.dart';
import '../data/repositories/debt_repository.dart';
import '../data/repositories/customer_repository.dart';

class SaleProvider with ChangeNotifier {
  final SaleRepository _repository = SaleRepository();
  final DebtRepository _debtRepository = DebtRepository();
  final CustomerRepository _customerRepository = CustomerRepository();

  List<SaleModel> _sales = [];
  List<SaleModel> _filteredSales = [];
  List<SaleItemModel> _currentSaleItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SaleModel> get sales => _filteredSales;
  List<SaleItemModel> get currentSaleItems => _currentSaleItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ⬅️ FIXED: Create sale from cart
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
    _errorMessage = null;

    try {
      // Calculate totals
      final profit = cartItems.fold<double>(
        0.0,
        (sum, item) => sum + item.totalProfit,
      );

      final remainingDebt = total - paidAmount;

      // Generate invoice number
      final invoiceNumber = await _repository.generateInvoiceNumber();

      // Create sale model
      final sale = SaleModel(
        userId: userId,
        customerId: customerId,
        invoiceNumber: invoiceNumber,
        subtotal: subtotal,
        discount: discount,
        total: total,
        profit: profit,
        paymentMethod: paymentMethod,
        paidAmount: paidAmount,
        remainingDebt: remainingDebt,
        saleDate: DateTime.now(),
      );

      // ⬅️ FIX: Convert CartItems to SaleItems
      final saleItems = cartItems.map((cartItem) {
        return SaleItemModel(
          saleId: 0, // Will be updated by repository
          productId: cartItem.product.id!,
          productName: cartItem.product.name,
          quantity: cartItem.quantity,
          unitPrice: cartItem.product.sellingPrice,
          totalPrice: cartItem.totalPrice,
          profit: cartItem.product.profitPerUnit * cartItem.quantity,
        );
      }).toList();

      // Create sale with items
      final saleId = await _repository.createSale(sale, saleItems);

      debugPrint('✅ Sale created with ID: $saleId');

      // ⬅️ NEW: If payment is on credit/debt, create debt record
      if (paymentMethod.toLowerCase() == 'debt' &&
          customerId != null &&
          remainingDebt > 0) {
        final debt = DebtModel(
          customerId: customerId,
          saleId: saleId,
          totalAmount: remainingDebt,
          paidAmount: 0.0,
          remainingAmount: remainingDebt,
          status: 'unpaid',
          createdAt: DateTime.now(),
        );

        await _debtRepository.createDebt(debt);
        debugPrint('✅ Debt created for customer $customerId: $remainingDebt DA');

        // Update customer's total debt
        await _customerRepository.addToCustomerDebt(customerId, remainingDebt);
        debugPrint('✅ Customer debt updated');
      }

      await loadSales();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create sale: $e';
      debugPrint('❌ Error creating sale: $e');
      notifyListeners();
      return false;
    }
  }

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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    await filterByDate(today, tomorrow);
  }

  // Filter by date range
  Future<void> filterByDate(DateTime startDate, DateTime endDate) async {
    _isLoading = true;
    _errorMessage = null;
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

  // Search sales
  void searchSales(String query) {
    if (query.isEmpty) {
      _filteredSales = _sales;
    } else {
      _filteredSales = _sales.where((sale) {
        final invoiceLower = sale.invoiceNumber.toLowerCase();
        final customerLower = sale.customerName?.toLowerCase() ?? '';
        final queryLower = query.toLowerCase();

        return invoiceLower.contains(queryLower) ||
            customerLower.contains(queryLower);
      }).toList();
    }
    notifyListeners();
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

  // Get total sales amount
  double getTotalSalesAmount() {
    return _sales.fold<double>(0.0, (sum, sale) => sum + sale.total);
  }

  // Get total profit
  double getTotalProfit() {
    return _sales.fold<double>(0.0, (sum, sale) => sum + sale.profit);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
