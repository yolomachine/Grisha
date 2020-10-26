import 'package:Expenses/Expenses.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses Tracker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Main(title: 'Expenses'),
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
  List<ExpenseCategoryIcon> icons = [];

  void _addExpense() {
    setState(() {
      icons.add(ExpenseCategoryIcon(
          ExpenseCategories.Entertainment,
          Vector2.both(100)
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: icons,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
