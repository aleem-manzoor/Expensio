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
          body: Column(
            children: [
              _buildHeader(controller),
              Expanded(
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : controller.currentBudget.value == null
                        ? _buildNoBudget()
                        : _buildContent(controller),
              ),
            ],
          ),
          floatingActionButton: GestureDetector(
            onTap: () async {
              await Get.toNamed(Routes.ADD_BUDGET);
              controller.loadBudgets();
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 14, offset: const Offset(0, 6))],
              ),
              child: const Icon(Icons.edit_rounded, color: AppColors.white, size: 24),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BudgetController controller) {
    final now = DateTime.now();
    final budget = controller.currentBudget.value;
    final spent = controller.getTotalSpent();
    final remaining = budget != null ? budget.totalBudget - spent : 0.0;
    final progress = budget != null && budget.totalBudget > 0
        ? (spent / budget.totalBudget).clamp(0.0, 1.0)
        : 0.0;
    final isOver = budget != null && spent > budget.totalBudget;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOver
              ? [const Color(0xFFB71C1C), AppColors.expense]
              : [const Color(0xFF2D1B69), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Budget', style: TextStyle(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w800)),
            GestureDetector(
              onTap: () async {
                await Get.toNamed(Routes.ADD_BUDGET);
                controller.loadBudgets();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                child: const Row(children: [
                  Icon(Icons.tune_rounded, color: AppColors.white, size: 14),
                  SizedBox(width: 6),
                  Text('Set Budget', style: TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
          ]),
          const SizedBox(height: 6),
          Text(
            DateFormat('MMMM yyyy').format(DateTime(now.year, controller.selectedMonth.value)),
            style: TextStyle(color: AppColors.white.withValues(alpha: 0.7), fontSize: 13),
          ),
          if (budget != null) ...[
            const SizedBox(height: 20),
            Text('Rs ${budget.totalBudget.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.white, fontSize: 30, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('monthly budget', style: TextStyle(color: AppColors.white.withValues(alpha: 0.7), fontSize: 12)),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.white.withValues(alpha: 0.25),
                valueColor: AlwaysStoppedAnimation<Color>(isOver ? AppColors.warning : AppColors.white),
              ),
            ),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Spent', style: TextStyle(color: AppColors.white.withValues(alpha: 0.7), fontSize: 11)),
                Text('Rs ${spent.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w700)),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(isOver ? 'Over by' : 'Remaining', style: TextStyle(color: AppColors.white.withValues(alpha: 0.7), fontSize: 11)),
                Text('Rs ${remaining.abs().toStringAsFixed(0)}', style: TextStyle(color: isOver ? AppColors.warning : AppColors.white, fontSize: 14, fontWeight: FontWeight.w700)),
              ]),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(BudgetController controller) {
    final cats = AppConstants.expenseCategories
        .where((cat) => (controller.currentBudget.value!.categoryBudgets[cat] ?? 0) > 0)
        .toList();

    if (cats.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.pie_chart_outline_rounded, size: 48, color: AppColors.lightText),
            const SizedBox(height: 12),
            MyText(title: 'No category budgets set', size: 14, weight: FontWeight.w500, clr: AppColors.greyText),
            const SizedBox(height: 6),
            MyText(title: 'Tap the edit button to add category limits', size: 12, weight: FontWeight.w400, clr: AppColors.lightText),
          ]),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: [
        const Text('Category Budgets', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.black)),
        const SizedBox(height: 14),
        ...cats.map((cat) => BudgetProgressCard(
          category: cat,
          spent: controller.getSpentForCategory(cat),
          budget: controller.currentBudget.value!.categoryBudgets[cat] ?? 0,
        )),
      ],
    );
  }

  Widget _buildNoBudget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
            child: const Icon(Icons.account_balance_wallet_outlined, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          const Text('No budget set', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.black)),
          const SizedBox(height: 8),
          MyText(title: 'Set a monthly budget to start tracking your spending', size: 13, weight: FontWeight.w400, clr: AppColors.greyText),
        ]),
      ),
    );
  }
}
