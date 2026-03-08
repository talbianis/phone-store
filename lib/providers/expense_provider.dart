// lib/providers/expense_provider.dart

import 'package:flutter/material.dart';
import '../data/models/expense_model.dart';
import '../data/repositories/expense_repository.dart';

class ExpenseProvider with ChangeNotifier {
  final ExpenseRepository _repository = ExpenseRepository();

  List<ExpenseModel> _expenses = [];
  List<ExpenseModel> _filteredExpenses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ExpenseModel> get expenses => _filteredExpenses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load all expenses
  Future<void> loadExpenses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _expenses = await _repository.getAllExpenses();
      _filteredExpenses = _expenses;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load expenses: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load month expenses
  Future<void> loadMonthExpenses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _expenses = await _repository.getMonthExpenses();
      _filteredExpenses = _expenses;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load month expenses: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add expense
  Future<bool> addExpense(ExpenseModel expense) async {
    _errorMessage = null;

    try {
      await _repository.createExpense(expense);
      await loadExpenses();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add expense: $e';
      notifyListeners();
      return false;
    }
  }

  // Update expense
  Future<bool> updateExpense(ExpenseModel expense) async {
    _errorMessage = null;

    try {
      await _repository.updateExpense(expense);
      await loadExpenses();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update expense: $e';
      notifyListeners();
      return false;
    }
  }

  // Delete expense
  Future<bool> deleteExpense(int id) async {
    _errorMessage = null;

    try {
      await _repository.deleteExpense(id);
      await loadExpenses();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete expense: $e';
      notifyListeners();
      return false;
    }
  }

  // Filter by category
  void filterByCategory(String category) {
    if (category == 'All') {
      _filteredExpenses = _expenses;
    } else {
      _filteredExpenses = _expenses
          .where((e) => e.category == category)
          .toList();
    }
    notifyListeners();
  }

  // Filter by date range
  Future<void> filterByDateRange(DateTime startDate, DateTime endDate) async {
    _isLoading = true;
    notifyListeners();

    try {
      _expenses = await _repository.getExpensesByDateRange(startDate, endDate);
      _filteredExpenses = _expenses;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to filter expenses: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get total expenses
  double getTotalExpenses() {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  // Get month total
  Future<double> getMonthTotal() async {
    try {
      return await _repository.getMonthExpensesAmount();
    } catch (e) {
      return 0.0;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
