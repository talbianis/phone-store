// lib/views/sales/sale_details_screen.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/core/constants/app_colors.dart';
import 'package:phone_shop/core/localization/app_localizations.dart';
import 'package:phone_shop/core/utils/currency_formatter.dart';
import 'package:phone_shop/core/utils/date_formater.dart';
import 'package:phone_shop/data/models/sales_item_model.dart';
import 'package:phone_shop/data/models/sales_model.dart';
import 'package:phone_shop/providers/sale_provider.dart';
import 'package:provider/provider.dart';

class SaleDetailsScreen extends StatefulWidget {
  final SaleModel sale;

  const SaleDetailsScreen({
    Key? key,
    required this.sale,
  }) : super(key: key);

  @override
  State<SaleDetailsScreen> createState() => _SaleDetailsScreenState();
}

class _SaleDetailsScreenState extends State<SaleDetailsScreen> {
  List<SaleItemModel> _saleItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSaleItems();
  }

  Future<void> _loadSaleItems() async {
    final saleProvider = Provider.of<SaleProvider>(context, listen: false);
    await saleProvider.loadSaleItems(widget.sale.id!);

    setState(() {
      _saleItems = saleProvider.currentSaleItems;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColors.sidebarBackground,
        title: Text(
          l10n.saleDetails,
          style: const TextStyle(color: AppColors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.print,
              color: AppColors.white,
            ),
            onPressed: _handlePrint,
            tooltip: l10n.printInvoiceTooltip,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Invoice Header
                  _buildInvoiceHeader(),

                  const SizedBox(height: 24),

                  // Sale Info Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildInfoCards(),
                  ),

                  const SizedBox(height: 24),

                  // Items Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildItemsSection(),
                  ),

                  const SizedBox(height: 24),

                  // Payment Details
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildPaymentDetails(),
                  ),

                  const SizedBox(height: 24),

                  // Sale Summary
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildSaleSummary(),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildInvoiceHeader() {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.primary.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Invoice Number
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.invoiceHeading,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.sale.invoiceNumber,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              // Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    l10n.date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormatter.formatDateTime(widget.sale.saleDate),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Customer Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.person, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.customerSectionLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.sale.customerName ?? l10n.walkInCustomer,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            l10n.totalAmountLabel,
            CurrencyFormatter.format(widget.sale.total),
            Icons.attach_money,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            l10n.profit,
            CurrencyFormatter.format(widget.sale.profit),
            Icons.trending_up,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            l10n.items,
            '${_saleItems.length}',
            Icons.shopping_cart,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
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

  Widget _buildItemsSection() {
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
                const Icon(Icons.receipt_long, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  l10n.saleItemsTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    l10n.itemsCountShortLabel(_saleItems.length),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Items Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: Colors.grey[50],
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    l10n.tableProduct,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    l10n.tablePrice,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    l10n.tableQtyShort,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    l10n.total,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _saleItems.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = _saleItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    // Product Name
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context).cartItemProfitFormatted(
                                CurrencyFormatter.format(item.profit)),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Unit Price
                    Expanded(
                      child: Text(
                        CurrencyFormatter.format(item.unitPrice),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),

                    // Quantity
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${item.quantity}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // Total Price
                    Expanded(
                      child: Text(
                        CurrencyFormatter.format(item.totalPrice),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
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
            l10n.paymentDetailsTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(l10n.paymentMethod, _getPaymentMethodLabel(l10n)),
          const Divider(height: 24),
          _buildDetailRow(
            l10n.amountPaid,
            CurrencyFormatter.format(widget.sale.paidAmount),
          ),
          if (widget.sale.remainingDebt > 0) ...[
            const Divider(height: 24),
            _buildDetailRow(
              l10n.remainingDebt,
              CurrencyFormatter.format(widget.sale.remainingDebt),
              valueColor: AppColors.error,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSaleSummary() {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.saleSummaryTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(l10n.subtotal, widget.sale.subtotal),
          const SizedBox(height: 12),
          if (widget.sale.discount > 0) ...[
            _buildSummaryRow(
              l10n.discount,
              -widget.sale.discount,
              valueColor: AppColors.error,
            ),
            const SizedBox(height: 12),
          ],
          const Divider(height: 24),
          _buildSummaryRow(
            l10n.total,
            widget.sale.total,
            isBold: true,
            fontSize: 20,
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            l10n.profit,
            widget.sale.profit,
            valueColor: AppColors.success,
            fontSize: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
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
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    double value, {
    bool isBold = false,
    Color? valueColor,
    double fontSize = 14,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          CurrencyFormatter.format(value),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  String _getPaymentMethodLabel(AppLocalizations l10n) {
    switch (widget.sale.paymentMethod.toLowerCase()) {
      case 'cash':
        return l10n.cash;
      case 'card':
        return l10n.card;
      case 'debt':
        return l10n.paymentOnCreditShort;
      case 'mixed':
        return l10n.paymentMixedShort;
      default:
        return widget.sale.paymentMethod;
    }
  }

  void _handlePrint() {
    // TODO: Implement print functionality
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.printComingSoon),
      ),
    );
  }
}
