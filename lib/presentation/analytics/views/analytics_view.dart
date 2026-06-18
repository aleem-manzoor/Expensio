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
          body: controller.isLoading.value
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async => controller.loadAnalytics(),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(child: _buildHeader(controller)),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            const SizedBox(height: 24),
                            _buildSectionTitle('Monthly Trend'),
                            const SizedBox(height: 14),
                            _buildLineChart(controller),
                            const SizedBox(height: 8),
                            _buildChartLegend(),
                            const SizedBox(height: 28),
                            _buildSectionTitle('This Month by Category'),
                            const SizedBox(height: 14),
                            if (controller.categoryTotals.isEmpty)
                              _buildEmpty('No expense data this month')
                            else ...[
                              _buildPieChart(controller),
                              const SizedBox(height: 16),
                              _buildCategoryList(controller),
                            ],
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildHeader(AnalyticsController c) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Analytics', style: TextStyle(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w800)),
          GestureDetector(
            onTap: c.loadAnalytics,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.refresh_rounded, color: AppColors.white, size: 20),
            ),
          ),
        ]),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: _buildHeaderStat('Total Income', 'Rs ${c.totalIncomes.value.toStringAsFixed(0)}', AppColors.income)),
          const SizedBox(width: 12),
          Expanded(child: _buildHeaderStat('Total Spent', 'Rs ${c.totalExpenses.value.toStringAsFixed(0)}', AppColors.expense)),
          const SizedBox(width: 12),
          Expanded(child: _buildHeaderStat('Savings', 'Rs ${c.totalSavings.value.abs().toStringAsFixed(0)}',
              c.totalSavings.value >= 0 ? AppColors.income : AppColors.expense)),
        ]),
      ]),
    );
  }

  Widget _buildHeaderStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(color: AppColors.white.withValues(alpha: 0.7), fontSize: 10, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800)),
        ),
      ]),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.black));
  }

  Widget _buildLineChart(AnalyticsController c) {
    if (c.monthlyExpenses.isEmpty) return _buildEmpty('No data yet');

    final expSpots = c.monthlyExpenses.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();
    final incSpots = c.monthlyIncomes.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(8, 20, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.07), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _chartInterval(c),
            getDrawingHorizontalLine: (_) => FlLine(color: AppColors.cardBorder, strokeWidth: 1),
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
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(c.monthLabels[idx], style: const TextStyle(fontSize: 10, color: AppColors.greyText, fontWeight: FontWeight.w600)),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
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
            _lineBar(incSpots, AppColors.income, AppColors.incomeLight),
            _lineBar(expSpots, AppColors.expense, AppColors.expenseLight),
          ],
        ),
      ),
    );
  }

  LineChartBarData _lineBar(List<FlSpot> spots, Color color, Color fillColor) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.35,
      color: color,
      barWidth: 2.5,
      dotData: FlDotData(
        show: true,
        getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
          radius: 3,
          color: color,
          strokeWidth: 2,
          strokeColor: AppColors.white,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [fillColor.withValues(alpha: 0.5), fillColor.withValues(alpha: 0.0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildChartLegend() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _legendDot('Income', AppColors.income),
      const SizedBox(width: 20),
      _legendDot('Expenses', AppColors.expense),
    ]);
  }

  Widget _legendDot(String label, Color color) {
    return Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.greyText)),
    ]);
  }

  Widget _buildPieChart(AnalyticsController c) {
    final entries = c.sortedCategories;
    final total = entries.fold<double>(0, (a, e) => a + e.value);
    if (total == 0) return const SizedBox.shrink();

    final colors = [
      AppColors.primary, AppColors.expense, AppColors.income,
      AppColors.warning, const Color(0xFF8B5CF6), const Color(0xFF06B6D4),
      const Color(0xFFEC4899), const Color(0xFF10B981), const Color(0xFFF97316), const Color(0xFF6366F1),
    ];

    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.07), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: PieChart(
        PieChartData(
          sectionsSpace: 3,
          centerSpaceRadius: 55,
          sections: entries.asMap().entries.map((entry) {
            final pct = (entry.value.value / total * 100).toStringAsFixed(1);
            return PieChartSectionData(
              color: colors[entry.key % colors.length],
              value: entry.value.value,
              title: '$pct%',
              radius: 48,
              titleStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
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
      AppColors.primary, AppColors.expense, AppColors.income,
      AppColors.warning, const Color(0xFF8B5CF6), const Color(0xFF06B6D4),
      const Color(0xFFEC4899), const Color(0xFF10B981), const Color(0xFFF97316), const Color(0xFF6366F1),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.07), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: entries.asMap().entries.map((entry) {
          final color = colors[entry.key % colors.length];
          final pct = total > 0 ? entry.value.value / total : 0.0;
          final isLast = entry.key == entries.length - 1;
          return Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                    const SizedBox(width: 10),
                    Text(entry.value.key, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.black)),
                  ]),
                  Text('Rs ${entry.value.value.toStringAsFixed(0)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
                ]),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: 5,
                    backgroundColor: AppColors.lightWhite,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ]),
            ),
            if (!isLast) const Divider(height: 1, color: AppColors.cardBorder, indent: 16, endIndent: 16),
          ]);
        }).toList(),
      ),
    );
  }

  double _chartInterval(AnalyticsController c) {
    final maxVal = [...c.monthlyExpenses, ...c.monthlyIncomes].fold<double>(0, (a, b) => b > a ? b : a);
    if (maxVal == 0) return 1000;
    return (maxVal / 4).ceilToDouble();
  }

  String _compact(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}k';
    return v.toStringAsFixed(0);
  }

  Widget _buildEmpty(String msg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        const Icon(Icons.bar_chart_rounded, size: 40, color: AppColors.lightText),
        const SizedBox(height: 10),
        MyText(title: msg, size: 13, weight: FontWeight.w400, clr: AppColors.greyText),
      ]),
    );
  }
}
