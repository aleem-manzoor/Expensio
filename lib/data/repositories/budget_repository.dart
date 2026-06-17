import 'package:uuid/uuid.dart';
import '../model/budget_model.dart';
import '../provider/hive/hive_service.dart';
import '../provider/firebase/firestore_service.dart';
import '../../app/services/sync_service.dart';
import '../../app/config/global_var.dart';

class BudgetRepository {
  static String get _userId => Globals.userId.isNotEmpty ? Globals.userId : 'local';

  static Future<void> setBudget({
    required double totalBudget,
    required Map<String, double> categoryBudgets,
    required int month,
    required int year,
  }) async {
    final existing = HiveService.getBudgetForMonth(month, year);
    final budget = BudgetModel(
      id: existing?.id ?? const Uuid().v4(),
      userId: _userId,
      totalBudget: totalBudget,
      categoryBudgets: categoryBudgets,
      month: month,
      year: year,
      isSynced: false,
      createdAt: existing?.createdAt ?? DateTime.now(),
    );
    await HiveService.saveBudget(budget);
    if (SyncService.isOnline) {
      try {
        await FirestoreService.uploadBudget(_userId, budget);
        await HiveService.saveBudget(budget.copyWith(isSynced: true));
      } catch (_) {}
    }
  }

  static Future<void> deleteBudget(String id) async {
    await HiveService.deleteBudget(id);
    if (SyncService.isOnline) {
      try {
        await FirestoreService.deleteBudget(_userId, id);
      } catch (_) {}
    }
  }

  static List<BudgetModel> getAllBudgets() => HiveService.getAllBudgets();

  static BudgetModel? getBudgetForMonth(int month, int year) =>
      HiveService.getBudgetForMonth(month, year);
}
