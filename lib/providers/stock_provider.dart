// lib/providers/stock_provider.dart

// Make sure your StockProvider has these methods:

import 'package:flutter/material.dart';
import '../data/models/stock_adjustment_model.dart';
import '../data/repositories/stock_repository.dart';

class StockProvider with ChangeNotifier {
  final StockRepository _repository = StockRepository();

  List<StockAdjustmentModel> _adjustments = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<StockAdjustmentModel> get adjustments => _adjustments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load all adjustments
  Future<void> loadAdjustments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _adjustments = await _repository.getAllAdjustments();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load adjustments: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add stock adjustment
  Future<bool> addAdjustment(StockAdjustmentModel adjustment) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.createStockAdjustment(adjustment);
      await loadAdjustments();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add adjustment: $e';
      notifyListeners();
      return false;
    }
  }

  // Get adjustments by product
  Future<List<StockAdjustmentModel>> getProductAdjustments(
    int productId,
  ) async {
    return await _repository.getAdjustmentsByProduct(productId);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
