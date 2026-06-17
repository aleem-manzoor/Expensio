import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/shared_widgets/my_text.dart';
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
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: GestureDetector(
            onTap: Get.back,
            child: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20),
          ),
          title: MyText(title: 'Search', size: 16, weight: FontWeight.w700, clr: AppColors.black),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _buildSearchBar(controller),
            _buildFilterChips(controller),
            Expanded(child: _buildResults(controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(AppSearchController controller) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.lightWhite,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.greyText, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller.searchCtrl,
                      onChanged: controller.onQueryChanged,
                      autofocus: true,
                      style: const TextStyle(fontSize: 13, color: AppColors.black),
                      decoration: const InputDecoration(
                        hintText: 'Search expenses or incomes…',
                        hintStyle: TextStyle(fontSize: 12, color: AppColors.greyText),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  Obx(() => controller.query.value.isNotEmpty
                      ? GestureDetector(
                          onTap: controller.clear,
                          child: const Icon(Icons.close, color: AppColors.greyText, size: 18),
                        )
                      : const SizedBox.shrink()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(AppSearchController controller) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.only(left: 16, bottom: 10),
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
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.lightWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.inputBorder,
                    ),
                  ),
                  child: MyText(
                    title: type,
                    size: 12,
                    weight: FontWeight.w500,
                    clr: isSelected ? AppColors.white : AppColors.black,
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
      if (controller.isSearching.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.query.value.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search, size: 60, color: AppColors.greyText),
              const SizedBox(height: 12),
              MyText(
                title: 'Search your transactions',
                size: 14,
                weight: FontWeight.w400,
                clr: AppColors.greyText,
              ),
            ],
          ),
        );
      }

      final hasExpenses = controller.expenseResults.isNotEmpty;
      final hasIncomes = controller.incomeResults.isNotEmpty;

      if (!hasExpenses && !hasIncomes) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inbox_outlined, size: 60, color: AppColors.greyText),
              const SizedBox(height: 12),
              MyText(
                title: 'No results for "${controller.query.value}"',
                size: 13,
                weight: FontWeight.w400,
                clr: AppColors.greyText,
              ),
            ],
          ),
        );
      }

      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (hasExpenses) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MyText(
                title: 'Expenses (${controller.expenseResults.length})',
                size: 13,
                weight: FontWeight.w700,
                clr: AppColors.black,
              ),
            ),
            ...controller.expenseResults.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TransactionCard(
                title: e.category,
                subtitle: e.description.isNotEmpty ? e.description : e.paymentMethod,
                amount: e.amount,
                date: e.date,
                isExpense: true,
                onDelete: null,
                onTap: null,
              ),
            )),
            const SizedBox(height: 8),
          ],
          if (hasIncomes) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MyText(
                title: 'Incomes (${controller.incomeResults.length})',
                size: 13,
                weight: FontWeight.w700,
                clr: AppColors.black,
              ),
            ),
            ...controller.incomeResults.map((inc) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TransactionCard(
                title: inc.source,
                subtitle: inc.description.isNotEmpty ? inc.description : inc.source,
                amount: inc.amount,
                date: inc.date,
                isExpense: false,
                onDelete: null,
                onTap: null,
              ),
            )),
          ],
        ],
      );
    });
  }
}
