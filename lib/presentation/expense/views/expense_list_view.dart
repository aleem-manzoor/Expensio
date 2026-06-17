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
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title: MyText(title: 'Expenses', size: 16, weight: FontWeight.w700, clr: AppColors.black),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.expenses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.receipt_long_outlined, size: 60, color: AppColors.greyText),
                          const SizedBox(height: 12),
                          MyText(title: 'No expenses yet', size: 14, weight: FontWeight.w500, clr: AppColors.greyText),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
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
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Get.toNamed(Routes.ADD_EXPENSE);
              controller.loadExpenses();
            },
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
