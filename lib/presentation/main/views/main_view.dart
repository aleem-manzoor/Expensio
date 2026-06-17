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
          body: _pages[controller.currentIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.greyText,
            selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
            backgroundColor: AppColors.white,
            elevation: 10,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.arrow_upward_outlined), activeIcon: Icon(Icons.arrow_upward), label: 'Expenses'),
              BottomNavigationBarItem(icon: Icon(Icons.arrow_downward_outlined), activeIcon: Icon(Icons.arrow_downward), label: 'Income'),
              BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), activeIcon: Icon(Icons.account_balance_wallet), label: 'Budget'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: 'Analytics'),
            ],
          ),
        ));
  }
}
