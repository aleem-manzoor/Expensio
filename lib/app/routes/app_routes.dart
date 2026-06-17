part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const OTP = _Paths.OTP;
  static const NEW_PASSWORD = _Paths.NEW_PASSWORD;
  static const COMPLETE_PROFILE = _Paths.COMPLETE_PROFILE;
  static const SIGNUP = _Paths.SIGNUP;
  static const MAIN = _Paths.MAIN;
  static const ADD_EXPENSE = _Paths.ADD_EXPENSE;
  static const EDIT_EXPENSE = _Paths.EDIT_EXPENSE;
  static const ADD_INCOME = _Paths.ADD_INCOME;
  static const EDIT_INCOME = _Paths.EDIT_INCOME;
  static const ADD_BUDGET = _Paths.ADD_BUDGET;
  static const SEARCH = _Paths.SEARCH;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const OTP = '/otp';
  static const NEW_PASSWORD = '/new-password';
  static const COMPLETE_PROFILE = '/complete-profile';
  static const SIGNUP = '/signup';
  static const MAIN = '/main';
  static const ADD_EXPENSE = '/add-expense';
  static const EDIT_EXPENSE = '/edit-expense';
  static const ADD_INCOME = '/add-income';
  static const EDIT_INCOME = '/edit-income';
  static const ADD_BUDGET = '/add-budget';
  static const SEARCH = '/search';
}
