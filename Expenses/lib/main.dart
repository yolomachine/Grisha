import 'dart:collection';

import 'package:Expenses/database_controller.dart';
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

final database = ExpensiveDatabaseController('expensive.db');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Application());
}

class Application extends StatelessWidget {
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

class MainState extends PortraitState<Main> {
  List<Widget> items;
  Map<ExpenseCategory, int> distribution;
  DateTimeRange period;

  @override
  void initState() {
    super.initState();
    items = [];
    distribution = Map<ExpenseCategory, int>();
    period = null;
    _rebuild();
  }

  void _rebuild() async {
    final data = await database.select(period ?? getDefaultTimeRange());
    setState(() {
      items.clear();
      distribution.clear();
      for (var e in data) {
        items.add(ExpenseWidget(e, key: Key("${e.id}")));
        if (!distribution.containsKey(e.expenseCategory)) {
          distribution[e.expenseCategory] = 0;
        }
        distribution[e.expenseCategory] += e.expense.amount;
      }
      var sortedEntries = distribution.entries.toList()..sort((e1, e2) {
        var diff = e1.value.compareTo(e2.value);
        return diff;
      });
      distribution = Map<ExpenseCategory, int>.fromEntries(sortedEntries);
    });
  }

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
            ExpenseSummary(distribution: distribution, period: period ?? getDefaultTimeRange()),
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
          if (result != null && result.success) {
            result.data.id = items.length;
            await database.insert(result.data);
            _rebuild();
          }
        },
        tooltip: 'Добавить',
        child: Icon(Icons.add),
      ),
    );
  }
}
