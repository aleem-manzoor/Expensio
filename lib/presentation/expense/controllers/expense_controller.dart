import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/utils/utils.dart';
import '../../../data/model/expense_model.dart';
import '../../../data/repositories/expense_repository.dart';

class ExpenseController extends GetxController {
  RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isSaving = false.obs;

  final amountCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RxString selectedCategory = 'Food & Dining'.obs;
  RxString selectedPayment = 'Cash'.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;

  ExpenseModel? editingExpense;

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
    final args = Get.arguments;
    if (args != null && args is ExpenseModel) {
      editingExpense = args;
      amountCtrl.text = args.amount.toString();
      descriptionCtrl.text = args.description;
      selectedCategory.value = args.category;
      selectedPayment.value = args.paymentMethod;
      selectedDate.value = args.date;
    }
  }

  void loadExpenses() {
    isLoading.value = true;
    expenses.value = ExpenseRepository.getAllExpenses();
    isLoading.value = false;
  }

  Future<void> saveExpense() async {
    if (!formKey.currentState!.validate()) return;
    isSaving.value = true;
    try {
      if (editingExpense != null) {
        await ExpenseRepository.updateExpense(editingExpense!.copyWith(
          amount: double.tryParse(amountCtrl.text) ?? 0,
          category: selectedCategory.value,
          date: selectedDate.value,
          paymentMethod: selectedPayment.value,
          description: descriptionCtrl.text,
        ));
      } else {
        await ExpenseRepository.addExpense(
          amount: double.tryParse(amountCtrl.text) ?? 0,
          category: selectedCategory.value,
          date: selectedDate.value,
          paymentMethod: selectedPayment.value,
          description: descriptionCtrl.text,
        );
      }
      loadExpenses();
      Get.back();
      Utils.showToast(message: editingExpense != null ? 'Expense updated' : 'Expense added');
    } catch (_) {
      Utils.showToast(message: 'Something went wrong');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteExpense(String id) async {
    await ExpenseRepository.deleteExpense(id);
    loadExpenses();
    Utils.showToast(message: 'Expense deleted');
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) selectedDate.value = picked;
  }

  @override
  void onClose() {
    amountCtrl.dispose();
    descriptionCtrl.dispose();
    super.onClose();
  }
}
