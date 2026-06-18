import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/config/global_var.dart';
import '../../../app/routes/app_pages.dart';
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
          body: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => controller.loadData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(controller),
                  _buildBody(controller),
                ],
              ),
            ),
          ),
          floatingActionButton: _buildFAB(),
        ),
      ),
    );
  }

  Widget _buildHeader(HomeController controller) {
    final firstName = Globals.user?.firstName ?? 'There';
    final now = DateTime.now();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Hi, $firstName 👋',
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('MMMM yyyy').format(now),
                  style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ]),
              Row(children: [
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.SEARCH),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.search_rounded, color: AppColors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _confirmLogout,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.logout_rounded, color: AppColors.white, size: 20),
                  ),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 28),
          Center(
            child: Column(children: [
              Text(
                'Total Savings',
                style: TextStyle(color: AppColors.white.withValues(alpha: 0.7), fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              Text(
                'Rs ${controller.savings.value.toStringAsFixed(0)}',
                style: const TextStyle(color: AppColors.white, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -0.5),
              ),
            ]),
          ),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: _buildStatCard('Income', controller.totalIncome.value, AppColors.income, Icons.arrow_downward_rounded)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Expenses', controller.totalExpenses.value, AppColors.expense, Icons.arrow_upward_rounded)),
          ]),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, double amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.2)),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.25), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(color: AppColors.white.withValues(alpha: 0.7), fontSize: 10, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text('Rs ${amount.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w700)),
        ]),
      ]),
    );
  }

  Widget _buildBody(HomeController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Recent Expenses'),
          const SizedBox(height: 12),
          if (controller.isLoading.value)
            const Center(child: CircularProgressIndicator(color: AppColors.primary))
          else if (controller.recentExpenses.isEmpty)
            _buildEmpty('No expenses yet', Icons.receipt_long_outlined)
          else
            ...controller.recentExpenses.map((e) => TransactionCard(
              title: e.category,
              subtitle: e.description.isEmpty ? e.paymentMethod : e.description,
              amount: e.amount,
              date: e.date,
              isExpense: true,
            )),
          const SizedBox(height: 24),
          _buildSectionHeader('Recent Income'),
          const SizedBox(height: 12),
          if (controller.recentIncomes.isEmpty)
            _buildEmpty('No income recorded yet', Icons.account_balance_wallet_outlined)
          else
            ...controller.recentIncomes.map((i) => TransactionCard(
              title: i.source,
              subtitle: i.description.isEmpty ? 'Income' : i.description,
              amount: i.amount,
              date: i.date,
              isExpense: false,
            )),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.black)),
      ],
    );
  }

  Widget _buildEmpty(String msg, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(children: [
        Icon(icon, size: 40, color: AppColors.lightText),
        const SizedBox(height: 10),
        Text(msg, style: const TextStyle(fontSize: 13, color: AppColors.greyText, fontWeight: FontWeight.w400)),
      ]),
    );
  }

  Widget _buildFAB() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.ADD_EXPENSE),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: const Icon(Icons.add_rounded, color: AppColors.white, size: 28),
      ),
    );
  }

  void _confirmLogout() {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Logout', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.black)),
      content: const Text('Are you sure you want to logout?', style: TextStyle(fontSize: 13, color: AppColors.greyText)),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: const Text('Cancel', style: TextStyle(color: AppColors.greyText, fontWeight: FontWeight.w600)),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            Get.find<MainController>().logout();
          },
          child: const Text('Logout', style: TextStyle(color: AppColors.expense, fontWeight: FontWeight.w700)),
        ),
      ],
    ));
  }
}
