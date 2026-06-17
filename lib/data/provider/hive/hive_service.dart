import 'package:hive_flutter/hive_flutter.dart';
import '../../model/expense_model.dart';
import '../../model/income_model.dart';
import '../../model/budget_model.dart';

class HiveService {
  static Box<String> get _expenseBox => Hive.box<String>('expenses');
  static Box<String> get _incomeBox => Hive.box<String>('incomes');
  static Box<String> get _budgetBox => Hive.box<String>('budgets');

  // Expenses
  static Future<void> saveExpense(ExpenseModel expense) async {
    await _expenseBox.put(expense.id, expense.toJson());
  }

  static Future<void> deleteExpense(String id) async {
    await _expenseBox.delete(id);
  }

  static List<ExpenseModel> getAllExpenses() {
    return _expenseBox.values
        .map((e) => ExpenseModel.fromJson(e))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static List<ExpenseModel> getUnsyncedExpenses() {
    return _expenseBox.values
        .map((e) => ExpenseModel.fromJson(e))
        .where((e) => !e.isSynced)
        .toList();
  }

  static ExpenseModel? getExpense(String id) {
    final raw = _expenseBox.get(id);
    if (raw == null) return null;
    return ExpenseModel.fromJson(raw);
  }

  // Incomes
  static Future<void> saveIncome(IncomeModel income) async {
    await _incomeBox.put(income.id, income.toJson());
  }

  static Future<void> deleteIncome(String id) async {
    await _incomeBox.delete(id);
  }

  static List<IncomeModel> getAllIncomes() {
    return _incomeBox.values
        .map((e) => IncomeModel.fromJson(e))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static List<IncomeModel> getUnsyncedIncomes() {
    return _incomeBox.values
        .map((e) => IncomeModel.fromJson(e))
        .where((e) => !e.isSynced)
        .toList();
  }

  // Budgets
  static Future<void> saveBudget(BudgetModel budget) async {
    await _budgetBox.put(budget.id, budget.toJson());
  }

  static Future<void> deleteBudget(String id) async {
    await _budgetBox.delete(id);
  }

  static List<BudgetModel> getAllBudgets() {
    return _budgetBox.values
        .map((e) => BudgetModel.fromJson(e))
        .toList();
  }

  static List<BudgetModel> getUnsyncedBudgets() {
    return _budgetBox.values
        .map((e) => BudgetModel.fromJson(e))
        .where((e) => !e.isSynced)
        .toList();
  }

  static BudgetModel? getBudgetForMonth(int month, int year) {
    try {
      return _budgetBox.values
          .map((e) => BudgetModel.fromJson(e))
          .firstWhere((b) => b.month == month && b.year == year);
    } catch (_) {
      return null;
    }
  }
}
