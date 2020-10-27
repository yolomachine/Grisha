import 'dart:collection';
import 'dart:developer';

import 'package:Expenses/screens/expense_setup_screen.dart';
import 'package:Expenses/widgets/expense_list_view.dart';
import 'package:Expenses/widgets/expense_summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'shared.dart';
import 'widgets/expense_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = "ru";
    initializeDateFormatting();
    GestureBinding.instance.resamplingEnabled = true;
    return MaterialApp(
      title: 'Expenses',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Main(title: 'Расходы'),
    );
  }
}

class Main extends StatefulWidget {
  Main({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MainState createState() => MainState();
}

class MainState extends State<Main> {
  List<Widget> items = [];
  HashMap distribution = HashMap<ExpenseCategory, double>();
  DateTimeRange period = DateTimeRange(start: DateTime.now(), end: DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExpenseSummary(distribution: distribution, period: period),
            ExpenseListView(items: items)
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExpenseSetupScreen())
          );
          if (result != null) {
            setState(() {
              if (!distribution.containsKey(result.expenseCategory)) {
                distribution[result.expenseCategory] = 0.0;
              }
              distribution[result.expenseCategory] += result.expense.amount;
              items.add(ExpenseWidget(result));
            });
          }
        },
        tooltip: 'Добавить',
        child: Icon(Icons.add),
      ),
    );
  }
}
