// lib/views/sales/sales_screen.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/views/sales/widgets/sale_details_screen.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/utils/currency_formatter.dart';

import '../../providers/sale_provider.dart';
import '../shared/main_layout.dart';
import 'widgets/sale_list_item.dart';
import 'widgets/date_filter_dialog.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'today'; // today, week, month, all, custom
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSales();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadSales() {
    final saleProvider = Provider.of<SaleProvider>(context, listen: false);

    switch (_selectedFilter) {
      case 'today':
        saleProvider.loadTodaySales();
        break;
      case 'week':
        final now = DateTime.now();
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        saleProvider.filterByDate(weekStart, weekEnd);
        break;
      case 'month':
        final now = DateTime.now();
        final monthStart = DateTime(now.year, now.month, 1);
        final monthEnd = DateTime(now.year, now.month + 1, 0);
        saleProvider.filterByDate(monthStart, monthEnd);
        break;
      case 'custom':
        if (_customStartDate != null && _customEndDate != null) {
          saleProvider.filterByDate(_customStartDate!, _customEndDate!);
        }
        break;
      case 'all':
      default:
        saleProvider.loadSales();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentRoute: AppRoutes.sales,
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

          // Sales List
          Expanded(
            child: Consumer<SaleProvider>(
              builder: (context, saleProvider, child) {
                if (saleProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (saleProvider.sales.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildSalesList(saleProvider);
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
                  'Sales History',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Consumer<SaleProvider>(
                  builder: (context, provider, child) {
                    return Text(
                      '${provider.sales.length} sales recorded',
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
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.white,
      child: Row(
        children: [
          // Search Bar
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by invoice number or customer...',
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
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelText: 'Period',
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.textPrimary),
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
                  _loadSales();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary() {
    return Consumer<SaleProvider>(
      builder: (context, saleProvider, child) {
        final totalSales = saleProvider.sales.fold<double>(
          0.0,
          (sum, sale) => sum + sale.total,
        );
        final totalProfit = saleProvider.sales.fold<double>(
          0.0,
          (sum, sale) => sum + sale.profit,
        );

        return Container(
          padding: const EdgeInsets.all(20),
          color: AppColors.primary.withOpacity(0.05),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Sales',
                  CurrencyFormatter.format(totalSales),
                  Icons.attach_money,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Total Profit',
                  CurrencyFormatter.format(totalProfit),
                  Icons.trending_up,
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Transactions',
                  '${saleProvider.sales.length}',
                  Icons.receipt,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Avg. Sale',
                  CurrencyFormatter.format(
                    saleProvider.sales.isEmpty
                        ? 0
                        : totalSales / saleProvider.sales.length,
                  ),
                  Icons.show_chart,
                  Colors.blue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
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
            'No sales found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyStateMessage(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sidebarBackground,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.pos);
            },
            icon: const Icon(
              Icons.point_of_sale,
              color: AppColors.white,
            ),
            label: const Text(
              'Go to POS',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _getEmptyStateMessage() {
    switch (_selectedFilter) {
      case 'today':
        return 'No sales recorded today';
      case 'week':
        return 'No sales this week';
      case 'month':
        return 'No sales this month';
      case 'custom':
        return 'No sales in selected date range';
      default:
        return 'Start making sales to see them here';
    }
  }

  Widget _buildSalesList(SaleProvider saleProvider) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: saleProvider.sales.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final sale = saleProvider.sales[index];
        return SaleListItem(
          sale: sale,
          onTap: () => _navigateToDetails(sale),
        );
      },
    );
  }

  void _handleSearch(String query) {
    Provider.of<SaleProvider>(context, listen: false).searchSales(query);
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
      _loadSales();
    } else {
      // User cancelled, revert to previous filter
      setState(() => _selectedFilter = 'today');
      _loadSales();
    }
  }

  void _navigateToDetails(sale) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SaleDetailsScreen(sale: sale),
      ),
    );
  }
}
