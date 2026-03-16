// lib/views/dashboard/widgets/sales_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesChart extends StatelessWidget {
  final List<Map<String, dynamic>> salesData;

  const SalesChart({
    super.key,
    required this.salesData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sales Trend - Last 7 Days',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Revenue and profit overview',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '+12.5%',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Legend
          Row(
            children: [
              _buildLegend('Revenue', Colors.blue),
              const SizedBox(width: 24),
              _buildLegend('Profit', Colors.green),
            ],
          ),

          const SizedBox(height: 24),

          // Chart
          SizedBox(
            height: 300,
            child: salesData.isEmpty
                ? const Center(child: Text('No data available'))
                : LineChart(
                    _buildChartData(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  LineChartData _buildChartData() {
    // Generate sample data if empty
    final List<FlSpot> revenueSpots = [];
    final List<FlSpot> profitSpots = [];

    if (salesData.isEmpty) {
      // Sample data for demo
      final sampleRevenue = [
        70000.0,
        60000.0,
        105000.0,
        110000.0,
        95000.0,
        120000.0,
        135000.0
      ];
      final sampleProfit = [
        25000.0,
        22000.0,
        38000.0,
        40000.0,
        35000.0,
        42000.0,
        45000.0
      ];

      for (int i = 0; i < 7; i++) {
        revenueSpots.add(FlSpot(i.toDouble(), sampleRevenue[i]));
        profitSpots.add(FlSpot(i.toDouble(), sampleProfit[i]));
      }
    } else {
      // Use actual data
      for (int i = 0; i < salesData.length && i < 7; i++) {
        final sales = (salesData[i]['sales'] as num?)?.toDouble() ?? 0.0;
        final profit = (salesData[i]['profit'] as num?)?.toDouble() ?? 0.0;
        revenueSpots.add(FlSpot(i.toDouble(), sales));
        profitSpots.add(FlSpot(i.toDouble(), profit));
      }
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 35000,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey[200],
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
              if (value.toInt() >= 0 && value.toInt() < days.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    days[value.toInt()],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 35000,
            reservedSize: 50,
            getTitlesWidget: (value, meta) {
              return Text(
                '${(value / 1000).toInt()}k',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 140000,
      lineBarsData: [
        // Revenue Line
        LineChartBarData(
          spots: revenueSpots,
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.blue.withOpacity(0.1),
          ),
        ),
        // Profit Line
        LineChartBarData(
          spots: profitSpots,
          isCurved: true,
          color: Colors.green,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.green.withOpacity(0.1),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          // ignore: deprecated_member_use
          // tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final value = barSpot.y;
              return LineTooltipItem(
                '${(value / 1000).toStringAsFixed(1)}k DA',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
