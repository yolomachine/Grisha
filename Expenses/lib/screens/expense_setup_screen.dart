import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../shared.dart';

class ExpenseSetupScreen extends StatefulWidget {
  final ExpenseData data;

  ExpenseSetupScreen({this.data});

  @override
  _ExpenseSetupScreenState createState() => _ExpenseSetupScreenState();
}

class _ExpenseSetupScreenState extends State<ExpenseSetupScreen> {
  ExpenseData mutableData;
  bool isEditing;

  @override
  void initState() {
    super.initState();
    isEditing = widget.data != null;
    mutableData = widget.data;
    if (mutableData == null) {
      mutableData = ExpenseData(Expense.only(date: DateTime.now()), ExpenseCategories.Other);
    }
  }

  bool _canShowConfirmationButton() {
    return
      MediaQuery.of(context).viewInsets.bottom == 0.0 &&
      mutableData.expense.description != null && mutableData.expense.description.length > 0 &&
      mutableData.expense.amount != null && mutableData.expense.amount > 0 &&
      mutableData.expense.date != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать' : 'Создать')
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FocusableTextField(
                icon: Icon(Icons.description),
                onSubmitted: (value) => setState(() { mutableData.expense.description = value; }),
                labelText: 'Описание',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FocusableTextField(
                icon: Icon(Icons.account_balance),
                onSubmitted: (value) => setState(() { mutableData.expense.amount = double.parse(value); }),
                labelText: 'Сумма',
                suffixText: currencySymbol,
                textInputType: TextInputType.number,
                formatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(16),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DateTimeTextField(
                  onSubmitted: (value) => setState(() { mutableData.expense.date = value; })
              )
            )
          ],
        ),
      ),
      floatingActionButton:
        _canShowConfirmationButton() ?
        FloatingActionButton(
          onPressed: () {
            Navigator.pop(context, mutableData);
          },
          tooltip: 'Создать',
          child:  Icon(Icons.check),
        ) :
        null,
    );
  }
}