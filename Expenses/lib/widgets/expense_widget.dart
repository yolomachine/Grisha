import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../shared.dart';
import 'expense_category_icon.dart';

class ExpenseWidget extends StatefulWidget {
  final Expense expense;
  final ExpenseCategory expenseCategory;
  final dateFormatter = DateFormat('dd MMM yyyy', Intl.defaultLocale);
  final currencyFormatter = NumberFormat('#,##0.00 ₽', Intl.defaultLocale);

  ExpenseWidget({
    Key key,
    @required this.expense,
    @required this.expenseCategory
  }) : super(key: key);

  @override
  ExpenseWidgetState createState() => ExpenseWidgetState(expense, expenseCategory);
}

class ExpenseWidgetState extends State<ExpenseWidget> {
  Expense expense;
  ExpenseCategory expenseCategory;

  ExpenseWidgetState(this.expense, this.expenseCategory);

  void _edit() => setState(() => 0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ExpenseCategoryIcon(expenseCategory, size: Vector2.all(50.0)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    widget.dateFormatter.format(expense.date.toLocal()),
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    expense.description,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    widget.currencyFormatter.format(expense.amount),
                    style: TextStyle(
                      fontSize: 25.0,
                      color: expenseCategory.color
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
