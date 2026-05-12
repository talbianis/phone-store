// lib/views/customers/customers_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/constants/app_routes.dart';
import '../../core/utils/helpers.dart';
import '../../providers/customer_provider.dart';
import '../shared/main_layout.dart';
import 'widgets/customer_card.dart';
import 'widgets/customer_list_item.dart';
import 'widgets/add_customer_dialog.dart';
import 'widgets/edit_customer_dialog.dart';
import 'customer_details_screen.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  bool _isGridView = true;
  final _searchController = TextEditingController();
  String _filterStatus = 'all'; // all, has_debt, no_debt

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CustomerProvider>(context, listen: false).loadCustomers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentRoute: AppRoutes.customers,
      child: Column(
        children: [
          // Header Section
          _buildHeader(),
          const Divider(height: 1),

          // Filters Section
          _buildFilters(),
          const Divider(height: 1),

          // Content
          Expanded(
            child: Consumer<CustomerProvider>(
              builder: (context, customerProvider, child) {
                if (customerProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (customerProvider.customers.isEmpty) {
                  return _buildEmptyState();
                }

                return _isGridView
                    ? _buildGridView(customerProvider)
                    : _buildListView(customerProvider);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.customers,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Consumer<CustomerProvider>(
                  builder: (context, provider, child) {
                    return Text(
                      l10n.customersRegistered(provider.customers.length),
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

          // Add Customer Button
          ElevatedButton.icon(
            onPressed: () => _showAddCustomerDialog(),
            icon: const Icon(
              Icons.add,
              color: AppColors.white,
            ),
            label: Text(
              l10n.addCustomer,
              style: const TextStyle(color: AppColors.white),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              backgroundColor: AppColors.sidebarBackground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final l10n = AppLocalizations.of(context);
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
                hintText: l10n.searchCustomerHint,
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

          // Debt Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _filterStatus,
              decoration: InputDecoration(
                labelText: l10n.filter,
                prefixIcon: const Icon(Icons.filter_list),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: [
                DropdownMenuItem(
                  value: 'all',
                  child: Text(l10n.allCustomers),
                ),
                DropdownMenuItem(
                  value: 'has_debt',
                  child: Text(l10n.withDebt),
                ),
                DropdownMenuItem(
                  value: 'no_debt',
                  child: Text(l10n.noDebtLabel),
                ),
              ],
              onChanged: (value) {
                setState(() => _filterStatus = value!);
                _handleFilter(value!);
              },
            ),
          ),

          const SizedBox(width: 16),

          // View Toggle
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.grid_view,
                    color: _isGridView ? AppColors.primary : Colors.grey,
                  ),
                  onPressed: () => setState(() => _isGridView = true),
                  tooltip: l10n.gridView,
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.grey[300],
                ),
                IconButton(
                  icon: Icon(
                    Icons.list,
                    color: !_isGridView ? AppColors.primary : Colors.grey,
                  ),
                  onPressed: () => setState(() => _isGridView = false),
                  tooltip: l10n.listView,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noCustomersYetTitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.addFirstCustomerHint,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddCustomerDialog(),
            icon: const Icon(Icons.add),
            label: Text(l10n.addCustomer),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(CustomerProvider customerProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: customerProvider.customers.length,
        itemBuilder: (context, index) {
          final customer = customerProvider.customers[index];
          return CustomerCard(
            customer: customer,
            onTap: () => _navigateToDetails(customer),
            onEdit: () => _showEditCustomerDialog(customer),
            onDelete: () => _deleteCustomer(customer.id!),
          );
        },
      ),
    );
  }

  Widget _buildListView(CustomerProvider customerProvider) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: customerProvider.customers.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final customer = customerProvider.customers[index];
        return CustomerListItem(
          customer: customer,
          onTap: () => _navigateToDetails(customer),
          onEdit: () => _showEditCustomerDialog(customer),
          onDelete: () => _deleteCustomer(customer.id!),
        );
      },
    );
  }

  void _handleSearch(String query) {
    Provider.of<CustomerProvider>(context, listen: false)
        .searchCustomers(query);
  }

  void _handleFilter(String filter) {
    Provider.of<CustomerProvider>(context, listen: false).filterByDebt(filter);
  }

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddCustomerDialog(),
    );
  }

  void _showEditCustomerDialog(customer) {
    showDialog(
      context: context,
      builder: (context) => EditCustomerDialog(customer: customer),
    );
  }

  void _navigateToDetails(customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerDetailsScreen(customer: customer),
      ),
    );
  }

  Future<void> _deleteCustomer(int customerId) async {
    final l10n = AppLocalizations.of(context);
    final confirm = await Helpers.showConfirmDialog(
      context,
      title: l10n.deleteCustomer,
      message: l10n.deleteCustomerMessage,
      confirmText: l10n.delete,
      cancelText: l10n.cancel,
    );

    if (confirm && context.mounted) {
      final customerProvider = Provider.of<CustomerProvider>(
        context,
        listen: false,
      );

      final success = await customerProvider.deleteCustomer(customerId);

      if (context.mounted) {
        final loc = AppLocalizations.of(context);
        if (success) {
          Helpers.showSnackBar(context, loc.customerDeleteSuccess);
        } else {
          debugPrint('deleteCustomer error: ${customerProvider.errorMessage}');
          Helpers.showSnackBar(
            context,
            loc.failedDeleteCustomer,
            isError: true,
          );
        }
      }
    }
  }
}
