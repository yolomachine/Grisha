import 'package:flutter/material.dart';

import '../shared.dart';
import 'expense_category_icon.dart';

class ExpenseWidget extends StatefulWidget {
  final ExpenseData expenseData;

  ExpenseWidget(
    this.expenseData,
    {Key key}
  ) : super(key: key);

  @override
  ExpenseWidgetState createState() => ExpenseWidgetState(expenseData);
}

class ExpenseWidgetState extends State<ExpenseWidget> {
  ExpenseData expenseData;

  ExpenseWidgetState(this.expenseData);

  void _edit() => setState(() => 0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ExpenseCategoryIcon(expenseData.expenseCategory, size: Vector2.all(50.0)),
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
                    dateFormatter.format(expenseData.expense.date.toLocal()),
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
                    expenseData.expense.description,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    currencyFormatter.format(expenseData.expense.amount),
                    style: TextStyle(
                      fontSize: 25.0,
                      color: expenseData.expenseCategory.color
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
