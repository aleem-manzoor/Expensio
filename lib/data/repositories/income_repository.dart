import 'package:uuid/uuid.dart';
import '../model/income_model.dart';
import '../provider/hive/hive_service.dart';
import '../provider/firebase/firestore_service.dart';
import '../../app/services/sync_service.dart';
import '../../app/config/global_var.dart';

class IncomeRepository {
  static String get _userId => Globals.userId.isNotEmpty ? Globals.userId : 'local';

  static Future<void> addIncome({
    required double amount,
    required String source,
    required DateTime date,
    required String description,
  }) async {
    final income = IncomeModel(
      id: const Uuid().v4(),
      userId: _userId,
      amount: amount,
      source: source,
      date: date,
      description: description,
      isSynced: false,
      createdAt: DateTime.now(),
    );
    await HiveService.saveIncome(income);
    if (SyncService.isOnline) {
      try {
        await FirestoreService.uploadIncome(_userId, income);
        await HiveService.saveIncome(income.copyWith(isSynced: true));
      } catch (_) {}
    }
  }

  static Future<void> updateIncome(IncomeModel income) async {
    final updated = income.copyWith(isSynced: false);
    await HiveService.saveIncome(updated);
    if (SyncService.isOnline) {
      try {
        await FirestoreService.uploadIncome(_userId, updated);
        await HiveService.saveIncome(updated.copyWith(isSynced: true));
      } catch (_) {}
    }
  }

  static Future<void> deleteIncome(String id) async {
    await HiveService.deleteIncome(id);
    if (SyncService.isOnline) {
      try {
        await FirestoreService.deleteIncome(_userId, id);
      } catch (_) {}
    }
  }

  static List<IncomeModel> getAllIncomes() =>
      HiveService.getAllIncomes().where((i) => i.userId == _userId).toList();

  static List<IncomeModel> getIncomesByMonth(int month, int year) {
    return HiveService.getAllIncomes()
        .where((i) => i.date.month == month && i.date.year == year)
        .toList();
  }

  static List<IncomeModel> searchIncomes(String query) {
    final q = query.toLowerCase();
    return HiveService.getAllIncomes()
        .where((i) =>
            i.description.toLowerCase().contains(q) ||
            i.source.toLowerCase().contains(q))
        .toList();
  }

  static double getTotalIncome() {
    return HiveService.getAllIncomes().fold(0.0, (sum, i) => sum + i.amount);
  }

  static double getTotalIncomeForMonth(int month, int year) {
    return getIncomesByMonth(month, year)
        .fold(0.0, (sum, i) => sum + i.amount);
  }
}
