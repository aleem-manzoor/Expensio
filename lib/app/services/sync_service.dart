import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../../data/provider/firebase/firestore_service.dart';
import '../../data/provider/hive/hive_service.dart';
import 'connectivity_service.dart';

class SyncService {
  static String _userId = '';

  static void init(String userId) {
    _userId = userId;
    final connectivity = Get.find<CheckConnectivity>();
    ever(connectivity.connectionStatus, (status) {
      if (status != ConnectivityResult.none) {
        syncAll();
      }
    });
  }

  static Future<void> syncAll() async {
    if (_userId.isEmpty) return;
    await Future.wait([
      _syncExpenses(),
      _syncIncomes(),
      _syncBudgets(),
    ]);
  }

  static Future<void> _syncExpenses() async {
    final unsynced = HiveService.getUnsyncedExpenses();
    for (final expense in unsynced) {
      try {
        await FirestoreService.uploadExpense(_userId, expense);
        final synced = expense.copyWith(isSynced: true);
        await HiveService.saveExpense(synced);
      } catch (_) {}
    }
  }

  static Future<void> _syncIncomes() async {
    final unsynced = HiveService.getUnsyncedIncomes();
    for (final income in unsynced) {
      try {
        await FirestoreService.uploadIncome(_userId, income);
        final synced = income.copyWith(isSynced: true);
        await HiveService.saveIncome(synced);
      } catch (_) {}
    }
  }

  static Future<void> _syncBudgets() async {
    final unsynced = HiveService.getUnsyncedBudgets();
    for (final budget in unsynced) {
      try {
        await FirestoreService.uploadBudget(_userId, budget);
        final synced = budget.copyWith(isSynced: true);
        await HiveService.saveBudget(synced);
      } catch (_) {}
    }
  }

  static bool get isOnline {
    try {
      final connectivity = Get.find<CheckConnectivity>();
      return connectivity.connectionStatus.value != ConnectivityResult.none;
    } catch (_) {
      return false;
    }
  }
}
