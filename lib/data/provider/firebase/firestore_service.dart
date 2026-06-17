import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/expense_model.dart';
import '../../model/income_model.dart';
import '../../model/budget_model.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static CollectionReference _expenses(String userId) =>
      _db.collection('users').doc(userId).collection('expenses');

  static CollectionReference _incomes(String userId) =>
      _db.collection('users').doc(userId).collection('incomes');

  static CollectionReference _budgets(String userId) =>
      _db.collection('users').doc(userId).collection('budgets');

  // Expenses
  static Future<void> uploadExpense(String userId, ExpenseModel expense) async {
    await _expenses(userId).doc(expense.id).set(expense.toFirestore());
  }

  static Future<void> deleteExpense(String userId, String expenseId) async {
    await _expenses(userId).doc(expenseId).delete();
  }

  static Future<List<ExpenseModel>> fetchExpenses(String userId) async {
    final snap = await _expenses(userId).get();
    return snap.docs
        .map((d) => ExpenseModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  // Incomes
  static Future<void> uploadIncome(String userId, IncomeModel income) async {
    await _incomes(userId).doc(income.id).set(income.toFirestore());
  }

  static Future<void> deleteIncome(String userId, String incomeId) async {
    await _incomes(userId).doc(incomeId).delete();
  }

  static Future<List<IncomeModel>> fetchIncomes(String userId) async {
    final snap = await _incomes(userId).get();
    return snap.docs
        .map((d) => IncomeModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  // Budgets
  static Future<void> uploadBudget(String userId, BudgetModel budget) async {
    await _budgets(userId).doc(budget.id).set(budget.toFirestore());
  }

  static Future<void> deleteBudget(String userId, String budgetId) async {
    await _budgets(userId).doc(budgetId).delete();
  }

  static Future<List<BudgetModel>> fetchBudgets(String userId) async {
    final snap = await _budgets(userId).get();
    return snap.docs
        .map((d) => BudgetModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }
}
