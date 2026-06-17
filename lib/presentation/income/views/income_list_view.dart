import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/routes/app_pages.dart';
import '../../../app/shared_widgets/my_text.dart';
import '../../../app/shared_widgets/transaction_card.dart';
import '../bindings/income_binding.dart';
import '../controllers/income_controller.dart';

class IncomeListView extends StatelessWidget {
  const IncomeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IncomeController>(
      init: IncomeController(),
      initState: (_) => IncomeBinding().dependencies(),
      builder: (controller) => Obx(
        () => Scaffold(
          backgroundColor: AppColors.lightWhite,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title: MyText(title: 'Income', size: 16, weight: FontWeight.w700, clr: AppColors.black),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.incomes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.account_balance_wallet_outlined, size: 60, color: AppColors.greyText),
                          const SizedBox(height: 12),
                          MyText(title: 'No income records yet', size: 14, weight: FontWeight.w500, clr: AppColors.greyText),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.incomes.length,
                      itemBuilder: (_, i) {
                        final income = controller.incomes[i];
                        return TransactionCard(
                          title: income.source,
                          subtitle: income.description.isEmpty ? 'Income' : income.description,
                          amount: income.amount,
                          date: income.date,
                          isExpense: false,
                          onTap: () => Get.toNamed(Routes.EDIT_INCOME, arguments: income),
                          onDelete: () => controller.deleteIncome(income.id),
                        );
                      },
                    ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Get.toNamed(Routes.ADD_INCOME);
              controller.loadIncomes();
            },
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
