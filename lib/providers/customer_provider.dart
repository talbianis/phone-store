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
  CustomerModel? _selectedCustomer;

  List<CustomerModel> get customers => _filteredCustomers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  CustomerModel? get selectedCustomer => _selectedCustomer;

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

  // Add customer
  Future<bool> addCustomer(CustomerModel customer) async {
    _errorMessage = null;

    try {
      // Check if phone already exists
      final exists = await _repository.phoneExists(customer.phone);
      if (exists) {
        _errorMessage = 'Phone number already exists';
        notifyListeners();
        return false;
      }

      await _repository.createCustomer(customer);
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

    try {
      // Check if phone already exists (excluding current customer)
      final exists = await _repository.phoneExists(
        customer.phone,
        excludeCustomerId: customer.id,
      );
      if (exists) {
        _errorMessage = 'Phone number already exists';
        notifyListeners();
        return false;
      }

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
  Future<bool> deleteCustomer(int id) async {
    _errorMessage = null;

    try {
      await _repository.deleteCustomer(id);
      await loadCustomers();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Search customers
  void searchCustomers(String query) {
    if (query.isEmpty) {
      _filteredCustomers = _customers;
    } else {
      _filteredCustomers = _customers
          .where(
            (customer) =>
                customer.name.toLowerCase().contains(query.toLowerCase()) ||
                customer.phone.contains(query),
          )
          .toList();
    }
    notifyListeners();
  }

  // Filter customers with debt
  void filterCustomersWithDebt() {
    _filteredCustomers = _customers.where((c) => c.hasDebt).toList();
    notifyListeners();
  }

  // Reset filter
  void resetFilter() {
    _filteredCustomers = _customers;
    notifyListeners();
  }

  // Select customer
  void selectCustomer(CustomerModel? customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  // Get customer by ID
  CustomerModel? getCustomerById(int id) {
    try {
      return _customers.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get total debt
  double getTotalDebt() {
    return _customers.fold(0.0, (sum, customer) => sum + customer.totalDebt);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
