import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/routes/app_pages.dart';
import '../../../app/shared_widgets/my_text.dart';
import '../../../app/shared_widgets/transaction_card.dart';
import '../bindings/expense_binding.dart';
import '../controllers/expense_controller.dart';

class ExpenseListView extends StatelessWidget {
  const ExpenseListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpenseController>(
      init: ExpenseController(),
      initState: (_) => ExpenseBinding().dependencies(),
      builder: (controller) => Obx(
        () => Scaffold(
          backgroundColor: AppColors.lightWhite,
          body: Column(
            children: [
              _buildHeader(controller),
              Expanded(
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : controller.expenses.isEmpty
                        ? _buildEmpty()
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                            itemCount: controller.expenses.length,
                            itemBuilder: (_, i) {
                              final e = controller.expenses[i];
                              return TransactionCard(
                                title: e.category,
                                subtitle: e.description.isEmpty ? e.paymentMethod : e.description,
                                amount: e.amount,
                                date: e.date,
                                isExpense: true,
                                onTap: () => Get.toNamed(Routes.EDIT_EXPENSE, arguments: e),
                                onDelete: () => controller.deleteExpense(e.id),
                              );
                            },
                          ),
              ),
            ],
          ),
          floatingActionButton: GestureDetector(
            onTap: () async {
              await Get.toNamed(Routes.ADD_EXPENSE);
              controller.loadExpenses();
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.expenseGradient,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.expense.withValues(alpha: 0.4), blurRadius: 14, offset: const Offset(0, 6))],
              ),
              child: const Icon(Icons.add_rounded, color: AppColors.white, size: 28),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ExpenseController controller) {
    final total = controller.expenses.fold(0.0, (s, e) => s + e.amount);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
      decoration: const BoxDecoration(
        gradient: AppColors.expenseGradient,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Expenses', style: TextStyle(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w800)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
              child: Text('${controller.expenses.length} items', style: const TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 16),
          Text('Total spent', style: TextStyle(color: AppColors.white.withValues(alpha: 0.75), fontSize: 13)),
          const SizedBox(height: 4),
          Text('Rs ${total.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.white, fontSize: 30, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppColors.expenseLight, shape: BoxShape.circle),
          child: const Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.expense),
        ),
        const SizedBox(height: 16),
        const Text('No expenses yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.black)),
        const SizedBox(height: 6),
        MyText(title: 'Tap + to add your first expense', size: 13, weight: FontWeight.w400, clr: AppColors.greyText),
      ]),
    );
  }
}
