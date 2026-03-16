// lib/views/dashboard/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/providers/dashborad_provider.dart';
import 'package:phone_shop/views/dashboard/widgets/best_selling_product.dart';
import 'package:phone_shop/views/dashboard/widgets/sales_chart.dart';
import 'package:phone_shop/views/dashboard/widgets/stat_card.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_routes.dart';

import '../shared/main_layout.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false)
          .loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentRoute: AppRoutes.dashboard,
      child: Consumer<DashboardProvider>(
        builder: (context, dashboardProvider, child) {
          if (dashboardProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Header
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Overview of your phone shop performance',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 32),

                // Stat Cards Row
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: "Today's Sales",
                        value: dashboardProvider.todaySales,
                        unit: 'DA',
                        change: '+12.5%',
                        isPositive: true,
                        subtitle: 'vs yesterday',
                        color: Colors.green,
                        icon: Icons.trending_up,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: "Today's Profit",
                        value: dashboardProvider.todayProfit,
                        unit: 'DA',
                        change: '+8.2%',
                        isPositive: true,
                        subtitle: 'vs yesterday',
                        color: Colors.blue,
                        icon: Icons.attach_money,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: "Low Stock Items",
                        value: dashboardProvider.lowStockCount.toDouble(),
                        unit: 'Products',
                        change: '+3',
                        isPositive: false,
                        subtitle: 'vs yesterday',
                        color: Colors.orange,
                        icon: Icons.warning_amber,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: "Total Products",
                        value: dashboardProvider.totalProducts.toDouble(),
                        unit: 'Items',
                        change: '+24',
                        isPositive: true,
                        subtitle: 'vs yesterday',
                        color: Colors.purple,
                        icon: Icons.inventory_2,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Charts Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sales Chart
                    Expanded(
                      flex: 2,
                      child: SalesChart(
                        salesData: dashboardProvider.last7DaysSales,
                      ),
                    ),

                    const SizedBox(width: 24),

                    // Best Selling Products
                    const Expanded(
                      flex: 1,
                      child: BestSellingProducts(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
