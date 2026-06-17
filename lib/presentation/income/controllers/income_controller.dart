import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/utils/utils.dart';
import '../../../data/model/income_model.dart';
import '../../../data/repositories/income_repository.dart';

class IncomeController extends GetxController {
  RxList<IncomeModel> incomes = <IncomeModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isSaving = false.obs;

  final amountCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RxString selectedSource = 'Salary'.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;

  IncomeModel? editingIncome;

  @override
  void onInit() {
    super.onInit();
    loadIncomes();
    final args = Get.arguments;
    if (args != null && args is IncomeModel) {
      editingIncome = args;
      amountCtrl.text = args.amount.toString();
      descriptionCtrl.text = args.description;
      selectedSource.value = args.source;
      selectedDate.value = args.date;
    }
  }

  void loadIncomes() {
    isLoading.value = true;
    incomes.value = IncomeRepository.getAllIncomes();
    isLoading.value = false;
  }

  Future<void> saveIncome() async {
    if (!formKey.currentState!.validate()) return;
    isSaving.value = true;
    try {
      if (editingIncome != null) {
        await IncomeRepository.updateIncome(editingIncome!.copyWith(
          amount: double.tryParse(amountCtrl.text) ?? 0,
          source: selectedSource.value,
          date: selectedDate.value,
          description: descriptionCtrl.text,
        ));
      } else {
        await IncomeRepository.addIncome(
          amount: double.tryParse(amountCtrl.text) ?? 0,
          source: selectedSource.value,
          date: selectedDate.value,
          description: descriptionCtrl.text,
        );
      }
      loadIncomes();
      Get.back();
      Utils.showToast(message: editingIncome != null ? 'Income updated' : 'Income added');
    } catch (_) {
      Utils.showToast(message: 'Something went wrong');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteIncome(String id) async {
    await IncomeRepository.deleteIncome(id);
    loadIncomes();
    Utils.showToast(message: 'Income deleted');
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
