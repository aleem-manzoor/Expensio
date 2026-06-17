import 'package:get/get.dart';
import '../../../data/repositories/expense_repository.dart';
import '../../../data/repositories/income_repository.dart';

class AnalyticsController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<double> monthlyExpenses = <double>[].obs;
  RxList<double> monthlyIncomes = <double>[].obs;
  RxList<String> monthLabels = <String>[].obs;

  RxMap<String, double> categoryTotals = <String, double>{}.obs;
  RxDouble totalExpenses = 0.0.obs;
  RxDouble totalIncomes = 0.0.obs;
  RxDouble totalSavings = 0.0.obs;

  final int selectedYear = DateTime.now().year;

  @override
  void onInit() {
    super.onInit();
    loadAnalytics();
  }

  void loadAnalytics() {
    isLoading.value = true;
    final now = DateTime.now();

    final List<double> expenses = [];
    final List<double> incomes = [];
    final List<String> labels = [];

    for (int m = 1; m <= now.month; m++) {
      final exp = ExpenseRepository.getTotalExpensesForMonth(m, selectedYear);
      final inc = IncomeRepository.getTotalIncomeForMonth(m, selectedYear);
      expenses.add(exp);
      incomes.add(inc);
      labels.add(_monthShort(m));
    }

    monthlyExpenses.value = expenses;
    monthlyIncomes.value = incomes;
    monthLabels.value = labels;

    final catTotals = ExpenseRepository.getCategoryTotals(
      month: now.month,
      year: selectedYear,
    );
    categoryTotals.value = Map.fromEntries(
      catTotals.entries.where((e) => e.value > 0),
    );

    totalExpenses.value = expenses.fold(0, (a, b) => a + b);
    totalIncomes.value = incomes.fold(0, (a, b) => a + b);
    totalSavings.value = totalIncomes.value - totalExpenses.value;

    isLoading.value = false;
  }

  String _monthShort(int m) {
    const names = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return names[m - 1];
  }

  List<MapEntry<String, double>> get sortedCategories {
    final entries = categoryTotals.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }
}
