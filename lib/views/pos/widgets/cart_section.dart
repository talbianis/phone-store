// lib/views/pos/widgets/cart_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_shop/views/pos/widgets/cart_item_widget.dart';
import 'package:phone_shop/views/pos/widgets/discount_dialog.dart';
import 'package:phone_shop/views/pos/widgets/payment_dialogue.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/customer_provider.dart';

class CartSection extends StatelessWidget {
  final VoidCallback onCheckout;

  const CartSection({
    Key? key,
    required this.onCheckout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Cart Header
          _buildCartHeader(context),
          const Divider(height: 1),

          // Cart Items List
          Expanded(
            child: _buildCartItems(context),
          ),

          // Cart Summary & Actions
          _buildCartSummary(context),
        ],
      ),
    );
  }

  Widget _buildCartHeader(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.shopping_cart, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Cart (${cartProvider.itemCount} items)',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartItems(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        if (cartProvider.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 60.sp,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 16.h),
                Text(
                  'Cart is empty',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Add products to get started',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: cartProvider.items.length,
          separatorBuilder: (context, index) => const Divider(height: 16),
          itemBuilder: (context, index) {
            final cartItem = cartProvider.items[index];
            return CartItemWidget(cartItem: cartItem);
          },
        );
      },
    );
  }

  Widget _buildCartSummary(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(
              top: BorderSide(color: Colors.grey[200]!),
            ),
          ),
          child: Column(
            children: [
              // Customer Selection
              _buildCustomerSelector(context, cartProvider),

              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Subtotal
              _buildSummaryRow(
                'Subtotal',
                CurrencyFormatter.format(cartProvider.subtotal),
                isBold: false,
              ),

              const SizedBox(height: 12),

              // Discount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Discount',
                    style: TextStyle(fontSize: 14),
                  ),
                  Row(
                    children: [
                      if (cartProvider.discount > 0)
                        Text(
                          '-${CurrencyFormatter.format(cartProvider.discount)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.error,
                          ),
                        ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: cartProvider.isEmpty
                            ? null
                            : () => _showDiscountDialog(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          minimumSize: const Size(0, 0),
                        ),
                        child: Text(
                          cartProvider.discount > 0 ? 'Edit' : 'Add',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Total
              _buildSummaryRow(
                'Total',
                CurrencyFormatter.format(cartProvider.total),
                isBold: true,
                valueColor: AppColors.primary,
                fontSize: 20,
              ),

              const SizedBox(height: 8),

              // Profit
              _buildSummaryRow(
                'Profit',
                CurrencyFormatter.format(cartProvider.totalProfit),
                isBold: false,
                valueColor: AppColors.success,
                fontSize: 14,
              ),

              const SizedBox(height: 20),

              // Checkout Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: cartProvider.isEmpty
                      ? null
                      : () => _showPaymentDialog(context),
                  icon: const Icon(Icons.payment),
                  label: const Text(
                    'Complete Sale',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomerSelector(
      BuildContext context, CartProvider cartProvider) {
    return Consumer<CustomerProvider>(
      builder: (context, customerProvider, child) {
        return InkWell(
          onTap: () => _showCustomerDialog(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        cartProvider.selectedCustomer?.name ??
                            'Walk-in Customer',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
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
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  void _showDiscountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const DiscountDialog(),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PaymentDialog(),
    );
  }

  void _showCustomerDialog(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Customer'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Walk-in customer option
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Walk-in Customer'),
                subtitle: const Text('No customer record'),
                trailing: cartProvider.selectedCustomer == null
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  cartProvider.selectCustomer(null);
                  Navigator.pop(context);
                },
              ),
              const Divider(),

              // Customer list
              SizedBox(
                height: 300,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: customerProvider.customers.length,
                  itemBuilder: (context, index) {
                    final customer = customerProvider.customers[index];
                    final isSelected =
                        cartProvider.selectedCustomer?.id == customer.id;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          customer.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(customer.name),
                      subtitle: Text(customer.phone),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: AppColors.primary)
                          : null,
                      onTap: () {
                        cartProvider.selectCustomer(customer);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
