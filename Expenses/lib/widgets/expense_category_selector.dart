import 'package:flutter/material.dart';

import '../shared.dart';
import 'expense_category_icon.dart';

class ExpenseCategorySelector extends StatefulWidget {
  final ExpenseCategory expenseCategory;
  final ExpenseCategory Function() currentSelectionGetter;
  final void Function(ExpenseCategory) currentSelectionSetter;

  ExpenseCategorySelector({
    Key key,
    @required this.expenseCategory,
    @required this.currentSelectionGetter,
    @required this.currentSelectionSetter
  }) : super(key: key);

  @override
  ExpenseCategorySelectorState createState() => ExpenseCategorySelectorState(
    expenseCategory,
    currentSelectionGetter,
    currentSelectionSetter
  );
}

class ExpenseCategorySelectorState extends State<ExpenseCategorySelector> {
  final ExpenseCategory expenseCategory;
  final ExpenseCategory Function() currentSelectionGetter;
  final void Function(ExpenseCategory) currentSelectionSetter;

  ExpenseCategorySelectorState(
    this.expenseCategory,
    this.currentSelectionGetter,
    this.currentSelectionSetter
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        currentSelectionSetter(expenseCategory);
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ExpenseCategoryIcon(expenseCategory, size: Vector2.all(50.0)),
          ),
          Expanded(
            child: Container(
              height: 80,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        expenseCategory.name,
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: expenseCategory == currentSelectionGetter() ? Icon(Icons.check) : null),
        ],
      ),
    );
  }
}
