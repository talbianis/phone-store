// lib/views/categories/widgets/category_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/category_model.dart';
import '../../../providers/product_provider.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        // Count products in this category
        final productCount = productProvider.products
            .where((p) => p.categoryId == category.id)
            .length;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r), // ⬅️ Responsive
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4.r, // ⬅️ Responsive
                offset: Offset(0, 2.h), // ⬅️ Responsive
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r), // ⬅️ Responsive
              onTap: () {
                // TODO: Navigate to products filtered by this category
              },
              child: Padding(
                padding: EdgeInsets.all(28.w), // ⬅️ Responsive
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with actions
                    Row(
                      children: [
                        // Icon
                        Container(
                          width: 40.w, // ⬅️ Already responsive
                          height: 40.h, // ⬅️ Already responsive
                          decoration: BoxDecoration(
                            color: _getCategoryColor().withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(12.r), // ⬅️ Responsive
                          ),
                          child: Icon(
                            _getCategoryIcon(),
                            color: _getCategoryColor(),
                            size: 24.sp, // ⬅️ Responsive
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        // Actions Menu
                        PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.grey[600],
                            size: 20.sp, // ⬅️ Responsive
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12.r), // ⬅️ Responsive
                          ),
                          onSelected: (value) {
                            if (value == 'edit') {
                              onEdit();
                            } else if (value == 'delete') {
                              onDelete();
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit,
                                      size: 20.sp), // ⬅️ Responsive
                                  SizedBox(width: 12.w), // ⬅️ Responsive
                                  Text(
                                    'Edit',
                                    style: TextStyle(
                                        fontSize: 14.sp), // ⬅️ Responsive
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    size: 20.sp, // ⬅️ Responsive
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 12.w), // ⬅️ Responsive
                                  Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14.sp, // ⬅️ Responsive
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h), // ⬅️ Already responsive

                    // Category Name
                    Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 22.sp, // ⬅️ Responsive
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (category.description != null) ...[
                      SizedBox(height: 4.h), // ⬅️ Already responsive
                      Text(
                        category.description!,
                        style: TextStyle(
                          fontSize: 13.sp, // ⬅️ Responsive
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const Spacer(),

                    // Product Count
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w, // ⬅️ Already responsive
                        vertical: 7.h, // ⬅️ Already responsive
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor().withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(6.r), // ⬅️ Responsive
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 22
                                .sp, // ⬅️ Changed from 20.sp to 16.sp (smaller)
                            color: _getCategoryColor(),
                          ),
                          SizedBox(
                              width: 10
                                  .w), // ⬅️ Changed from 10.w to 6.w (smaller)
                          Text(
                            '$productCount Products',
                            style: TextStyle(
                              fontSize: 16
                                  .sp, // ⬅️ Changed from 16.sp to 13.sp (smaller)
                              fontWeight: FontWeight.w600,
                              color: _getCategoryColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getCategoryColor() {
    // Assign colors based on category name
    final colors = {
      'smartphones': Colors.blue,
      'chargers': Colors.green,
      'headphones': Colors.purple,
      'phone cases': Colors.orange,
      'screen protectors': Colors.teal,
      'cables': Colors.indigo,
      'power banks': Colors.pink,
      'accessories': Colors.amber,
    };

    final key = category.name.toLowerCase();
    return colors[key] ?? AppColors.primary;
  }

  IconData _getCategoryIcon() {
    // Assign icons based on category name
    final icons = {
      'smartphones': Icons.phone_android,
      'chargers': Icons.battery_charging_full,
      'headphones': Icons.headphones,
      'phone cases': Icons.phone_iphone,
      'screen protectors': Icons.shield,
      'cables': Icons.cable,
      'power banks': Icons.battery_full,
      'accessories': Icons.devices_other,
    };

    final key = category.name.toLowerCase();
    return icons[key] ?? Icons.category;
  }
}
