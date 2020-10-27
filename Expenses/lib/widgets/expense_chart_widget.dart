import 'package:Expenses/shared.dart';
import 'package:Expenses/widgets/expense_category_icon.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

class ExpenseChartWidget extends StatelessWidget {
  final List<ExpenseData> expenses;
  final bool animate;

  ExpenseChartWidget(this.expenses, {this.animate});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      _capture(expenses),
      animate: animate,
      defaultRenderer: ArcRendererConfig(
        arcWidth: 35,
      ),
    );
  }

  _capture(List<ExpenseData> data) {
    return [
      Series<ExpenseData, ExpenseCategory>(
        id: 'Expenses',
        domainFn: (ExpenseData datum, _) => datum.expenseCategory,
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