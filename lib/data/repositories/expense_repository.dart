import 'package:uuid/uuid.dart';
import '../model/expense_model.dart';
import '../provider/hive/hive_service.dart';
import '../provider/firebase/firestore_service.dart';
import '../../app/services/sync_service.dart';
import '../../app/config/global_var.dart';

class ExpenseRepository {
  static String get _userId => Globals.userId.isNotEmpty ? Globals.userId : 'local';

  static Future<void> addExpense({
    required double amount,
    required String category,
    required DateTime date,
    required String paymentMethod,
    required String description,
  }) async {
    final expense = ExpenseModel(
      id: const Uuid().v4(),
      userId: _userId,
      amount: amount,
      category: category,
      date: date,
      paymentMethod: paymentMethod,
      description: description,
      isSynced: false,
      createdAt: DateTime.now(),
    );
    await HiveService.saveExpense(expense);
    if (SyncService.isOnline) {
      try {
        await FirestoreService.uploadExpense(_userId, expense);
        await HiveService.saveExpense(expense.copyWith(isSynced: true));
      } catch (_) {}
    }
  }

  static Future<void> updateExpense(ExpenseModel expense) async {
    final updated = expense.copyWith(isSynced: false);
    await HiveService.saveExpense(updated);
    if (SyncService.isOnline) {
      try {
        await FirestoreService.uploadExpense(_userId, updated);
        await HiveService.saveExpense(updated.copyWith(isSynced: true));
      } catch (_) {}
    }
  }

  static Future<void> deleteExpense(String id) async {
    await HiveService.deleteExpense(id);
    if (SyncService.isOnline) {
      try {
        await FirestoreService.deleteExpense(_userId, id);
      } catch (_) {}
    }
  }

  static List<ExpenseModel> getAllExpenses() => HiveService.getAllExpenses();

  static List<ExpenseModel> getExpensesByMonth(int month, int year) {
    return HiveService.getAllExpenses()
        .where((e) => e.date.month == month && e.date.year == year)
        .toList();
  }

  static List<ExpenseModel> getExpensesByCategory(String category) {
    return HiveService.getAllExpenses()
        .where((e) => e.category == category)
        .toList();
  }

  static List<ExpenseModel> searchExpenses(String query) {
    final q = query.toLowerCase();
    return HiveService.getAllExpenses()
        .where((e) =>
            e.description.toLowerCase().contains(q) ||
            e.category.toLowerCase().contains(q) ||
            e.paymentMethod.toLowerCase().contains(q))
        .toList();
  }

  static double getTotalExpenses() {
    return HiveService.getAllExpenses().fold(0.0, (sum, e) => sum + e.amount);
  }

  static double getTotalExpensesForMonth(int month, int year) {
    return getExpensesByMonth(month, year)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  static Map<String, double> getCategoryTotals({int? month, int? year}) {
    final expenses = (month != null && year != null)
        ? getExpensesByMonth(month, year)
        : HiveService.getAllExpenses();
    final Map<String, double> totals = {};
    for (final e in expenses) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }
    return totals;
  }
}
