import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/app_constants.dart';
import '../../../app/utils/utils.dart';
import '../../../data/model/budget_model.dart';
import '../../../data/repositories/budget_repository.dart';
import '../../../data/repositories/expense_repository.dart';

class BudgetController extends GetxController {
  RxList<BudgetModel> budgets = <BudgetModel>[].obs;
  Rx<BudgetModel?> currentBudget = Rx<BudgetModel?>(null);
  RxBool isLoading = false.obs;
  RxBool isSaving = false.obs;

  final totalBudgetCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  RxInt selectedMonth = DateTime.now().month.obs;
  RxInt selectedYear = DateTime.now().year.obs;
  RxMap<String, TextEditingController> categoryControllers =
      <String, TextEditingController>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initCategoryControllers();
    loadBudgets();
  }

  void _initCategoryControllers() {
    for (final cat in AppConstants.expenseCategories) {
      categoryControllers[cat] = TextEditingController();
    }
  }

  void loadBudgets() {
    isLoading.value = true;
    budgets.value = BudgetRepository.getAllBudgets();
    currentBudget.value = BudgetRepository.getBudgetForMonth(
      selectedMonth.value,
      selectedYear.value,
    );
    if (currentBudget.value != null) {
      totalBudgetCtrl.text = currentBudget.value!.totalBudget.toString();
      for (final cat in AppConstants.expenseCategories) {
        categoryControllers[cat]?.text =
            (currentBudget.value!.categoryBudgets[cat] ?? 0).toString();
      }
    }
    isLoading.value = false;
  }

  double getSpentForCategory(String category) {
    return ExpenseRepository.getTotalExpensesForMonth(
              selectedMonth.value, selectedYear.value) > 0
        ? ExpenseRepository
            .getCategoryTotals(month: selectedMonth.value, year: selectedYear.value)[category] ?? 0
        : 0;
  }

  double getTotalSpent() =>
      ExpenseRepository.getTotalExpensesForMonth(selectedMonth.value, selectedYear.value);

  Future<void> saveBudget() async {
    if (!formKey.currentState!.validate()) return;
    isSaving.value = true;
    try {
      final Map<String, double> categoryBudgets = {};
      for (final cat in AppConstants.expenseCategories) {
        final val = double.tryParse(categoryControllers[cat]?.text ?? '0') ?? 0;
        if (val > 0) categoryBudgets[cat] = val;
      }
      await BudgetRepository.setBudget(
        totalBudget: double.tryParse(totalBudgetCtrl.text) ?? 0,
        categoryBudgets: categoryBudgets,
        month: selectedMonth.value,
        year: selectedYear.value,
      );
      loadBudgets();
      Get.back();
      Utils.showToast(message: 'Budget saved');
    } catch (_) {
      Utils.showToast(message: 'Something went wrong');
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    totalBudgetCtrl.dispose();
    for (final c in categoryControllers.values) {
      c.dispose();
    }
    super.onClose();
  }
}
