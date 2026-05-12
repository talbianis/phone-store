// lib/views/debts/debts_screen.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/views/debts/debt_details_screen.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/constants/app_routes.dart';
import '../../core/utils/currency_formatter.dart';

import '../../providers/debt_provider.dart';
import '../shared/main_layout.dart';
import 'widgets/debt_card.dart';
import 'widgets/add_debt_payment_dialog.dart';

class DebtsScreen extends StatefulWidget {
  const DebtsScreen({Key? key}) : super(key: key);

  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen> {
  final _searchController = TextEditingController();
  String _selectedStatus = 'all'; // all, unpaid, partial, paid

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DebtProvider>(context, listen: false).loadDebts();
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
      currentRoute: AppRoutes.debts,
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

          // Debts List
          Expanded(
            child: Consumer<DebtProvider>(
              builder: (context, debtProvider, child) {
                if (debtProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (debtProvider.debts.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildDebtsList(debtProvider);
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
                  l10n.debtsManagement,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Consumer<DebtProvider>(
                  builder: (context, provider, child) {
                    return Text(
                      l10n.debtsTrackedCount(provider.debts.length),
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
                hintText: l10n.debtsSearchHint,
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

          // Status Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: l10n.debtStatus,
                prefixIcon: const Icon(Icons.filter_list),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(l10n.allDebtsFilter)),
                DropdownMenuItem(value: 'unpaid', child: Text(l10n.unpaid)),
                DropdownMenuItem(value: 'partial', child: Text(l10n.partial)),
                DropdownMenuItem(value: 'paid', child: Text(l10n.paid)),
              ],
              onChanged: (value) {
                setState(() => _selectedStatus = value!);
                _handleStatusFilter(value!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary() {
    return Consumer<DebtProvider>(
      builder: (context, debtProvider, child) {
        final l10n = AppLocalizations.of(context);
        final totalDebt = debtProvider.debts.fold<double>(
          0.0,
          (sum, debt) => sum + debt.totalAmount,
        );
        final totalPaid = debtProvider.debts.fold<double>(
          0.0,
          (sum, debt) => sum + debt.paidAmount,
        );
        final totalRemaining = totalDebt - totalPaid;

        final unpaidCount =
            debtProvider.debts.where((d) => d.status == 'unpaid').length;

        return Container(
          padding: const EdgeInsets.all(20),
          color: Colors.red[50],
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  l10n.totalDebt,
                  CurrencyFormatter.format(totalDebt),
                  Icons.account_balance_wallet,
                  AppColors.error,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  l10n.paidAmount,
                  CurrencyFormatter.format(totalPaid),
                  Icons.payment,
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  l10n.remainingAmount,
                  CurrencyFormatter.format(totalRemaining),
                  Icons.pending_actions,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  l10n.unpaid,
                  '$unpaidCount',
                  Icons.warning_amber,
                  AppColors.error,
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
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noDebts,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyStateMessage(l10n),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  String _getEmptyStateMessage(AppLocalizations l10n) {
    switch (_selectedStatus) {
      case 'unpaid':
        return l10n.noUnpaidDebts;
      case 'partial':
        return l10n.noPartialDebts;
      case 'paid':
        return l10n.noPaidDebts;
      default:
        return l10n.debtsEmptyHint;
    }
  }

  Widget _buildDebtsList(DebtProvider debtProvider) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: debtProvider.debts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final debt = debtProvider.debts[index];
        return DebtCard(
          debt: debt,
          onTap: () => _navigateToDetails(debt),
          onAddPayment: () => _showAddPaymentDialog(debt),
        );
      },
    );
  }

  void _handleSearch(String query) {
    Provider.of<DebtProvider>(context, listen: false).searchDebts(query);
  }

  void _handleStatusFilter(String status) {
    Provider.of<DebtProvider>(context, listen: false).filterByStatus(status);
  }

  void _showAddPaymentDialog(debt) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AddDebtPaymentDialog(debt: debt),
    );

    if (result == true) {
      // Reload debts after payment
      if (mounted) {
        Provider.of<DebtProvider>(context, listen: false).loadDebts();
      }
    }
  }

  void _navigateToDetails(debt) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DebtDetailsScreen(debt: debt),
      ),
    );
  }
}
