import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/routes/app_pages.dart';
import '../../../app/shared_widgets/my_text.dart';
import '../../../app/shared_widgets/summary_card.dart';
import '../../../app/shared_widgets/transaction_card.dart';
import '../../../presentation/home/bindings/home_binding.dart';
import '../../../presentation/main/controllers/main_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      initState: (_) => HomeBinding().dependencies(),
      builder: (controller) => Obx(
        () => Scaffold(
          backgroundColor: AppColors.lightWhite,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async => controller.loadData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildSummaryRow(controller),
                    const SizedBox(height: 20),
                    _buildSearchBar(),
                    const SizedBox(height: 20),
                    _buildSectionHeader('Recent Expenses', onSeeAll: () => Get.find<dynamic>()),
                    const SizedBox(height: 10),
                    if (controller.isLoading.value)
                      const Center(child: CircularProgressIndicator())
                    else if (controller.recentExpenses.isEmpty)
                      _buildEmpty('No expenses yet')
                    else
                      ...controller.recentExpenses.map(
                        (e) => TransactionCard(
                          title: e.category,
                          subtitle: e.description.isEmpty ? e.paymentMethod : e.description,
                          amount: e.amount,
                          date: e.date,
                          isExpense: true,
                        ),
                      ),
                    const SizedBox(height: 20),
                    _buildSectionHeader('Recent Income'),
                    const SizedBox(height: 10),
                    if (controller.recentIncomes.isEmpty)
                      _buildEmpty('No income yet')
                    else
                      ...controller.recentIncomes.map(
                        (i) => TransactionCard(
                          title: i.source,
                          subtitle: i.description.isEmpty ? 'Income' : i.description,
                          amount: i.amount,
                          date: i.date,
                          isExpense: false,
                        ),
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.toNamed(Routes.ADD_EXPENSE),
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: AppColors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(title: 'Finance Tracker', size: 20, weight: FontWeight.w700, clr: AppColors.black),
            MyText(
              title: DateFormat('MMMM yyyy').format(now),
              size: 12,
              weight: FontWeight.w400,
              clr: AppColors.greyText,
            ),
          ],
        ),
        GestureDetector(
          onTap: () => _confirmLogout(),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.06), blurRadius: 6)],
            ),
            child: const Icon(Icons.logout_rounded, color: AppColors.red, size: 22),
          ),
        ),
      ],
    );
  }

  void _confirmLogout() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: MyText(title: 'Logout', size: 16, weight: FontWeight.w700, clr: AppColors.black),
        content: MyText(
          title: 'Are you sure you want to logout?',
          size: 13,
          weight: FontWeight.w400,
          clr: AppColors.greyText,
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: MyText(title: 'Cancel', size: 13, weight: FontWeight.w600, clr: AppColors.greyText),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.find<MainController>().logout();
            },
            child: MyText(title: 'Logout', size: 13, weight: FontWeight.w600, clr: AppColors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(HomeController controller) {
    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            label: 'Income',
            amount: controller.totalIncome.value.toStringAsFixed(0),
            color: AppColors.primary,
            icon: Icons.arrow_downward_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SummaryCard(
            label: 'Expenses',
            amount: controller.totalExpenses.value.toStringAsFixed(0),
            color: AppColors.red,
            icon: Icons.arrow_upward_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SummaryCard(
            label: 'Savings',
            amount: controller.savings.value.toStringAsFixed(0),
            color: AppColors.primary,
            icon: Icons.savings_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.SEARCH),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.06), blurRadius: 6)],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.greyText, size: 20),
            const SizedBox(width: 10),
            MyText(title: 'Search transactions...', size: 13, weight: FontWeight.w400, clr: AppColors.greyText),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyText(title: title, size: 15, weight: FontWeight.w700, clr: AppColors.black),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: MyText(title: 'See all', size: 12, weight: FontWeight.w500, clr: AppColors.primary),
          ),
      ],
    );
  }

  Widget _buildEmpty(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: MyText(title: msg, size: 13, weight: FontWeight.w400, clr: AppColors.greyText),
      ),
    );
  }
}
