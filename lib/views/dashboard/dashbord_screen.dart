// lib/views/dashboard/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/providers/dashborad_provider.dart';
import 'package:phone_shop/views/dashboard/widgets/best_selling_product.dart';
import 'package:phone_shop/views/dashboard/widgets/sales_chart.dart';
import 'package:phone_shop/views/dashboard/widgets/stat_card.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_routes.dart';
import '../../core/layout/desktop_adaptive.dart';
import '../../core/localization/app_localizations.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false)
          .loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context); // ✅ get translations

    return MainLayout(
      currentRoute: AppRoutes.dashboard,
      child: Consumer<DashboardProvider>(
        builder: (context, dashboardProvider, child) {
          if (dashboardProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final contentW = constraints.maxWidth;
              final gap = 16.0;
              final cols = desktopStatColumns(contentW);
              final tileW =
                  cols > 1 ? (contentW - gap * (cols - 1)) / cols : contentW;

              final statTiles = <Widget>[
                StatCard(
                  title: l10n.todaySales,
                  value: dashboardProvider.todaySales,
                  unit: l10n.currency,
                  change: '+12.5%',
                  isPositive: true,
                  subtitle: l10n.vsYesterday,
                  color: Colors.green,
                  icon: Icons.trending_up,
                ),
                StatCard(
                  title: l10n.todayProfit,
                  value: dashboardProvider.todayProfit,
                  unit: l10n.currency,
                  change: '+8.2%',
                  isPositive: true,
                  subtitle: l10n.vsYesterday,
                  color: Colors.blue,
                  icon: Icons.attach_money,
                ),
                StatCard(
                  title: l10n.lowStockAlerts,
                  value: dashboardProvider.lowStockCount.toDouble(),
                  unit: l10n.products,
                  change: '+3',
                  isPositive: false,
                  subtitle: l10n.vsYesterday,
                  color: Colors.orange,
                  icon: Icons.warning_amber,
                ),
                StatCard(
                  title: l10n.totalProducts,
                  value: dashboardProvider.totalProducts.toDouble(),
                  unit: l10n.items,
                  change: '+24',
                  isPositive: true,
                  subtitle: l10n.vsYesterday,
                  color: Colors.purple,
                  icon: Icons.inventory_2,
                ),
              ];

              final chartBlock = desktopShouldStackDashboardCharts(contentW)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SalesChart(
                          salesData: dashboardProvider.last7DaysSales,
                        ),
                        SizedBox(height: gap + 8),
                        const BestSellingProducts(),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: SalesChart(
                            salesData: dashboardProvider.last7DaysSales,
                          ),
                        ),
                        SizedBox(width: gap + 8),
                        const Expanded(
                          flex: 1,
                          child: BestSellingProducts(),
                        ),
                      ],
                    );

              return SingleChildScrollView(
                padding: desktopPagePadding(context),
                child: desktopConstrainContent(
                  context,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dashboard,
                        style: TextStyle(
                          fontSize: desktopPageTitleFontSize(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: desktopViewportHeight(context) * 0.005),
                      Text(
                        l10n.dashboardSubtitle,
                        style: TextStyle(
                          fontSize: desktopPageSubtitleFontSize(context),
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: desktopViewportHeight(context) * 0.028),
                      Row(
                        children: [
                          for (int i = 0; i < statTiles.length; i++) ...[
                            Expanded(child: statTiles[i]),
                            if (i < statTiles.length - 1) SizedBox(width: gap),
                          ],
                        ],
                      ),
                      SizedBox(height: desktopViewportHeight(context) * 0.022),
                      chartBlock,
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
