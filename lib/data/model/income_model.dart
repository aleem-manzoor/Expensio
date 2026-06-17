import 'dart:convert';

class IncomeModel {
  final String id;
  final String userId;
  final double amount;
  final String source;
  final DateTime date;
  final String description;
  final bool isSynced;
  final DateTime createdAt;

  IncomeModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.source,
    required this.date,
    required this.description,
    this.isSynced = false,
    required this.createdAt,
  });

  IncomeModel copyWith({
    String? id,
    String? userId,
    double? amount,
    String? source,
    DateTime? date,
    String? description,
    bool? isSynced,
    DateTime? createdAt,
  }) {
    return IncomeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      source: source ?? this.source,
      date: date ?? this.date,
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
      'source': source,
      'date': date.toIso8601String(),
      'description': description,
      'isSynced': isSynced,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory IncomeModel.fromMap(Map<String, dynamic> map) {
    return IncomeModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      source: map['source'] ?? '',
      date: DateTime.parse(map['date']),
      description: map['description'] ?? '',
      isSynced: map['isSynced'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory IncomeModel.fromJson(String source) =>
      IncomeModel.fromMap(json.decode(source));

  Map<String, dynamic> toFirestore() {
    final map = toMap();
    map.remove('isSynced');
    return map;
  }
}
