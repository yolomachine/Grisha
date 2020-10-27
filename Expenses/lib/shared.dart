import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final currencySymbol = '₽';
final dateFormatter = DateFormat('dd MMM yyyy', Intl.defaultLocale);
final monthFormatter = DateFormat('MMMM', Intl.defaultLocale);
final currencyFormatter = NumberFormat.currency(locale: Intl.defaultLocale, symbol: currencySymbol, decimalDigits: 0);

class DisableOverscrollRendering extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection
  ) {
    return child;
  }
}

class FocusableTextField extends StatefulWidget {
  final Icon icon;
  final void Function(String) onSubmitted;
  final String labelText;
  final String suffixText;
  final TextInputType textInputType;
  final List<TextInputFormatter> formatters;

  const FocusableTextField({
    Key key,
    this.icon,
    this.onSubmitted,
    this.labelText,
    this.suffixText,
    this.textInputType,
    this.formatters
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => FocusableTextFieldState(
      this.icon,
      this.onSubmitted,
      this.labelText,
      this.suffixText,
      this.textInputType,
      this.formatters
  );
}

class FocusableTextFieldState extends State<FocusableTextField> {
  FocusNode _focusNode;

  Icon icon;
  void Function(String) onSubmitted;
  String labelText;
  String suffixText;
  TextInputType textInputType;
  List<TextInputFormatter> formatters;

  FocusableTextFieldState(
      this.icon,
      this.onSubmitted,
      this.labelText,
      this.suffixText,
      this.textInputType,
      this.formatters
      );

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _requestFocus(){
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      onTap: _requestFocus,
      onSubmitted: onSubmitted,
      onChanged: onSubmitted,
      style: TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        icon: icon,
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 20,
          color: _focusNode.hasFocus ? Colors.black : Colors.grey,
        ),
        suffixText: suffixText,
      ),
      keyboardType: textInputType,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: formatters,
    );
  }
}

class DateTimeTextField extends StatefulWidget {
  final void Function(DateTime) onSubmitted;

  const DateTimeTextField({Key key, this.onSubmitted}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DateTimeTextFieldState(this.onSubmitted);
}

class DateTimeTextFieldState extends State<DateTimeTextField> {
  void Function(DateTime) onSubmitted;
  DateTime selectedDate;
  TextEditingController _date;

  DateTimeTextFieldState(this.onSubmitted);

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    _date = TextEditingController();
    _date.value = TextEditingValue(text: dateFormatter.format(selectedDate));
  }

  _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100)
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _date.value = TextEditingValue(text: dateFormatter.format(picked));
        onSubmitted(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await _selectDate(context),
      child: AbsorbPointer(
        child: TextField(
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            icon: Icon(Icons.calendar_today),
            labelText: 'Дата',
            labelStyle: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          controller: _date,
          keyboardType: TextInputType.datetime,
        ),
      ),
    );
  }
}

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

  Expense.surrogate({@required this.amount});
  Expense.only({this.description, this.amount, this.date});
  Expense(this.description, this.amount, this.date);
}

class ExpenseCategory {
  final Color color;
  final String name;
  final String assetImagePath;

  const ExpenseCategory._(this.color, this.name, this.assetImagePath);
}

class ExpenseData {
  Expense expense;
  ExpenseCategory expenseCategory;

  ExpenseData(this.expense, this.expenseCategory);
}

class ExpenseCategories {
  static const Bills         = const ExpenseCategory._(Color.fromARGB(255, 255, 192, 72), 'Bills',         'data/icons/bills.svg');
  static const EatingOut     = const ExpenseCategory._(Color.fromARGB(255, 87, 95, 207),  'Eating out',    'data/icons/eatingout.svg');
  static const Entertainment = const ExpenseCategory._(Color.fromARGB(255, 239, 87, 119), 'Entertainment', 'data/icons/entertainment.svg');
  static const Fuel          = const ExpenseCategory._(Color.fromARGB(255, 72, 84, 96),   'Fuel',          'data/icons/fuel.svg');
  static const Groceries     = const ExpenseCategory._(Color.fromARGB(255, 55, 232, 129), 'Groceries',     'data/icons/groceries.svg');
  static const HealthCare    = const ExpenseCategory._(Color.fromARGB(255, 255, 94, 57),  'Health care',   'data/icons/healthcare.svg');
  static const Other         = const ExpenseCategory._(Color.fromARGB(255, 52, 171, 228), 'Other',         'data/icons/other.svg');
}