// lib/providers/category_provider.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/data/models/category_model.dart';
import '../data/repositories/category_repository.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryRepository _repository = CategoryRepository();

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  CategoryModel? _selectedCategory;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  CategoryModel? get selectedCategory => _selectedCategory;

  // Load all categories
  Future<void> loadCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _repository.getAllCategories();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load categories: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add category
  Future<bool> addCategory(CategoryModel category) async {
    _errorMessage = null;

    try {
      // Check if name already exists
      final exists = await _repository.categoryExists(category.name);
      if (exists) {
        _errorMessage = 'Category name already exists';
        notifyListeners();
        return false;
      }

      await _repository.createCategory(category);
      await loadCategories();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add category: $e';
      notifyListeners();
      return false;
    }
  }

  // Update category
  Future<bool> updateCategory(CategoryModel category) async {
    _errorMessage = null;

    try {
      // Check if name already exists (excluding current category)
      final exists = await _repository.categoryExists(
        category.name,
        excludeCategoryId: category.id,
      );
      if (exists) {
        _errorMessage = 'Category name already exists';
        notifyListeners();
        return false;
      }

      await _repository.updateCategory(category);
      await loadCategories();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update category: $e';
      notifyListeners();
      return false;
    }
  }

  // Delete category
  Future<bool> deleteCategory(int id) async {
    _errorMessage = null;

    try {
      await _repository.deleteCategory(id);
      await loadCategories();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Select category
  void selectCategory(CategoryModel? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Get category by ID
  CategoryModel? getCategoryById(int id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
