import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryDark = Color(0xFF5A4ACE);
  static const Color primaryLight = Color(0xFFEDE9FE);

  // Semantic
  static const Color income = Color(0xFF00B894);
  static const Color incomeLight = Color(0xFFDFFBF5);
  static const Color expense = Color(0xFFFF6B6B);
  static const Color expenseLight = Color(0xFFFFEEEE);
  static const Color savings = Color(0xFF0984E3);
  static const Color warning = Color(0xFFFD9644);

  // Neutrals
  static const Color white = Colors.white;
  static const Color black = Color(0xFF2D3436);
  static const Color greyText = Color(0xFF636E72);
  static const Color lightText = Color(0xFFB2BEC3);
  static const Color lightWhite = Color(0xFFF5F6FA);
  static const Color cardBorder = Color(0xFFF0F0F5);
  static const Color inputBorder = Color(0xFFE8E8F0);
  static const Color trans = Colors.transparent;

  // Legacy aliases (kept for backward compatibility)
  static const Color red = Color(0xFFFF6B6B);
  static const Color grey = Color(0xFFB2BEC3);
  static const Color secondary = Color(0xFF636E72);
  static const Color lightGrey = Color(0xFFDFE6E9);
  static const Color grey6B = Color(0xFF636E72);
  static const Color lightTextColor = Color(0xFFEDE9FE);
  static const Color primary5FF = Color(0xFFEDE9FE);
  static const Color dropShadow = Color(0xFF2D3436);
  static const Color inputfield = Color(0xFFFFFFFF);
  static const Color hint = Color(0xFFB2BEC3);
  static const Color checkColor = Color(0xFF6C5CE7);
  static const Color border = Color(0xFFE8E8F0);
  static const Color containerBackground = Color(0xFF2D1B69);
  static const Color cardColor = Color(0xFF2D3436);
  static const Color progressColor = Color(0xFF00B894);
  static const Color errorColor = Color(0xFFFF6B6B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF2D1B69), Color(0xFF6C5CE7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient incomeGradient = LinearGradient(
    colors: [Color(0xFF00B894), Color(0xFF00CEC9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient expenseGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient welcomeGradient = LinearGradient(
    colors: [Color(0xFF2D1B69), Color(0xFF6C5CE7)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF5A4ACE), Color(0xFF6C5CE7)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient dealGradient = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFFFF6B6B)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
