import 'package:Expenses/screens/expense_setup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';

import '../shared.dart';
import 'expense_category_icon.dart';
import 'focused_menu_holder.dart';

class ExpenseWidget extends StatefulWidget {
  final ExpenseData expenseData;
  final Future<void> Function(ExpenseData) editStateCallback;
  final Future<void> Function(ExpenseData) deleteStateCallback;

  ExpenseWidget(this.expenseData, {Key key, this.editStateCallback, this.deleteStateCallback}) : super(key: key);

  @override
  ExpenseWidgetState createState() => ExpenseWidgetState(expenseData, editStateCallback, deleteStateCallback);
}

class ExpenseWidgetState extends State<ExpenseWidget> {
  ExpenseData expenseData;
  final Future<void> Function(ExpenseData) editStateCallback;
  final Future<void> Function(ExpenseData) deleteStateCallback;

  ExpenseWidgetState(this.expenseData, this.editStateCallback, this.deleteStateCallback);

  void _showAlertDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Отменить"),
      onPressed:  () async { Navigator.pop(context); },
    );
    Widget continueButton = FlatButton(
      child: Text("Да", style: TextStyle(color: Colors.redAccent)),
      onPressed: () async {
        await deleteStateCallback(expenseData);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: Text("Вы действительно хотите удалить эту запись?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: FocusedMenuHolder(
        menuWidth: MediaQuery.of(context).size.width,
        blurSize: 4.0,
        menuItemExtent: 45,
        menuBoxDecoration: BoxDecoration(color: Colors.white),
        duration: Duration(milliseconds: 100),
        animateMenuItems: true,
        menuOffset: -1,
        blurBackgroundColor: Colors.white54,
        bottomOffsetHeight: 100,
        menuItems: <FocusedMenuItem>[
          FocusedMenuItem(
            title: Text("Редактировать"),
            trailingIcon: Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExpenseSetupScreen(data: expenseData))
              );
              if (result != null && result.success && !expenseData.equals(result.data)) {
                await editStateCallback(result.data);
              }
            }
          ),
          FocusedMenuItem(
            title: Text("Удалить", style: TextStyle(color: Colors.redAccent)),
            trailingIcon: Icon(Icons.delete,color: Colors.redAccent),
            onPressed: () => _showAlertDialog(context)
          ),
        ],
        onPressed: (){},
        child: Container(
          color: Colors.white.withOpacity(0.001),
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
      ),
    );
  }
}
