// lib/providers/debt_provider.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/data/models/debt_payement_model.dart';
import '../data/models/debt_model.dart';

import '../data/repositories/debt_repository.dart';

class DebtProvider with ChangeNotifier {
  final DebtRepository _repository = DebtRepository();

  List<DebtModel> _debts = [];
  List<DebtModel> _filteredDebts = [];
  List<DebtPaymentModel> _currentPaymentHistory = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<DebtModel> get debts => _filteredDebts;
  List<DebtPaymentModel> get currentPaymentHistory => _currentPaymentHistory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load all debts
  Future<void> loadDebts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _debts = await _repository.getAllDebts();
      _filteredDebts = _debts;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load debts: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load unpaid debts only
  Future<void> loadUnpaidDebts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _debts = await _repository.getUnpaidDebts();
      _filteredDebts = _debts;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load unpaid debts: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add payment
  Future<bool> addPayment(int debtId, double amount, {String? notes}) async {
    _errorMessage = null;

    try {
      final payment = DebtPaymentModel(
        debtId: debtId,
        amount: amount,
        paymentDate: DateTime.now(),
        notes: notes,
      );

      await _repository.addPayment(payment, debtId);
      await loadDebts();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add payment: $e';
      notifyListeners();
      return false;
    }
  }

  // Load payment history
  Future<void> loadPaymentHistory(int debtId) async {
    try {
      _currentPaymentHistory = await _repository.getPaymentHistory(debtId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load payment history: $e';
      notifyListeners();
    }
  }

  // Filter by status
  void filterByStatus(String status) {
    if (status == 'all') {
      _filteredDebts = _debts;
    } else {
      _filteredDebts = _debts.where((debt) => debt.status == status).toList();
    }
    notifyListeners();
  }

  // Get total debt amount
  double getTotalDebtAmount() {
    return _debts.fold(0.0, (sum, debt) => sum + debt.remainingAmount);
  }

  // Get debt count
  int getDebtCount() {
    return _debts.where((debt) => debt.remainingAmount > 0).length;
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
