import 'package:Expenses/widgets/expense_category_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../shared.dart';

class ExpenseSetupScreenResult {
  final ExpenseData data;

  bool success;

  ExpenseSetupScreenResult(this.data, {this.success});
}

class ExpenseSetupScreen extends StatefulWidget {
  final ExpenseData data;
  final DateTime date;

  ExpenseSetupScreen({this.data, this.date});

  @override
  _ExpenseSetupScreenState createState() => _ExpenseSetupScreenState();
}

class _ExpenseSetupScreenState extends PortraitState<ExpenseSetupScreen> {
  ExpenseSetupScreenResult result;
  ExpenseData mutableData;
  bool isEditing;

  @override
  void initState() {
    super.initState();
    isEditing = widget.data != null;
    final now = DateTime.now().toLocal();
    var date = widget.data?.expense?.date ?? ((widget.date.month == now.month) ? now : widget.date);
    mutableData = isEditing ?
      widget.data?.clone() :
      ExpenseData(Expense.only(date: date), null);
    result = ExpenseSetupScreenResult(mutableData, success: true);
  }

  bool _validateData() {
    return
      MediaQuery.of(context).viewInsets.bottom == 0.0 &&
      mutableData.expense != null &&
      mutableData.expense.description != null && mutableData.expense.description.length > 0 &&
      mutableData.expense.amount != null && mutableData.expense.amount > 0 &&
      mutableData.expense.date != null &&
      mutableData.expenseCategory != null;
  }

  Future<bool> _willPopCallback() async {
    FocusScope.of(context).unfocus();
    result.success = false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
            title: Text(isEditing ? 'Редактировать' : 'Создать')
        ),
        body: SizedBox.expand(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: FocusableTextField(
                    value: mutableData.expense.description,
                    icon: Icon(Icons.description),
                    onSubmitted: (value) => setState(() { mutableData.expense.description = value; }),
                    labelText: 'Описание',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: FocusableTextField(
                    value: mutableData.expense.amount,
                    icon: Icon(Icons.account_balance),
                    onSubmitted: (value) => setState(() { mutableData.expense.amount = int.parse(value); }),
                    labelText: 'Сумма',
                    suffixText: currencySymbol,
                    textInputType: TextInputType.number,
                    formatters: <TextInputFormatter>[
                      /// Metablep: Backspace may not work properly https://github.com/flutter/flutter/pull/67892
                      /// Future Flutter releases might contain this fix soon.
                      LengthLimitingTextInputFormatter(7),
                      FilteringTextInputFormatter.deny(RegExp(r"(^0+)|([,.]+)")),
                      FilteringTextInputFormatter.allow(RegExp(r"^[1-9]([0-9]+)?")),
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(20.0),
                    child: DateTimeTextField(
                        value: mutableData.expense.date,
                        onSubmitted: (value) => setState(() { mutableData.expense.date = value; })
                    )
                ),
                Container(
                    padding: const EdgeInsets.only(top: 40, bottom: 30, left: 25),
                    child: Text(
                      'Выбрать категорию',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey
                      ),
                    )
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child:ExpenseCategorySelector(
                    expenseCategory: ExpenseCategories.Bills,
                    currentSelectionGetter: () => mutableData.expenseCategory,
                    currentSelectionSetter: (value) => setState(() { mutableData.expenseCategory = value; }),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child:ExpenseCategorySelector(
                    expenseCategory: ExpenseCategories.EatingOut,
                    currentSelectionGetter: () => mutableData.expenseCategory,
                    currentSelectionSetter: (value) => setState(() { mutableData.expenseCategory = value; }),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child:ExpenseCategorySelector(
                    expenseCategory: ExpenseCategories.Entertainment,
                    currentSelectionGetter: () => mutableData.expenseCategory,
                    currentSelectionSetter: (value) => setState(() { mutableData.expenseCategory = value; }),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child:ExpenseCategorySelector(
                    expenseCategory: ExpenseCategories.Fuel,
                    currentSelectionGetter: () => mutableData.expenseCategory,
                    currentSelectionSetter: (value) => setState(() { mutableData.expenseCategory = value; }),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child:ExpenseCategorySelector(
                    expenseCategory: ExpenseCategories.Groceries,
                    currentSelectionGetter: () => mutableData.expenseCategory,
                    currentSelectionSetter: (value) => setState(() { mutableData.expenseCategory = value; }),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child:ExpenseCategorySelector(
                    expenseCategory: ExpenseCategories.HealthCare,
                    currentSelectionGetter: () => mutableData.expenseCategory,
                    currentSelectionSetter: (value) => setState(() { mutableData.expenseCategory = value; }),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child:ExpenseCategorySelector(
                    expenseCategory: ExpenseCategories.Other,
                    currentSelectionGetter: () => mutableData.expenseCategory,
                    currentSelectionSetter: (value) => setState(() { mutableData.expenseCategory = value; }),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton:
        _validateData() ?
        FloatingActionButton(
          onPressed: () {
            Navigator.pop(context, result);
          },
          tooltip: 'Создать',
          child:  Icon(Icons.check),
        ) :
        null,
      ),
      onWillPop: _willPopCallback,
    );
  }
}