// lib/views/debts/debt_details_screen.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/core/utils/date_formater.dart';
import 'package:phone_shop/data/models/debt_payement_model.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/currency_formatter.dart';

import '../../data/models/debt_model.dart';

import '../../providers/debt_provider.dart';
import 'widgets/add_debt_payment_dialog.dart';

class DebtDetailsScreen extends StatefulWidget {
  final DebtModel debt;

  const DebtDetailsScreen({
    Key? key,
    required this.debt,
  }) : super(key: key);

  @override
  State<DebtDetailsScreen> createState() => _DebtDetailsScreenState();
}

class _DebtDetailsScreenState extends State<DebtDetailsScreen> {
  late DebtModel _currentDebt;
  List<DebtPaymentModel> _payments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentDebt = widget.debt;
    _loadDebtDetails();
  }

  Future<void> _loadDebtDetails() async {
    final debtProvider = Provider.of<DebtProvider>(context, listen: false);

    // Load payment history
    await debtProvider.loadPaymentHistory(_currentDebt.id!);

    // Reload current debt info
    final updatedDebt = debtProvider.getDebtById(_currentDebt.id!);

    setState(() {
      _payments = debtProvider.paymentHistory;
      if (updatedDebt != null) {
        _currentDebt = updatedDebt;
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.debtDetails),
        actions: [
          if (_currentDebt.status != 'paid')
            IconButton(
              icon: const Icon(Icons.payment),
              onPressed: _showAddPaymentDialog,
              tooltip: l10n.addPayment,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Debt Header
                  _buildDebtHeader(),

                  const SizedBox(height: 24),

                  // Summary Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildSummaryCards(),
                  ),

                  const SizedBox(height: 24),

                  // Debt Info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildDebtInfo(),
                  ),

                  const SizedBox(height: 24),

                  // Payment History
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildPaymentHistory(),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildDebtHeader() {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.05),
        border: Border(
          bottom: BorderSide(
            color: _getStatusColor().withOpacity(0.2),
            width: 2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Customer Avatar
              CircleAvatar(
                radius: 32,
                backgroundColor: _getStatusColor().withOpacity(0.2),
                child: Icon(
                  Icons.person,
                  color: _getStatusColor(),
                  size: 32,
                ),
              ),

              const SizedBox(width: 16),

              // Customer & Invoice Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentDebt.customerName ?? l10n.unknownCustomer,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.invoiceColon(
                        _currentDebt.invoiceNumber ?? l10n.notApplicable,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${l10n.date}: ${DateFormatter.formatDate(DateTime.now())}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getStatusColor(),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _getStatusIcon(),
                      color: _getStatusColor(),
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _statusLabel(l10n),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            l10n.totalDebt,
            CurrencyFormatter.format(_currentDebt.totalAmount),
            Icons.account_balance_wallet,
            AppColors.error,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            l10n.paidAmount,
            CurrencyFormatter.format(_currentDebt.paidAmount),
            Icons.payment,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            l10n.remainingAmount,
            CurrencyFormatter.format(_currentDebt.remainingAmount),
            Icons.pending_actions,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebtInfo() {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.debtInformationSection,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(l10n.debtIdLabel, '#${_currentDebt.id}'),
          const Divider(height: 24),
          _buildInfoRow(
            l10n.customerLabelDetail,
            _currentDebt.customerName ?? l10n.unknownCustomer,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            l10n.invoiceNumberLabel,
            _currentDebt.invoiceNumber ?? l10n.notApplicable,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            l10n.createdDateLabel,
            DateFormatter.formatDateTime(_currentDebt.debtDate),
          ),
          const Divider(height: 24),
          _buildInfoRow(l10n.statusField, _statusLabel(l10n)),
          const Divider(height: 24),
          _buildInfoRow(
            l10n.paymentsMadeLabel,
            '${_payments.length}',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentHistory() {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.history, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  l10n.paymentHistory,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_currentDebt.status != 'paid')
                  ElevatedButton.icon(
                    onPressed: _showAddPaymentDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l10n.addPayment),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                  ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Payments List
          if (_payments.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.payment_outlined,
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noPaymentsYetDebt,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _payments.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final payment = _payments[index];
                return _buildPaymentItem(payment, index);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem(DebtPaymentModel payment, int index) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Payment Number
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Payment Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormatter.formatDateTime(payment.paymentDate),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                // Row(
                //   children: [
                //     Icon(
                //       _getPaymentMethodIcon(payment.paymentMethod ?? 'unknown'),
                //       size: 14,
                //       color: Colors.grey[600],
                //     ),
                //     const SizedBox(width: 4),
                //     Text(
                //       _getPaymentMethodLabel(payment.paymentMethod),
                //       style: TextStyle(
                //         fontSize: 13,
                //         color: Colors.grey[600],
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),

          // Amount
          Text(
            CurrencyFormatter.format(payment.amount),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (_currentDebt.status) {
      case 'paid':
        return AppColors.success;
      case 'partial':
        return Colors.orange;
      case 'unpaid':
      default:
        return AppColors.error;
    }
  }

  IconData _getStatusIcon() {
    switch (_currentDebt.status) {
      case 'paid':
        return Icons.check_circle;
      case 'partial':
        return Icons.pending;
      case 'unpaid':
      default:
        return Icons.warning_amber;
    }
  }

  String _statusLabel(AppLocalizations l10n) {
    switch (_currentDebt.status) {
      case 'paid':
        return l10n.paid;
      case 'partial':
        return l10n.partial;
      case 'unpaid':
      default:
        return l10n.unpaid;
    }
  }

  // IconData _getPaymentMethodIcon(String method) {
  //   switch (method.toLowerCase()) {
  //     case 'cash':
  //       return Icons.money;
  //     case 'card':
  //       return Icons.credit_card;
  //     default:
  //       return Icons.payment;
  //   }
  // }

  // String _getPaymentMethodLabel(String method) {
  //   switch (method.toLowerCase()) {
  //     case 'cash':
  //       return 'Cash';
  //     case 'card':
  //       return 'Card';
  //     default:
  //       return method;
  //   }
  // }

  void _showAddPaymentDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AddDebtPaymentDialog(debt: _currentDebt),
    );

    if (result == true) {
      // Reload debt details after payment
      _loadDebtDetails();
    }
  }
}
