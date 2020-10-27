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

  void _addExpense() {
    setState(() {
      items.add(ExpenseWidget(
          expense: Expense("Nintendo Switch", 30932.560, DateTime.now()),
          expenseCategory: ExpenseCategories.Entertainment
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
      Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: ListView.separated(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 80,
              child: Center(
                  child: items[index]
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        tooltip: 'Добавить',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
