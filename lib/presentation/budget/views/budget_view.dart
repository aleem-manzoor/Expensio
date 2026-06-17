import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/config/app_constants.dart';
import '../../../app/routes/app_pages.dart';
import '../../../app/shared_widgets/budget_progress_card.dart';
import '../../../app/shared_widgets/my_text.dart';
import '../bindings/budget_binding.dart';
import '../controllers/budget_controller.dart';

class BudgetView extends StatelessWidget {
  const BudgetView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BudgetController>(
      init: BudgetController(),
      initState: (_) => BudgetBinding().dependencies(),
      builder: (controller) => Obx(
        () => Scaffold(
          backgroundColor: AppColors.lightWhite,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title: MyText(title: 'Budget', size: 16, weight: FontWeight.w700, clr: AppColors.black),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              GestureDetector(
                onTap: () async {
                  await Get.toNamed(Routes.ADD_BUDGET);
                  controller.loadBudgets();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.edit_outlined, color: AppColors.primary),
                ),
              ),
            ],
          ),
          body: controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMonthSelector(controller),
                      const SizedBox(height: 16),
                      if (controller.currentBudget.value == null)
                        _buildNoBudget()
                      else ...[
                        _buildOverallCard(controller),
                        const SizedBox(height: 20),
                        MyText(title: 'Category Budgets', size: 15, weight: FontWeight.w700, clr: AppColors.black),
                        const SizedBox(height: 12),
                        ...AppConstants.expenseCategories
                            .where((cat) =>
                                (controller.currentBudget.value!.categoryBudgets[cat] ?? 0) > 0)
                            .map((cat) => BudgetProgressCard(
                                  category: cat,
                                  spent: controller.getSpentForCategory(cat),
                                  budget: controller.currentBudget.value!.categoryBudgets[cat] ?? 0,
                                )),
                      ],
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await Get.toNamed(Routes.ADD_BUDGET);
              controller.loadBudgets();
            },
            backgroundColor: AppColors.primary,
            label: MyText(title: 'Set Budget', size: 13, weight: FontWeight.w600, clr: AppColors.white),
            icon: const Icon(Icons.add, color: AppColors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSelector(BudgetController controller) {
    final now = DateTime.now();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.06), blurRadius: 6)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyText(
            title: DateFormat('MMMM yyyy').format(DateTime(now.year, controller.selectedMonth.value)),
            size: 14,
            weight: FontWeight.w600,
            clr: AppColors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildNoBudget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            const Icon(Icons.account_balance_wallet_outlined, size: 60, color: AppColors.greyText),
            const SizedBox(height: 12),
            MyText(title: 'No budget set for this month', size: 14, weight: FontWeight.w500, clr: AppColors.greyText),
            const SizedBox(height: 8),
            MyText(title: 'Tap + to set your budget', size: 12, weight: FontWeight.w400, clr: AppColors.greyText),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallCard(BudgetController controller) {
    final budget = controller.currentBudget.value!;
    final spent = controller.getTotalSpent();
    final remaining = budget.totalBudget - spent;
    final progress = budget.totalBudget > 0 ? (spent / budget.totalBudget).clamp(0.0, 1.0) : 0.0;
    final isOver = spent > budget.totalBudget;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isOver ? AppColors.red : AppColors.primary,
            (isOver ? AppColors.red : AppColors.primary).withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(title: 'Monthly Budget', size: 13, weight: FontWeight.w500, clr: AppColors.white),
          const SizedBox(height: 6),
          MyText(title: 'Rs ${budget.totalBudget.toStringAsFixed(0)}', size: 24, weight: FontWeight.w700, clr: AppColors.white),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                MyText(title: 'Spent', size: 11, weight: FontWeight.w400, clr: AppColors.white),
                MyText(title: 'Rs ${spent.toStringAsFixed(0)}', size: 14, weight: FontWeight.w700, clr: AppColors.white),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                MyText(title: isOver ? 'Over by' : 'Remaining', size: 11, weight: FontWeight.w400, clr: AppColors.white),
                MyText(title: 'Rs ${remaining.abs().toStringAsFixed(0)}', size: 14, weight: FontWeight.w700, clr: AppColors.white),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
