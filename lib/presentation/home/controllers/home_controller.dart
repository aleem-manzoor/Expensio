import 'package:get/get.dart';
import '../../../data/repositories/expense_repository.dart';
import '../../../data/repositories/income_repository.dart';
import '../../../data/model/expense_model.dart';
import '../../../data/model/income_model.dart';

class HomeController extends GetxController {
  RxDouble totalIncome = 0.0.obs;
  RxDouble totalExpenses = 0.0.obs;
  RxDouble savings = 0.0.obs;
  RxList<ExpenseModel> recentExpenses = <ExpenseModel>[].obs;
  RxList<IncomeModel> recentIncomes = <IncomeModel>[].obs;
  RxBool isLoading = false.obs;

  final now = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    isLoading.value = true;
    totalIncome.value = IncomeRepository.getTotalIncomeForMonth(now.month, now.year);
    totalExpenses.value = ExpenseRepository.getTotalExpensesForMonth(now.month, now.year);
    savings.value = totalIncome.value - totalExpenses.value;
    recentExpenses.value = ExpenseRepository.getAllExpenses().take(5).toList();
    recentIncomes.value = IncomeRepository.getAllIncomes().take(5).toList();
    isLoading.value = false;
  }
}
