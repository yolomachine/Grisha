import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Vector2 {
  double x;
  double y;

  Vector2(this.x, this.y);
  Vector2.both(double v) {
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
  static const Bills         = const ExpenseCategory._(Colors.orangeAccent, 'Bills',         'data/icons/bills.svg');
  static const EatingOut     = const ExpenseCategory._(Colors.indigoAccent, 'Eating out',    'data/icons/eatingout.svg');
  static const Entertainment = const ExpenseCategory._(Colors.purpleAccent, 'Entertainment', 'data/icons/entertainment.svg');
  static const Fuel          = const ExpenseCategory._(Colors.white38,      'Fuel',          'data/icons/fuel.svg');
  static const Groceries     = const ExpenseCategory._(Colors.green,        'Groceries',     'data/icons/groceries.svg');
  static const HealthCare    = const ExpenseCategory._(Colors.red,          'Health care',   'data/icons/healthcare.svg');
  static const Other         = const ExpenseCategory._(Colors.lime,         'Other',         'data/icons/other.svg');
}

class ExpenseCategoryIcon extends StatelessWidget {
  final ExpenseCategory category;
  final Vector2 size;

  const ExpenseCategoryIcon(this.category, this.size, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(),
      width: size.x,
      height: size.y,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: category.color,
          width: 2
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3.0, 3.0),
            blurRadius: 3.0
          )
        ]
      ),
      padding: EdgeInsets.symmetric(
          vertical: size.y * .15,
          horizontal: size.x * .15
      ),
      child: Center(
        child: SvgPicture.asset(
          category.assetImagePath,
          width: size.x,
          height: size.y,
          fit: BoxFit.contain,
        )
      )
    );
  }
}

class ExpenseWidget extends StatefulWidget {
  @override
  ExpenseWidgetState createState() => ExpenseWidgetState();
}

class ExpenseWidgetState extends State<ExpenseWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
