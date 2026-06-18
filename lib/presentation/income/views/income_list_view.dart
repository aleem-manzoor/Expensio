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
          body: Column(
            children: [
              _buildHeader(controller),
              Expanded(
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : controller.incomes.isEmpty
                        ? _buildEmpty()
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                            itemCount: controller.incomes.length,
                            itemBuilder: (_, i) {
                              final inc = controller.incomes[i];
                              return TransactionCard(
                                title: inc.source,
                                subtitle: inc.description.isEmpty ? 'Income' : inc.description,
                                amount: inc.amount,
                                date: inc.date,
                                isExpense: false,
                                onTap: () => Get.toNamed(Routes.EDIT_INCOME, arguments: inc),
                                onDelete: () => controller.deleteIncome(inc.id),
                              );
                            },
                          ),
              ),
            ],
          ),
          floatingActionButton: GestureDetector(
            onTap: () async {
              await Get.toNamed(Routes.ADD_INCOME);
              controller.loadIncomes();
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.incomeGradient,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.income.withValues(alpha: 0.4), blurRadius: 14, offset: const Offset(0, 6))],
              ),
              child: const Icon(Icons.add_rounded, color: AppColors.white, size: 28),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(IncomeController controller) {
    final total = controller.incomes.fold(0.0, (s, i) => s + i.amount);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
      decoration: const BoxDecoration(
        gradient: AppColors.incomeGradient,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Income', style: TextStyle(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w800)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
              child: Text('${controller.incomes.length} items', style: const TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 16),
          Text('Total earned', style: TextStyle(color: AppColors.white.withValues(alpha: 0.75), fontSize: 13)),
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
          decoration: const BoxDecoration(color: AppColors.incomeLight, shape: BoxShape.circle),
          child: const Icon(Icons.account_balance_wallet_outlined, size: 48, color: AppColors.income),
        ),
        const SizedBox(height: 16),
        const Text('No income records yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.black)),
        const SizedBox(height: 6),
        MyText(title: 'Tap + to add your first income', size: 13, weight: FontWeight.w400, clr: AppColors.greyText),
      ]),
    );
  }
}
