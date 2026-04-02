// lib/providers/customer_provider.dart

import 'package:flutter/material.dart';
import '../data/models/customer_model.dart';
import '../data/repositories/customer_repository.dart';

class CustomerProvider with ChangeNotifier {
  final CustomerRepository _repository = CustomerRepository();

  List<CustomerModel> _customers = [];
  List<CustomerModel> _filteredCustomers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CustomerModel> get customers => _filteredCustomers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load all customers
  Future<void> loadCustomers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _customers = await _repository.getAllCustomers();
      _filteredCustomers = _customers;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load customers: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update customer debt (for recording payments)
  Future<bool> updateCustomerDebt(int customerId, double newDebt) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateCustomerDebt(customerId, newDebt);
      await loadCustomers();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update debt: $e';
      notifyListeners();
      return false;
    }
  }

  // Add customer
  Future<bool> addCustomer(CustomerModel customer) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.addCustomer(customer);
      await loadCustomers();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add customer: $e';
      notifyListeners();
      return false;
    }
  }

  // Update customer
  Future<bool> updateCustomer(CustomerModel customer) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateCustomer(customer);
      await loadCustomers();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update customer: $e';
      notifyListeners();
      return false;
    }
  }

  // Delete customer
  Future<bool> deleteCustomer(int customerId) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteCustomer(customerId);
      await loadCustomers();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete customer: $e';
      notifyListeners();
      return false;
    }
  }

  // ⬅️ ADD THIS METHOD: Search customers
  void searchCustomers(String query) {
    if (query.isEmpty) {
      _filteredCustomers = _customers;
    } else {
      _filteredCustomers = _customers.where((customer) {
        final nameLower = customer.name.toLowerCase();
        final phoneLower = customer.phone.toLowerCase();

        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower) ||
            phoneLower.contains(queryLower);
      }).toList();
    }
    notifyListeners();
  }

  // ⬅️ ADD THIS METHOD: Filter by debt status
  void filterByDebt(String filter) {
    switch (filter) {
      case 'has_debt':
        _filteredCustomers = _customers.where((c) => c.totalDebt > 0).toList();
        break;
      case 'no_debt':
        _filteredCustomers = _customers.where((c) => c.totalDebt == 0).toList();
        break;
      case 'all':
      default:
        _filteredCustomers = _customers;
        break;
    }
    notifyListeners();
  }

  // Get customer by ID
  CustomerModel? getCustomerById(int id) {
    try {
      return _customers.firstWhere((customer) => customer.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get top customers
  Future<List<CustomerModel>> getTopCustomers({int limit = 5}) async {
    return await _repository.getTopCustomers(limit: limit);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
