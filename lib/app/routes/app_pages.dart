import 'package:get/get.dart';

import '../../presentation/auth/forgot_password/bindings/forgot_password_binding.dart';
import '../../presentation/auth/forgot_password/views/forgot_password_view.dart';
import '../../presentation/auth/login/bindings/login_binding.dart';
import '../../presentation/auth/login/views/login_view.dart';
import '../../presentation/auth/new_password/bindings/new_password_binding.dart';
import '../../presentation/auth/new_password/views/new_password_view.dart';
import '../../presentation/auth/otp/bindings/otp_binding.dart';
import '../../presentation/auth/otp/views/otp_view.dart';
import '../../presentation/auth/signup/bindings/signup_binding.dart';
import '../../presentation/auth/signup/views/signup_view.dart';
import '../../presentation/main/bindings/main_binding.dart';
import '../../presentation/main/views/main_view.dart';
import '../../presentation/splash/bindings/splash_binding.dart';
import '../../presentation/splash/views/splash_view.dart';
import '../../presentation/expense/bindings/expense_binding.dart';
import '../../presentation/expense/views/add_expense_view.dart';
import '../../presentation/income/bindings/income_binding.dart';
import '../../presentation/income/views/add_income_view.dart';
import '../../presentation/budget/bindings/budget_binding.dart';
import '../../presentation/budget/views/add_budget_view.dart';
import '../../presentation/search/bindings/search_binding.dart';
import '../../presentation/search/views/search_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: _Paths.SPLASH, page: () => const SplashView(), binding: SplashBinding()),
    GetPage(name: _Paths.LOGIN, page: () => const LoginView(), binding: LoginBinding()),
    GetPage(name: _Paths.FORGOT_PASSWORD, page: () => const ForgotPasswordView(), binding: ForgotPasswordBinding()),
    GetPage(name: _Paths.OTP, page: () => const OtpView(), binding: OtpBinding()),
    GetPage(name: _Paths.NEW_PASSWORD, page: () => const NewPasswordView(), binding: NewPasswordBinding()),
    GetPage(name: _Paths.SIGNUP, page: () => const SignupView(), binding: SignupBinding()),
    GetPage(name: _Paths.MAIN, page: () => const MainView(), binding: MainBinding()),
    GetPage(name: _Paths.ADD_EXPENSE, page: () => const AddExpenseView(), binding: ExpenseBinding()),
    GetPage(name: _Paths.EDIT_EXPENSE, page: () => const AddExpenseView(), binding: ExpenseBinding()),
    GetPage(name: _Paths.ADD_INCOME, page: () => const AddIncomeView(), binding: IncomeBinding()),
    GetPage(name: _Paths.EDIT_INCOME, page: () => const AddIncomeView(), binding: IncomeBinding()),
    GetPage(name: _Paths.ADD_BUDGET, page: () => const AddBudgetView(), binding: BudgetBinding()),
    GetPage(name: _Paths.SEARCH, page: () => const SearchView(), binding: SearchBinding()),
  ];
}
