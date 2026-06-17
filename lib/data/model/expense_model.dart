import 'dart:convert';

class ExpenseModel {
  final String id;
  final String userId;
  final double amount;
  final String category;
  final DateTime date;
  final String paymentMethod;
  final String description;
  final bool isSynced;
  final DateTime createdAt;

  ExpenseModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.date,
    required this.paymentMethod,
    required this.description,
    this.isSynced = false,
    required this.createdAt,
  });

  ExpenseModel copyWith({
    String? id,
    String? userId,
    double? amount,
    String? category,
    DateTime? date,
    String? paymentMethod,
    String? description,
    bool? isSynced,
    DateTime? createdAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      description: description ?? this.description,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod,
      'description': description,
      'isSynced': isSynced,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      category: map['category'] ?? '',
      date: DateTime.parse(map['date']),
      paymentMethod: map['paymentMethod'] ?? '',
      description: map['description'] ?? '',
      isSynced: map['isSynced'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpenseModel.fromJson(String source) =>
      ExpenseModel.fromMap(json.decode(source));

  Map<String, dynamic> toFirestore() {
    final map = toMap();
    map.remove('isSynced');
    return map;
  }
}
