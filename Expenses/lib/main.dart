import 'package:Expenses/Expenses.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses Tracker',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
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
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
