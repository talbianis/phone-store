// lib/views/expenses/expenses_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/utils/currency_formatter.dart';

import '../../providers/expense_provider.dart';
import '../shared/main_layout.dart';
import 'widgets/expense_card.dart';
import 'widgets/add_expense_dialog.dart';
import 'widgets/edit_expense_dialog.dart';
import 'widgets/date_filter_dialog.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key? key}) : super(key: key);

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'month'; // today, week, month, all, custom
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExpenses();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadExpenses() {
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);

    switch (_selectedFilter) {
      case 'today':
        expenseProvider.loadTodayExpenses();
        break;
      case 'week':
        final now = DateTime.now();
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        expenseProvider.filterByDateRange(weekStart, weekEnd);
        break;
      case 'month':
        expenseProvider.loadMonthExpenses();
        break;
      case 'custom':
        if (_customStartDate != null && _customEndDate != null) {
          expenseProvider.filterByDateRange(_customStartDate!, _customEndDate!);
        }
        break;
      case 'all':
      default:
        expenseProvider.loadExpenses();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentRoute: AppRoutes.expenses,
      child: Column(
        children: [
          // Header Section
          _buildHeader(),
          const Divider(height: 1),

          // Filters Section
          _buildFilters(),
          const Divider(height: 1),

          // Stats Summary
          _buildStatsSummary(),
          const Divider(height: 1),

          // Expenses List
          Expanded(
            child: Consumer<ExpenseProvider>(
              builder: (context, expenseProvider, child) {
                if (expenseProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (expenseProvider.expenses.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildExpensesList(expenseProvider);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Expenses Management',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Consumer<ExpenseProvider>(
                  builder: (context, provider, child) {
                    return Text(
                      '${provider.expenses.length} expenses recorded',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: _showAddExpenseDialog,
            icon: const Icon(
              Icons.add,
              size: 20,
              color: AppColors.white,
            ),
            label: const Text(
              'Add Expense',
              style: TextStyle(color: AppColors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sidebarBackground,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          // Search Bar
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by description or category...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _handleSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: _handleSearch,
            ),
          ),

          const SizedBox(width: 16),

          // Date Filter Dropdown
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedFilter,
              decoration: InputDecoration(
                labelText: 'Period',
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'today', child: Text('Today')),
                DropdownMenuItem(value: 'week', child: Text('This Week')),
                DropdownMenuItem(value: 'month', child: Text('This Month')),
                DropdownMenuItem(value: 'all', child: Text('All Time')),
                DropdownMenuItem(value: 'custom', child: Text('Custom Range')),
              ],
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
                if (value == 'custom') {
                  _showDateFilterDialog();
                } else {
                  _loadExpenses();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary() {
    return Consumer<ExpenseProvider>(
      builder: (context, expenseProvider, child) {
        final totalExpenses = expenseProvider.expenses.fold<double>(
          0.0,
          (sum, expense) => sum + expense.amount,
        );

        // Count by category
        final categoryCount = <String, int>{};
        for (var expense in expenseProvider.expenses) {
          categoryCount[expense.category] =
              (categoryCount[expense.category] ?? 0) + 1;
        }

        final mostCommonCategory = categoryCount.entries.isEmpty
            ? 'N/A'
            : categoryCount.entries
                .reduce((a, b) => a.value > b.value ? a : b)
                .key;

        return Container(
          padding: const EdgeInsets.all(20),
          color: Colors.orange[50],
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Expenses',
                  CurrencyFormatter.format(totalExpenses),
                  Icons.receipt_long,
                  AppColors.error,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'This Month',
                  CurrencyFormatter.format(
                    expenseProvider.getMonthTotal(),
                  ),
                  Icons.calendar_month,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Avg. Expense',
                  CurrencyFormatter.format(
                    expenseProvider.expenses.isEmpty
                        ? 0
                        : totalExpenses / expenseProvider.expenses.length,
                  ),
                  Icons.analytics,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Top Category',
                  mostCommonCategory,
                  Icons.category,
                  AppColors.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No expenses found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking your business expenses',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddExpenseDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add First Expense'),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesList(ExpenseProvider expenseProvider) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: expenseProvider.expenses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final expense = expenseProvider.expenses[index];
        return ExpenseCard(
          expense: expense,
          onEdit: () => _showEditExpenseDialog(expense),
          onDelete: () => _confirmDelete(expense),
        );
      },
    );
  }

  void _handleSearch(String query) {
    Provider.of<ExpenseProvider>(context, listen: false).searchExpenses(query);
  }

  void _showDateFilterDialog() async {
    final result = await showDialog<Map<String, DateTime>>(
      context: context,
      builder: (context) => DateFilterDialog(
        startDate: _customStartDate,
        endDate: _customEndDate,
      ),
    );

    if (result != null) {
      setState(() {
        _customStartDate = result['start'];
        _customEndDate = result['end'];
      });
      _loadExpenses();
    } else {
      setState(() => _selectedFilter = 'month');
      _loadExpenses();
    }
  }

  void _showAddExpenseDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const AddExpenseDialog(),
    );

    if (result == true) {
      _loadExpenses();
    }
  }

  void _showEditExpenseDialog(expense) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => EditExpenseDialog(expense: expense),
    );

    if (result == true) {
      _loadExpenses();
    }
  }

  void _confirmDelete(expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: Text(
          'Are you sure you want to delete this expense?\n\n'
          '${expense.category}: ${CurrencyFormatter.format(expense.amount)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final expenseProvider = Provider.of<ExpenseProvider>(
        context,
        listen: false,
      );

      final success = await expenseProvider.deleteExpense(expense.id!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Expense deleted successfully'
                  : 'Failed to delete expense',
            ),
            backgroundColor: success ? AppColors.success : AppColors.error,
          ),
        );
      }
    }
  }
}
