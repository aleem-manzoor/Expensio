import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/shared_widgets/transaction_card.dart';
import '../bindings/search_binding.dart';
import '../controllers/search_controller.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppSearchController>(
      init: AppSearchController(),
      initState: (_) => SearchBinding().dependencies(),
      builder: (controller) => Scaffold(
        backgroundColor: AppColors.lightWhite,
        body: Column(
          children: [
            _buildHeader(controller),
            _buildFilterChips(controller),
            Expanded(child: _buildResults(controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppSearchController controller) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(Get.context!).padding.top + 16,
        left: 16,
        right: 16,
        bottom: 14,
      ),
      child: Row(children: [
        GestureDetector(
          onTap: Get.back,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.lightWhite, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.black, size: 18),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.lightWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(children: [
              const Icon(Icons.search_rounded, color: AppColors.greyText, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller.searchCtrl,
                  onChanged: controller.onQueryChanged,
                  autofocus: true,
                  style: const TextStyle(fontSize: 14, color: AppColors.black, fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                    hintText: 'Search transactions...',
                    hintStyle: TextStyle(fontSize: 13, color: AppColors.lightText),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
              Obx(() => controller.query.value.isNotEmpty
                  ? GestureDetector(
                      onTap: controller.clear,
                      child: const Icon(Icons.close_rounded, color: AppColors.greyText, size: 18),
                    )
                  : const SizedBox.shrink()),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _buildFilterChips(AppSearchController controller) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.only(left: 16, bottom: 12),
      child: Obx(() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: controller.types.map((type) {
            final isSelected = controller.filterType.value == type;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => controller.setFilter(type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    color: isSelected ? null : AppColors.lightWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? Colors.transparent : AppColors.inputBorder),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.greyText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      )),
    );
  }

  Widget _buildResults(AppSearchController controller) {
    return Obx(() {
      if (controller.query.value.isEmpty) {
        return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: const Icon(Icons.search_rounded, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text('Search your transactions', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.black)),
            const SizedBox(height: 6),
            const Text('Type to find expenses or incomes', style: TextStyle(fontSize: 12, color: AppColors.greyText)),
          ]),
        );
      }

      final hasExpenses = controller.expenseResults.isNotEmpty;
      final hasIncomes = controller.incomeResults.isNotEmpty;

      if (!hasExpenses && !hasIncomes) {
        return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: AppColors.lightWhite, shape: BoxShape.circle),
              child: const Icon(Icons.search_off_rounded, size: 40, color: AppColors.lightText),
            ),
            const SizedBox(height: 16),
            Text(
              'No results for "${controller.query.value}"',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
            ),
            const SizedBox(height: 6),
            const Text('Try a different keyword', style: TextStyle(fontSize: 12, color: AppColors.greyText)),
          ]),
        );
      }

      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          if (hasExpenses) ...[
            _buildResultsHeader('Expenses', controller.expenseResults.length, AppColors.expense),
            const SizedBox(height: 10),
            ...controller.expenseResults.map((e) => TransactionCard(
              title: e.category,
              subtitle: e.description.isNotEmpty ? e.description : e.paymentMethod,
              amount: e.amount,
              date: e.date,
              isExpense: true,
            )),
            const SizedBox(height: 12),
          ],
          if (hasIncomes) ...[
            _buildResultsHeader('Incomes', controller.incomeResults.length, AppColors.income),
            const SizedBox(height: 10),
            ...controller.incomeResults.map((inc) => TransactionCard(
              title: inc.source,
              subtitle: inc.description.isNotEmpty ? inc.description : inc.source,
              amount: inc.amount,
              date: inc.date,
              isExpense: false,
            )),
          ],
        ],
      );
    });
  }

  Widget _buildResultsHeader(String label, int count, Color color) {
    return Row(children: [
      Container(width: 4, height: 16, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 8),
      Text('$label ($count)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.black)),
    ]);
  }
}
