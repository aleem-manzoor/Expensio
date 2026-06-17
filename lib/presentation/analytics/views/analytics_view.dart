import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/shared_widgets/my_text.dart';
import '../bindings/analytics_binding.dart';
import '../controllers/analytics_controller.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnalyticsController>(
      init: AnalyticsController(),
      initState: (_) => AnalyticsBinding().dependencies(),
      builder: (controller) => Obx(
        () => Scaffold(
          backgroundColor: AppColors.lightWhite,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title: MyText(title: 'Analytics', size: 16, weight: FontWeight.w700, clr: AppColors.black),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              GestureDetector(
                onTap: controller.loadAnalytics,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.refresh, color: AppColors.primary),
                ),
              ),
            ],
          ),
          body: controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async => controller.loadAnalytics(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryRow(controller),
                        const SizedBox(height: 20),
                        _buildSectionHeader('Monthly Trend'),
                        const SizedBox(height: 12),
                        _buildLineChart(controller),
                        const SizedBox(height: 20),
                        _buildSectionHeader('This Month by Category'),
                        const SizedBox(height: 12),
                        if (controller.categoryTotals.isEmpty)
                          _buildEmpty('No expenses this month')
                        else ...[
                          _buildPieChart(controller),
                          const SizedBox(height: 16),
                          _buildCategoryList(controller),
                        ],
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(AnalyticsController c) {
    return Row(
      children: [
        _summaryBox('Income', 'Rs ${c.totalIncomes.value.toStringAsFixed(0)}', const Color(0xFF22C55E)),
        const SizedBox(width: 10),
        _summaryBox('Expenses', 'Rs ${c.totalExpenses.value.toStringAsFixed(0)}', AppColors.red),
        const SizedBox(width: 10),
        _summaryBox('Savings', 'Rs ${c.totalSavings.value.toStringAsFixed(0)}',
            c.totalSavings.value >= 0 ? AppColors.primary : AppColors.red),
      ],
    );
  }

  Widget _summaryBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.05), blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(title: label, size: 10, weight: FontWeight.w500, clr: AppColors.greyText),
            const SizedBox(height: 4),
            MyText(title: value, size: 12, weight: FontWeight.w700, clr: color),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return MyText(title: title, size: 15, weight: FontWeight.w700, clr: AppColors.black);
  }

  Widget _buildLineChart(AnalyticsController c) {
    if (c.monthlyExpenses.isEmpty) return _buildEmpty('No data yet');

    final spots = <FlSpot>[];
    final incomeSpots = <FlSpot>[];
    for (int i = 0; i < c.monthlyExpenses.length; i++) {
      spots.add(FlSpot(i.toDouble(), c.monthlyExpenses[i]));
      incomeSpots.add(FlSpot(i.toDouble(), c.monthlyIncomes[i]));
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.05), blurRadius: 6)],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _chartInterval(c),
            getDrawingHorizontalLine: (_) => FlLine(color: AppColors.inputBorder, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (v, _) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= c.monthLabels.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(c.monthLabels[idx], style: const TextStyle(fontSize: 10, color: AppColors.greyText)),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (v, _) => Text(
                  _compact(v),
                  style: const TextStyle(fontSize: 9, color: AppColors.greyText),
                ),
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: incomeSpots,
              isCurved: true,
              color: const Color(0xFF22C55E),
              barWidth: 2.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF22C55E).withValues(alpha: 0.07),
              ),
            ),
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.primary,
              barWidth: 2.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withValues(alpha: 0.07),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _chartInterval(AnalyticsController c) {
    final maxVal = [...c.monthlyExpenses, ...c.monthlyIncomes]
        .fold<double>(0, (a, b) => b > a ? b : a);
    if (maxVal == 0) return 1000;
    return (maxVal / 4).ceilToDouble();
  }

  String _compact(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}k';
    return v.toStringAsFixed(0);
  }

  Widget _buildPieChart(AnalyticsController c) {
    final entries = c.sortedCategories;
    final total = entries.fold<double>(0, (a, e) => a + e.value);
    if (total == 0) return const SizedBox.shrink();

    final colors = [
      AppColors.primary,
      AppColors.red,
      const Color(0xFF22C55E),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
      const Color(0xFF06B6D4),
      const Color(0xFFEC4899),
      const Color(0xFF10B981),
      const Color(0xFFF97316),
      const Color(0xFF6366F1),
    ];

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 50,
          sections: entries.asMap().entries.map((entry) {
            final idx = entry.key;
            final e = entry.value;
            final pct = (e.value / total * 100).toStringAsFixed(1);
            return PieChartSectionData(
              color: colors[idx % colors.length],
              value: e.value,
              title: '$pct%',
              radius: 50,
              titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryList(AnalyticsController c) {
    final entries = c.sortedCategories;
    final total = entries.fold<double>(0, (a, e) => a + e.value);
    final colors = [
      AppColors.primary, AppColors.red, const Color(0xFF22C55E),
      const Color(0xFFF59E0B), const Color(0xFF8B5CF6),
      const Color(0xFF06B6D4), const Color(0xFFEC4899),
      const Color(0xFF10B981), const Color(0xFFF97316),
      const Color(0xFF6366F1),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.05), blurRadius: 6)],
      ),
      child: Column(
        children: entries.asMap().entries.map((entry) {
          final idx = entry.key;
          final e = entry.value;
          final pct = total > 0 ? e.value / total : 0.0;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colors[idx % colors.length],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      MyText(title: e.key, size: 12, weight: FontWeight.w500, clr: AppColors.black),
                    ]),
                    MyText(
                      title: 'Rs ${e.value.toStringAsFixed(0)}',
                      size: 12,
                      weight: FontWeight.w600,
                      clr: AppColors.black,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: 4,
                    backgroundColor: AppColors.inputBorder,
                    valueColor: AlwaysStoppedAnimation<Color>(colors[idx % colors.length]),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmpty(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: MyText(title: msg, size: 13, weight: FontWeight.w400, clr: AppColors.greyText),
      ),
    );
  }
}
