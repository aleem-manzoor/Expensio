import 'dart:convert';

class BudgetModel {
  final String id;
  final String userId;
  final double totalBudget;
  final Map<String, double> categoryBudgets;
  final int month;
  final int year;
  final bool isSynced;
  final DateTime createdAt;

  BudgetModel({
    required this.id,
    required this.userId,
    required this.totalBudget,
    required this.categoryBudgets,
    required this.month,
    required this.year,
    this.isSynced = false,
    required this.createdAt,
  });

  BudgetModel copyWith({
    String? id,
    String? userId,
    double? totalBudget,
    Map<String, double>? categoryBudgets,
    int? month,
    int? year,
    bool? isSynced,
    DateTime? createdAt,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalBudget: totalBudget ?? this.totalBudget,
      categoryBudgets: categoryBudgets ?? this.categoryBudgets,
      month: month ?? this.month,
      year: year ?? this.year,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'totalBudget': totalBudget,
      'categoryBudgets': categoryBudgets,
      'month': month,
      'year': year,
      'isSynced': isSynced,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      totalBudget: (map['totalBudget'] ?? 0.0).toDouble(),
      categoryBudgets: Map<String, double>.from(
        (map['categoryBudgets'] as Map? ?? {}).map(
          (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
        ),
      ),
      month: map['month'] ?? 1,
      year: map['year'] ?? DateTime.now().year,
      isSynced: map['isSynced'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetModel.fromJson(String source) =>
      BudgetModel.fromMap(json.decode(source));

  Map<String, dynamic> toFirestore() {
    final map = toMap();
    map.remove('isSynced');
    return map;
  }
}
