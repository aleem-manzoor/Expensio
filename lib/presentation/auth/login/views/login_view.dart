import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expensio/app/config/app_colors.dart';
import 'package:expensio/app/routes/app_pages.dart';
import 'package:expensio/app/shared_widgets/my_text.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) => Scaffold(
        backgroundColor: AppColors.lightWhite,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildForm(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 70, 28, 40),
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.white, size: 26),
          ),
          const SizedBox(height: 24),
          const Text(
            'Welcome back',
            style: TextStyle(color: AppColors.white, fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Sign in to your Expensio account',
            style: TextStyle(color: AppColors.white.withValues(alpha: 0.75), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(LoginController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Form(
        key: controller.loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Email address'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: controller.emailController,
              hint: 'you@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => !GetUtils.isEmail(v ?? '') ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 20),
            _buildLabel('Password'),
            const SizedBox(height: 8),
            Obx(() => _buildTextField(
              controller: controller.passwordController,
              hint: 'Enter your password',
              icon: Icons.lock_outline_rounded,
              obscure: !controller.showPassword.value,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.showPassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: AppColors.greyText,
                  size: 20,
                ),
                onPressed: () => controller.showPassword.value = !controller.showPassword.value,
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Enter your password' : null,
            )),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: controller.savePassword,
                      onChanged: (v) {
                        controller.savePassword = v!;
                        controller.update();
                      },
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  MyText(title: 'Remember me', size: 12, weight: FontWeight.w500, clr: AppColors.greyText),
                ]),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                  child: MyText(title: 'Forgot password?', size: 12, weight: FontWeight.w600, clr: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Obx(() => _buildLoginButton(controller)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(title: "Don't have an account?  ", size: 13, weight: FontWeight.w400, clr: AppColors.greyText),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.SIGNUP),
                  child: MyText(title: 'Sign up', size: 13, weight: FontWeight.w700, clr: AppColors.primary),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.expense),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.expense, width: 1.5),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildLoginButton(LoginController controller) {
    return GestureDetector(
      onTap: controller.isLoading.value
          ? null
          : () {
              FocusManager.instance.primaryFocus?.unfocus();
              if (controller.loginFormKey.currentState!.validate()) {
                controller.login(
                  controller.emailController.text.trim(),
                  controller.passwordController.text.trim(),
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
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2.5),
                )
              : const Text(
                  'Sign In',
                  style: TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.3),
                ),
        ),
      ),
    );
  }
}
