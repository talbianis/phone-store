// import 'package:flutter/material.dart';
// import 'package:phone_shop/data/models/debt_payement_model.dart';
// import '../data/models/debt_model.dart';
// import '../data/repositories/debt_repository.dart';

// class DebtProvider with ChangeNotifier {
//   final DebtRepository _repository = DebtRepository();

//   List<DebtModel> _debts = [];
//   List<DebtModel> _filteredDebts = [];
//   List<DebtPaymentModel> _paymentHistory = []; // ⬅️ Changed name
//   bool _isLoading = false;
//   String? _errorMessage;

//   List<DebtModel> get debts => _filteredDebts;
//   List<DebtPaymentModel> get paymentHistory =>
//       _paymentHistory; // ⬅️ Changed name
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   // Load all debts
//   Future<void> loadDebts() async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       _debts = await _repository.getAllDebts();
//       _filteredDebts = _debts;
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _errorMessage = 'Failed to load debts: $e';
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Load unpaid debts only
//   Future<void> loadUnpaidDebts() async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       _debts = await _repository.getUnpaidDebts();
//       _filteredDebts = _debts;
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _errorMessage = 'Failed to load unpaid debts: $e';
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // ⬅️ FIXED: Get debt by ID
//   DebtModel? getDebtById(int id) {
//     try {
//       return _debts.firstWhere((debt) => debt.id == id);
//     } catch (e) {
//       return null;
//     }
//   }

//   // ⬅️ FIXED: Search debts
//   void searchDebts(String query) {
//     if (query.isEmpty) {
//       _filteredDebts = _debts;
//     } else {
//       _filteredDebts = _debts.where((debt) {
//         final customerLower = debt.customerName?.toLowerCase() ?? '';
//         final invoiceLower = debt.invoiceNumber?.toLowerCase() ?? '';
//         final queryLower = query.toLowerCase();

//         return customerLower.contains(queryLower) ||
//             invoiceLower.contains(queryLower);
//       }).toList();
//     }
//     notifyListeners();
//   }

//   // ⬅️ FIXED: Filter by status
//   void filterByStatus(String status) {
//     switch (status) {
//       case 'unpaid':
//         _filteredDebts = _debts.where((d) => d.status == 'unpaid').toList();
//         break;
//       case 'partial':
//         _filteredDebts = _debts.where((d) => d.status == 'partial').toList();
//         break;
//       case 'paid':
//         _filteredDebts = _debts.where((d) => d.status == 'paid').toList();
//         break;
//       case 'all':
//       default:
//         _filteredDebts = _debts;
//         break;
//     }
//     notifyListeners();
//   }

//   // ⬅️ FIXED: Load payment history
//   Future<void> loadPaymentHistory(int debtId) async {
//     try {
//       _paymentHistory = await _repository.getPaymentHistory(debtId);
//       notifyListeners();
//     } catch (e) {
//       _errorMessage = 'Failed to load payment history: $e';
//       notifyListeners();
//     }
//   }

//   // Get total debt amount
//   double getTotalDebtAmount() {
//     return _debts.fold<double>(0.0, (sum, debt) => sum + debt.remainingAmount);
//   }

//   // Get debt count
//   int getDebtCount() {
//     return _debts.where((debt) => debt.remainingAmount > 0).length;
//   }

//   // Get total outstanding debt
//   Future<double> getTotalOutstandingDebt() async {
//     return await _repository.getTotalDebtAmount();
//   }

//   // Clear error
//   void clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }
// }

// // Future<bool> addPayment(int debtId, double amount, {String? notes}) async {
// //     _errorMessage = null;

// //     try {
// //       final payment = DebtPaymentModel(
// //         debtId: debtId,
// //         amount: amount,
// //         paymentDate: DateTime.now(),
// //         notes: notes,
// //       );

// //       await _repository.addPayment(payment, debtId);
// //       await loadDebts();
// //       return true;
// //     } catch (e) {
// //       _errorMessage = 'Failed to add payment: $e';
// //       notifyListeners();
// //       return false;
// //     }
// //   }
// lib/providers/debt_provider.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/data/models/debt_payement_model.dart';
import '../data/models/debt_model.dart';
import '../data/repositories/debt_repository.dart';

class DebtProvider with ChangeNotifier {
  final DebtRepository _repository = DebtRepository();

  List<DebtModel> _debts = [];
  List<DebtModel> _filteredDebts = [];
  List<DebtPaymentModel> _paymentHistory = []; // ⬅️ Changed name
  bool _isLoading = false;
  String? _errorMessage;

  List<DebtModel> get debts => _filteredDebts;
  List<DebtPaymentModel> get paymentHistory =>
      _paymentHistory; // ⬅️ Changed name
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
      debugPrint('Loaded debts: ${_debts.length}');
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

  // ⬅️ FIXED: Get debt by ID
  DebtModel? getDebtById(int id) {
    try {
      return _debts.firstWhere((debt) => debt.id == id);
    } catch (e) {
      return null;
    }
  }

  // ⬅️ FIXED: Search debts
  void searchDebts(String query) {
    if (query.isEmpty) {
      _filteredDebts = _debts;
    } else {
      _filteredDebts = _debts.where((debt) {
        final customerLower = debt.customerName?.toLowerCase() ?? '';
        final invoiceLower = debt.invoiceNumber?.toLowerCase() ?? '';
        final queryLower = query.toLowerCase();

        return customerLower.contains(queryLower) ||
            invoiceLower.contains(queryLower);
      }).toList();
    }
    notifyListeners();
  }

  // ⬅️ FIXED: Filter by status
  void filterByStatus(String status) {
    switch (status) {
      case 'unpaid':
        _filteredDebts = _debts.where((d) => d.status == 'unpaid').toList();
        break;
      case 'partial':
        _filteredDebts = _debts.where((d) => d.status == 'partial').toList();
        break;
      case 'paid':
        _filteredDebts = _debts.where((d) => d.status == 'paid').toList();
        break;
      case 'all':
      default:
        _filteredDebts = _debts;
        break;
    }
    notifyListeners();
  }

  // ⬅️ FIXED: Add payment (updated to match your repository signature)
  Future<bool> addPayment(DebtPaymentModel payment) async {
    _errorMessage = null;
    notifyListeners();

    try {
      // Your repository expects (payment, debtId) signature
      await _repository.addPayment(payment, payment.debtId);

      // Reload debts to get updated amounts
      await loadDebts();

      return true;
    } catch (e) {
      _errorMessage = 'Failed to add payment: $e';
      notifyListeners();
      return false;
    }
  }

  // ⬅️ FIXED: Load payment history
  Future<void> loadPaymentHistory(int debtId) async {
    try {
      _paymentHistory = await _repository.getPaymentHistory(debtId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load payment history: $e';
      notifyListeners();
    }
  }

  // Get total debt amount
  double getTotalDebtAmount() {
    return _debts.fold<double>(0.0, (sum, debt) => sum + debt.remainingAmount);
  }

  // Get debt count
  int getDebtCount() {
    return _debts.where((debt) => debt.remainingAmount > 0).length;
  }

  // Get total outstanding debt
  Future<double> getTotalOutstandingDebt() async {
    return await _repository.getTotalDebtAmount();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
