import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/app_colors.dart';
import '../../../presentation/home/views/home_view.dart';
import '../../../presentation/expense/views/expense_list_view.dart';
import '../../../presentation/income/views/income_list_view.dart';
import '../../../presentation/budget/views/budget_view.dart';
import '../../../presentation/analytics/views/analytics_view.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  static final List<Widget> _pages = [
    HomeView(),
    ExpenseListView(),
    IncomeListView(),
    BudgetView(),
    AnalyticsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: AppColors.lightWhite,
          body: _pages[controller.currentIndex.value],
          bottomNavigationBar: _buildBottomNav(),
        ));
  }

  Widget _buildBottomNav() {
    final items = [
      _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
      _NavItem(icon: Icons.arrow_upward_outlined, activeIcon: Icons.arrow_upward_rounded, label: 'Expenses'),
      _NavItem(icon: Icons.arrow_downward_outlined, activeIcon: Icons.arrow_downward_rounded, label: 'Income'),
      _NavItem(icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet_rounded, label: 'Budget'),
      _NavItem(icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart_rounded, label: 'Analytics'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final isSelected = controller.currentIndex.value == i;
              return GestureDetector(
                onTap: () => controller.changeTab(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? items[i].activeIcon : items[i].icon,
                        color: isSelected ? AppColors.white : AppColors.greyText,
                        size: 22,
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 6),
                        Text(
                          items[i].label,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  _NavItem({required this.icon, required this.activeIcon, required this.label});
}
