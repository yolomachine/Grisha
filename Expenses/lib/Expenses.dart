import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Vector2 {
  double x;
  double y;

  Vector2(this.x, this.y);
  Vector2.all(double v) {
    this.x = v;
    this.y = v;
  }
}

class Expense {
  String description;
  double amount;
  DateTime date;

  Expense(this.description, this.amount, this.date);
}

class ExpenseCategory {
  final Color color;
  final String name;
  final String assetImagePath;

  const ExpenseCategory._(this.color, this.name, this.assetImagePath);
}

class ExpenseCategories {
  static const Bills         = const ExpenseCategory._(Color.fromARGB(255, 255, 192, 72), 'Bills',         'data/icons/bills.svg');
  static const EatingOut     = const ExpenseCategory._(Color.fromARGB(255, 87, 95, 207),  'Eating out',    'data/icons/eatingout.svg');
  static const Entertainment = const ExpenseCategory._(Color.fromARGB(255, 239, 87, 119), 'Entertainment', 'data/icons/entertainment.svg');
  static const Fuel          = const ExpenseCategory._(Color.fromARGB(255, 72, 84, 96),   'Fuel',          'data/icons/fuel.svg');
  static const Groceries     = const ExpenseCategory._(Color.fromARGB(255, 55, 232, 129), 'Groceries',     'data/icons/groceries.svg');
  static const HealthCare    = const ExpenseCategory._(Color.fromARGB(255, 255, 94, 57),  'Health care',   'data/icons/healthcare.svg');
  static const Other         = const ExpenseCategory._(Color.fromARGB(255, 52, 231, 228), 'Other',         'data/icons/other.svg');
}

class ExpenseCategoryIcon extends StatelessWidget {
  final Vector2 size;
  final ExpenseCategory expenseCategory;

  const ExpenseCategoryIcon(this.expenseCategory, {Key key, @required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(),
      width: size.x,
      height: size.y,
      decoration: BoxDecoration(
          color: expenseCategory.color,
          shape: BoxShape.circle,
          border: Border.all(color: expenseCategory.color, width: 2),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black.withOpacity(.5),
                offset: const Offset(1.0, 1.0),
                blurRadius: 3.0
            )
          ]),
      padding: EdgeInsets.symmetric(vertical: size.y * .15, horizontal: size.x * .15),
      child: Center(
        child: SvgPicture.asset(
          expenseCategory.assetImagePath,
          color: Colors.white,
          width: size.x,
          height: size.y,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class ExpenseWidget extends StatefulWidget {
  final Expense expense;
  final ExpenseCategory expenseCategory;
  final dateFormatter = DateFormat('dd MMM yyyy');
  final currencyFormatter = NumberFormat('#,##0.00 ₽', 'ru_RU');

  ExpenseWidget({
    Key key,
    @required this.expense,
    @required this.expenseCategory
  }) : super(key: key);

  @override
  ExpenseWidgetState createState() => ExpenseWidgetState(expense, expenseCategory);
}

class ExpenseWidgetState extends State<ExpenseWidget> {
  Expense expense;
  ExpenseCategory expenseCategory;

  ExpenseWidgetState(this.expense, this.expenseCategory);

  void _edit() => setState(() => 0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ExpenseCategoryIcon(expenseCategory, size: Vector2.all(50.0)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    widget.dateFormatter.format(expense.date.toLocal()),
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    expense.description,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    widget.currencyFormatter.format(expense.amount),
                    style: TextStyle(
                      fontSize: 25.0,
                      color: expenseCategory.color
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
