// lib/providers/dashboard_provider.dart

import 'package:flutter/material.dart';
import '../data/repositories/sale_repository.dart';
import '../data/repositories/product_repository.dart';
import '../data/repositories/customer_repository.dart';
import '../data/repositories/expense_repository.dart';

class DashboardProvider with ChangeNotifier {
  final SaleRepository _saleRepo = SaleRepository();
  final ProductRepository _productRepo = ProductRepository();
  final CustomerRepository _customerRepo = CustomerRepository();
  final ExpenseRepository _expenseRepo = ExpenseRepository();

  bool _isLoading = false;
  String? _errorMessage;

  // Today stats
  double _todaySales = 0.0;
  double _todayProfit = 0.0;
  int _todaySalesCount = 0;

  // Month stats
  double _monthlySales = 0.0;
  double _monthlyProfit = 0.0;
  double _monthlyExpenses = 0.0;

  // Product stats
  int _lowStockCount = 0;
  int _outOfStockCount = 0;
  int _totalProducts = 0;

  // Customer stats
  int _totalCustomers = 0;
  double _totalDebt = 0.0;

  // Chart data
  List<Map<String, dynamic>> _last7DaysSales = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get todaySales => _todaySales;
  double get todayProfit => _todayProfit;
  int get todaySalesCount => _todaySalesCount;

  double get monthlySales => _monthlySales;
  double get monthlyProfit => _monthlyProfit;
  double get monthlyExpenses => _monthlyExpenses;
  double get netProfit => _monthlyProfit - _monthlyExpenses;

  int get lowStockCount => _lowStockCount;
  int get outOfStockCount => _outOfStockCount;
  int get totalProducts => _totalProducts;

  int get totalCustomers => _totalCustomers;
  double get totalDebt => _totalDebt;

  List<Map<String, dynamic>> get last7DaysSales => _last7DaysSales;

  // Load all dashboard data
  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Load all data in parallel
      await Future.wait([
        _loadTodayStats(),
        _loadMonthStats(),
        _loadProductStats(),
        _loadCustomerStats(),
        _loadChartData(),
      ]);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load dashboard data: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load today's statistics
  Future<void> _loadTodayStats() async {
    _todaySales = await _saleRepo.getTodaySalesAmount();
    _todayProfit = await _saleRepo.getTodayProfit();
    _todaySalesCount = await _saleRepo.getTodaySalesCount();
  }

  // Load monthly statistics
  Future<void> _loadMonthStats() async {
    final monthSales = await _saleRepo.getMonthSales();
    _monthlySales = monthSales.fold(0.0, (sum, sale) => sum + sale.total);
    _monthlyProfit = await _saleRepo.getMonthProfit();
    _monthlyExpenses = await _expenseRepo.getMonthExpensesAmount();
  }

  // Load product statistics
  Future<void> _loadProductStats() async {
    final lowStockProducts = await _productRepo.getLowStockProducts();
    final outOfStockProducts = await _productRepo.getOutOfStockProducts();

    _lowStockCount = lowStockProducts.length;
    _outOfStockCount = outOfStockProducts.length;
    _totalProducts = await _productRepo.getProductCount();
  }

  // Load customer statistics
  Future<void> _loadCustomerStats() async {
    _totalCustomers = await _customerRepo.getCustomerCount();
    _totalDebt = await _customerRepo.getTotalDebt();
  }

  // Load chart data
  Future<void> _loadChartData() async {
    try {
      _last7DaysSales = await _saleRepo.getLast7DaysSales();
    } catch (e) {
      // If no data, create empty list
      _last7DaysSales = [];
      print('No chart data available: $e');
    }
  }

  // Refresh data
  Future<void> refresh() async {
    await loadDashboardData();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
