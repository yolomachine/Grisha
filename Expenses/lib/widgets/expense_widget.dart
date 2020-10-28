import 'package:Expenses/screens/expense_setup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared.dart';
import 'expense_category_icon.dart';

class ExpenseWidget extends StatefulWidget {
  final ExpenseData expenseData;

  ExpenseWidget(this.expenseData, {Key key}) : super(key: key);

  @override
  ExpenseWidgetState createState() => ExpenseWidgetState(expenseData);
}

class ExpenseWidgetState extends State<ExpenseWidget> {
  ExpenseData expenseData;

  ExpenseWidgetState(this.expenseData);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: InkWell(
        onLongPress: () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExpenseSetupScreen(data: expenseData))
          );
          if (result != null && result.success && !expenseData.equals(result.data)) {
            setState(() {
              expenseData = result.data;
            });
          }
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ExpenseCategoryIcon(expenseData.expenseCategory, size: Vector2.all(50.0)),
            ),
            Flexible(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          dateFormatter.format(expenseData.expense.date.toLocal()),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          expenseData.expense.description,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          currencyFormatter.format(expenseData.expense.amount),
                          overflow: TextOverflow.ellipsis,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
