import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expensio/app/config/app_colors.dart';
import 'package:expensio/app/shared_widgets/my_text.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignupController>(
      init: SignupController(),
      builder: (controller) => Scaffold(
        backgroundColor: AppColors.lightWhite,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildForm(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 60, 28, 32),
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: Get.back,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white, size: 18),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Create account',
            style: TextStyle(color: AppColors.white, fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Start your financial journey today',
            style: TextStyle(color: AppColors.white.withValues(alpha: 0.75), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(SignupController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Form(
        key: controller.loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _buildLabel('First Name'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: controller.firstNameController,
                      hint: 'Muhammad',
                      icon: Icons.person_outline_rounded,
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                  ]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _buildLabel('Last Name'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: controller.lastNameController,
                      hint: 'Aleem',
                      icon: Icons.person_outline_rounded,
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _buildLabel('Email address'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: controller.emailController,
              hint: 'you@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => !GetUtils.isEmail(v ?? '') ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 18),
            _buildLabel('Phone Number'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: controller.phoneController,
              hint: '03xxxxxxxxx',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) => !GetUtils.isPhoneNumber(v ?? '') ? 'Enter a valid phone' : null,
            ),
            const SizedBox(height: 18),
            _buildLabel('Password'),
            const SizedBox(height: 8),
            Obx(() => _buildTextField(
              controller: controller.passwordController,
              hint: 'Min. 8 characters',
              icon: Icons.lock_outline_rounded,
              obscure: !controller.showPassword.value,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.showPassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: AppColors.greyText, size: 20,
                ),
                onPressed: () => controller.showPassword.value = !controller.showPassword.value,
              ),
              validator: (v) => (v == null || v.length < 8) ? 'Min 8 characters' : null,
            )),
            const SizedBox(height: 18),
            _buildLabel('Confirm Password'),
            const SizedBox(height: 8),
            Obx(() => _buildTextField(
              controller: controller.confirmPasswordController,
              hint: 'Re-enter password',
              icon: Icons.lock_outline_rounded,
              obscure: !controller.showConfirmPassword.value,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.showConfirmPassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: AppColors.greyText, size: 20,
                ),
                onPressed: () => controller.showConfirmPassword.value = !controller.showConfirmPassword.value,
              ),
              validator: (v) => v != controller.passwordController.text ? 'Passwords do not match' : null,
            )),
            const SizedBox(height: 32),
            Obx(() => _buildSignupButton(controller)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(title: 'Already have an account?  ', size: 13, weight: FontWeight.w400, clr: AppColors.greyText),
                GestureDetector(
                  onTap: Get.back,
                  child: MyText(title: 'Sign in', size: 13, weight: FontWeight.w700, clr: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) =>
      Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.black));

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: const TextStyle(fontSize: 14, color: AppColors.black, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.lightText),
        prefixIcon: Icon(icon, color: AppColors.greyText, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.inputBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.inputBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.expense)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.expense, width: 1.5)),
      ),
      validator: validator,
    );
  }

  Widget _buildSignupButton(SignupController controller) {
    return GestureDetector(
      onTap: controller.isLoading.value
          ? null
          : () {
              FocusManager.instance.primaryFocus?.unfocus();
              if (controller.loginFormKey.currentState!.validate()) {
                controller.register(
                  email: controller.emailController.text.trim(),
                  firstName: controller.firstNameController.text.trim(),
                  lastName: controller.lastNameController.text.trim(),
                  phoneNumber: controller.phoneController.text.trim(),
                  password: controller.passwordController.text,
                );
              }
            },
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: controller.isLoading.value ? null : AppColors.primaryGradient,
          color: controller.isLoading.value ? AppColors.primaryLight : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: controller.isLoading.value
              ? []
              : [BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Center(
          child: controller.isLoading.value
              ? const SizedBox(
                  width: 22, height: 22,
                  child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2.5),
                )
              : const Text(
                  'Create Account',
                  style: TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.3),
                ),
        ),
      ),
    );
  }
}
