import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/expense_model.dart';
import '../../../data/model/income_model.dart';
import '../../../data/repositories/expense_repository.dart';
import '../../../data/repositories/income_repository.dart';

class AppSearchController extends GetxController {
  final searchCtrl = TextEditingController();
  RxString query = ''.obs;
  RxString filterType = 'All'.obs;
  RxList<String> types = ['All', 'Expenses', 'Incomes'].obs;

  RxList<ExpenseModel> expenseResults = <ExpenseModel>[].obs;
  RxList<IncomeModel> incomeResults = <IncomeModel>[].obs;
  RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    debounce(query, (_) => search(), time: const Duration(milliseconds: 400));
  }

  void search() {
    final q = query.value.trim();
    if (q.isEmpty) {
      expenseResults.clear();
      incomeResults.clear();
      return;
    }
    isSearching.value = true;

    if (filterType.value != 'Incomes') {
      expenseResults.value = ExpenseRepository.searchExpenses(q);
    } else {
      expenseResults.clear();
    }

    if (filterType.value != 'Expenses') {
      incomeResults.value = IncomeRepository.searchIncomes(q);
    } else {
      incomeResults.clear();
    }

    isSearching.value = false;
  }

  void onQueryChanged(String val) {
    query.value = val;
  }

  void setFilter(String type) {
    filterType.value = type;
    search();
  }

  void clear() {
    searchCtrl.clear();
    query.value = '';
    expenseResults.clear();
    incomeResults.clear();
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }
}
