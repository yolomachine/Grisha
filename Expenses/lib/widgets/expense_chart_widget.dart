import 'dart:collection';

import 'package:Expenses/shared.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

class ExpenseChartWidget extends StatelessWidget {
  final HashMap<ExpenseCategory, int> expenses;
  final bool animate;

  ExpenseChartWidget(this.expenses, {this.animate});

  @override
  Widget build(BuildContext context) {
    var wrapped = List<ExpenseData>();
    for (var key in expenses.keys) {
      wrapped.add(ExpenseData(Expense.surrogate(amount: expenses[key]), key));
    }
    return PieChart(
      _capture(wrapped),
      animate: animate,
      defaultRenderer: ArcRendererConfig(
        arcWidth: 35,
      ),
    );
  }

  _capture(List<ExpenseData> data) {
    return [
      Series<ExpenseData, String>(
        id: 'Expenses',
        domainFn: (ExpenseData datum, _) => datum.expenseCategory.name,
        measureFn: (ExpenseData datum, _) => datum.expense.amount,
        colorFn: (ExpenseData datum, _) => Color(
            r: datum.expenseCategory.color.red,
            g: datum.expenseCategory.color.green,
            b: datum.expenseCategory.color.blue,
            a: datum.expenseCategory.color.alpha
        ),
        data: data
      )
    ];
  }
}