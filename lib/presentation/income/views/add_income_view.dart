import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/config/app_constants.dart';
import '../../../app/shared_widgets/custom_button.dart';
import '../../../app/shared_widgets/my_text.dart';
import '../../../app/shared_widgets/textfield.dart';
import '../controllers/income_controller.dart';

class AddIncomeView extends GetView<IncomeController> {
  const AddIncomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.editingIncome != null;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: Get.back,
          child: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20),
        ),
        title: MyText(
          title: isEditing ? 'Edit Income' : 'Add Income',
          size: 16,
          weight: FontWeight.w700,
          clr: AppColors.black,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Amount (Rs)'),
              const SizedBox(height: 6),
              InputTextField(
                controller: controller.amountCtrl,
                hint: 'e.g. 50000',
                textInputType: TextInputType.number,
                inputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                validation: (v) => (v == null || v.isEmpty) ? 'Enter amount' : null,
              ),
              const SizedBox(height: 16),
              _label('Source'),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.inputBorder),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedSource.value,
                    isExpanded: true,
                    items: AppConstants.incomeSources
                        .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (v) => controller.selectedSource.value = v!,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _label('Date'),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => controller.pickDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.inputBorder),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        title: DateFormat('d MMM yyyy').format(controller.selectedDate.value),
                        size: 13,
                        weight: FontWeight.w400,
                        clr: AppColors.black,
                      ),
                      const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.greyText),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _label('Description (optional)'),
              const SizedBox(height: 6),
              InputTextField(
                controller: controller.descriptionCtrl,
                hint: 'e.g. Monthly salary',
                maxLines: 2,
              ),
              const SizedBox(height: 32),
              Obx(() => CustomButton(
                text: controller.isSaving.value
                    ? 'Saving...'
                    : isEditing ? 'Update Income' : 'Add Income',
                onPress: controller.isSaving.value ? null : controller.saveIncome,
                textColor: AppColors.white,
                boxColor: AppColors.primary,
                isCupertinoIndicator: controller.isSaving.value,
              )),
            ],
          )),
        ),
      ),
    );
  }

  Widget _label(String text) =>
      MyText(title: text, size: 13, weight: FontWeight.w600, clr: AppColors.black);
}
