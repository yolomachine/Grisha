import 'package:flutter/material.dart';

class Vector2 {
  double x;
  double y;

  Vector2(this.x, this.y);
  Vector2.all(double v) {
    this.x = v;
    this.y = v;
  }
}

class Expense {
  String description;
  double amount;
  DateTime date;

  Expense(this.description, this.amount, this.date);
}

class ExpenseCategory {
  final Color color;
  final String name;
  final String assetImagePath;

  const ExpenseCategory._(this.color, this.name, this.assetImagePath);
}

class ExpenseCategories {
  static const Bills         = const ExpenseCategory._(Color.fromARGB(255, 255, 192, 72), 'Bills',         'data/icons/bills.svg');
  static const EatingOut     = const ExpenseCategory._(Color.fromARGB(255, 87, 95, 207),  'Eating out',    'data/icons/eatingout.svg');
  static const Entertainment = const ExpenseCategory._(Color.fromARGB(255, 239, 87, 119), 'Entertainment', 'data/icons/entertainment.svg');
  static const Fuel          = const ExpenseCategory._(Color.fromARGB(255, 72, 84, 96),   'Fuel',          'data/icons/fuel.svg');
  static const Groceries     = const ExpenseCategory._(Color.fromARGB(255, 55, 232, 129), 'Groceries',     'data/icons/groceries.svg');
  static const HealthCare    = const ExpenseCategory._(Color.fromARGB(255, 255, 94, 57),  'Health care',   'data/icons/healthcare.svg');
  static const Other         = const ExpenseCategory._(Color.fromARGB(255, 52, 171, 228), 'Other',         'data/icons/other.svg');
}