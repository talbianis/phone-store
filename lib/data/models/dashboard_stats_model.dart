// lib/data/models/dashboard_stats_model.dart

class DashboardStatsModel {
  final double todaySales;
  final double todayProfit;
  final int todaySalesCount;
  final int lowStockCount;
  final int outOfStockCount;
  final int totalProducts;
  final int totalCustomers;
  final double totalDebt;

  final double monthlySales;
  final double monthlyProfit;
  final double monthlyExpenses;
  final double netProfit;

  final List<DailySalesData> last7DaysSales;
  final List<TopProductData> topProducts;

  DashboardStatsModel({
    required this.todaySales,
    required this.todayProfit,
    required this.todaySalesCount,
    required this.lowStockCount,
    required this.outOfStockCount,
    required this.totalProducts,
    required this.totalCustomers,
    required this.totalDebt,
    required this.monthlySales,
    required this.monthlyProfit,
    required this.monthlyExpenses,
    required this.netProfit,
    required this.last7DaysSales,
    required this.topProducts,
  });

  // Calculate profit margin for today
  double get todayProfitMargin =>
      todaySales > 0 ? (todayProfit / todaySales) * 100 : 0;

  // Calculate monthly profit margin
  double get monthlyProfitMargin =>
      monthlySales > 0 ? (monthlyProfit / monthlySales) * 100 : 0;
}

// Helper class for daily sales chart data
class DailySalesData {
  final DateTime date;
  final double sales;
  final double profit;

  DailySalesData({
    required this.date,
    required this.sales,
    required this.profit,
  });
}

// Helper class for top products
class TopProductData {
  final int productId;
  final String productName;
  final int quantitySold;
  final double revenue;
  final String? imagePath;

  TopProductData({
    required this.productId,
    required this.productName,
    required this.quantitySold,
    required this.revenue,
    this.imagePath,
  });
}
