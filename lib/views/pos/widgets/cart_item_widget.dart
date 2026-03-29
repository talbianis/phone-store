// lib/views/pos/widgets/cart_item_widget.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;

  const CartItemWidget({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          // Product Info Row
          Row(
            children: [
              // Product Image
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: cartItem.product.imagePath != null &&
                          cartItem.product.imagePath!.isNotEmpty
                      ? Image.file(
                          File(cartItem.product.imagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder();
                          },
                        )
                      : _buildPlaceholder(),
                ),
              ),

              const SizedBox(width: 12),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.product.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      CurrencyFormatter.format(cartItem.product.sellingPrice),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Remove Button
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                color: Colors.red,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false)
                      .removeProduct(cartItem.product.id!);
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Quantity Controls and Total
          Row(
            children: [
              // Quantity Controls
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    // Decrease Button
                    InkWell(
                      onTap: () {
                        if (cartItem.quantity > 1) {
                          Provider.of<CartProvider>(context, listen: false)
                              .updateQuantity(
                            cartItem.product.id!,
                            cartItem.quantity - 1,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.remove, size: 16),
                      ),
                    ),

                    // Quantity Input
                    Container(
                      width: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        controller: TextEditingController(
                          text: cartItem.quantity.toString(),
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        onSubmitted: (value) {
                          final newQuantity = int.tryParse(value) ?? 1;
                          if (newQuantity > 0 &&
                              newQuantity <= cartItem.product.quantity) {
                            Provider.of<CartProvider>(context, listen: false)
                                .updateQuantity(
                              cartItem.product.id!,
                              newQuantity,
                            );
                          } else if (newQuantity > cartItem.product.quantity) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Only ${cartItem.product.quantity} available in stock',
                                ),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                      ),
                    ),

                    // Increase Button
                    InkWell(
                      onTap: () {
                        if (cartItem.quantity < cartItem.product.quantity) {
                          Provider.of<CartProvider>(context, listen: false)
                              .updateQuantity(
                            cartItem.product.id!,
                            cartItem.quantity + 1,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Only ${cartItem.product.quantity} available in stock',
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.add, size: 16),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Stock Info
              Text(
                'of ${cartItem.product.quantity}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),

              const Spacer(),

              // Item Total
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.format(cartItem.totalPrice),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    'Profit: ${CurrencyFormatter.format(cartItem.totalProfit)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 24,
        color: Colors.grey[400],
      ),
    );
  }
}
