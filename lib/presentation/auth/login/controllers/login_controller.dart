import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppsc_preparation/app/config/global_var.dart';
import 'package:ppsc_preparation/app/routes/app_pages.dart';
import 'package:ppsc_preparation/app/utils/utils.dart';
import 'package:ppsc_preparation/data/model/user_model.dart';
import 'package:ppsc_preparation/data/provider/firebase/firebase_auth_service.dart';

class LoginController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool showPassword = false.obs;
  RxBool isLoading = false.obs;
  RxBool keepMeSignedIn = false.obs;
  bool savePassword = false;

  Future<void> login(String email, String password) async {
    if (isLoading.value) return;
    isLoading.value = true;
    update();
    try {
      final data = await FirebaseAuthService.signIn(
        email: email,
        password: password,
      );
      Globals.userId = data['uid'] as String;
      Globals.user = UserModel(
        firstName: data['firstName'] as String?,
        lastName: data['lastName'] as String?,
        phoneNumber: data['phone'] as String?,
        email: data['email'] as String?,
      );
      Utils.showToast(message: 'Welcome back!');
      Get.offAllNamed(Routes.MAIN);
    } on FirebaseAuthException catch (e) {
      Utils.showToast(message: _authError(e.code));
    } catch (_) {
      Utils.showToast(message: 'Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  String _authError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Login failed. Please try again.';
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
