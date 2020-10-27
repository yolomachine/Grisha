import 'package:Expenses/widgets/expense_chart_widget.dart';
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

  void _addExpense() {
    setState(() {
      var e = ExpenseData(
          Expense("Nintendo Switch", 30932.560, DateTime.now()),
          ExpenseCategories.Entertainment
      );
      items.add(ExpenseWidget(e));
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
            Container(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('MMMM', Intl.defaultLocale).format(DateTime.now().toLocal()),
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        SizedBox(
                            width: 250,
                            height: 250,
                            child: ExpenseChartWidget([])
                        ),
                        Text(
                          currencyFormatter.format(213687),
                          style: TextStyle(fontSize: 35),
                        )
                      ],
                    ),
                  ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: DisableOverscrollRendering(),
                child: ListView.separated(
                itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    Widget container = Container(
                      height: 80,
                      child: Center(
                          child: items[index]
                      ),
                    );
                    if (index == 0) {
                      container = Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: container
                      );
                    }
                    return container;
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                )
              )
            )
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        tooltip: 'Добавить',
        child: Icon(Icons.add),
      ),
    );
  }
}
