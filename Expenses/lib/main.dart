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
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    GestureBinding.instance.resamplingEnabled = true;
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("ru", ''),
      ],
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
    final data = await database.select(period ?? getMonthRange(DateTime.now().toLocal()));
    setState(() {
      items.clear();
      distribution.clear();
      for (var e in data) {
        items.add(ExpenseWidget(
          e,
          key: Key("${e.id}+${e.expense.amount}+${e.expense.description}+${e.expense.date}+${e.expenseCategory.name}"),
          editStateCallback: (data) async {
            await database.update(data);
            period = getMonthRange(data.expense.date);
            _rebuild();
          },
          deleteStateCallback: (data) async {
            await database.delete(data);
            period = getMonthRange(data.expense.date);
            _rebuild();
          })
        );
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

  void _pickMonth() async {
    var start = getDefaultTimeRange().start;
    var end = getDefaultTimeRange().end;
    await showMonthPicker(
      context: context,
      firstDate: start,
      lastDate: end,
      initialDate: (period?.start ?? DateTime.now().toLocal()),
    ).then((date) {
      if (date != null) {
        setState(() {
          period = getMonthRange(date);
          _rebuild();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.title),
            Expanded(child: Container()),
            FloatingActionButton(
              onPressed: _pickMonth,
              child: Icon(Icons.calendar_today, color: Colors.white),
              elevation: 0,
              splashColor: Colors.white54,
              hoverColor: Colors.white54,
              focusColor: Colors.white54,
              heroTag: "btn2"
            ),
          ],
        ),

      ),
      body: Center(
        child: items.length > 0 ?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExpenseSummary(distribution: distribution, period: period ?? getMonthRange(DateTime.now().toLocal())),
              ExpenseListView(items: items)
            ]
          ) :
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(monthFormatter.format((period ?? getMonthRange(DateTime.now().toLocal())).end), style: TextStyle(fontSize: 15, color: Colors.grey)),
              Text('Записи о расходах отсутствуют', style: TextStyle(fontSize: 15, color: Colors.grey))
            ],
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExpenseSetupScreen(date: (period?.start ?? DateTime.now().toLocal())))
          );
          if (result != null && result.success) {
            result.data.id = (await database.size() ?? -1) + 1;
            await database.insert(result.data);
            period = getMonthRange(result.data.expense.date);
            _rebuild();
          }
        },
        tooltip: 'Добавить',
        child: Icon(Icons.add),
        heroTag: "btn1"
      ),
    );
  }
}
