import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final currencySymbol = '₽';
final dateFormatter = DateFormat('dd MMM yyyy', Intl.defaultLocale);
final monthFormatter = DateFormat('MMM yyyy', Intl.defaultLocale);
final currencyFormatter = NumberFormat.currency(locale: Intl.defaultLocale, symbol: currencySymbol, decimalDigits: 0);

DateTime convertDateTime(DateTime date) => DateTime(
  date.year,
  date.month,
  date.day
).toLocal();

DateTimeRange getDefaultTimeRange() => DateTimeRange(
    start: DateTime(1917, 11, 7).toLocal(),
    end: DateTime.now().toLocal()
);

DateTimeRange getMonthRange(DateTime date) {
  var dateUtil = DateUtil();
  final start = DateTime(date.year, date.month, 1);
  final end = start
      .add(Duration(days: dateUtil.daysInMonth(date.month, date.year)))
      .subtract(Duration(seconds: 1));
  return DateTimeRange(start: start, end: end);
}

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

abstract class PortraitState<T extends StatefulWidget> extends State<T> {
  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final selectionIndexFromTheRight = newValue.text.length - newValue.selection.end;
      final f = NumberFormat("#,###");
      final number = int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = f.format(number);
      return newValue = TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight
        ),
      );
    } else {
      return newValue;
    }
  }
}

class FocusableTextField extends StatefulWidget {
  final dynamic value;
  final Icon icon;
  final void Function(String) onSubmitted;
  final String labelText;
  final String suffixText;
  final TextInputType textInputType;
  final List<TextInputFormatter> formatters;

  const FocusableTextField({
    Key key,
    this.value,
    this.icon,
    this.onSubmitted,
    this.labelText,
    this.suffixText,
    this.textInputType,
    this.formatters
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => FocusableTextFieldState(
    this.value,
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
  TextEditingController _controller;

  dynamic value;
  Icon icon;
  void Function(String) onSubmitted;
  String labelText;
  String suffixText;
  TextInputType textInputType;
  List<TextInputFormatter> formatters;

  FocusableTextFieldState(
    this.value,
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
    _controller = TextEditingController.fromValue(TextEditingValue(text: value?.toString() ?? ''));
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
      controller: _controller,
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
  final DateTime value;
  final void Function(DateTime) onSubmitted;

  const DateTimeTextField({
    Key key,
    this.onSubmitted,
    this.value
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => DateTimeTextFieldState(this.onSubmitted, this.value);
}

class DateTimeTextFieldState extends State<DateTimeTextField> {
  DateTime value;
  void Function(DateTime) onSubmitted;
  DateTime selectedDate;
  TextEditingController _date;

  DateTimeTextFieldState(this.onSubmitted, this.value);

  @override
  void initState() {
    super.initState();
    selectedDate = value ?? DateTime.now().toLocal();
    _date = TextEditingController();
    _date.value = TextEditingValue(text: dateFormatter.format(selectedDate));
  }

  _selectDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final defaultTimeRange = getDefaultTimeRange();
    final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: defaultTimeRange.start,
        lastDate: defaultTimeRange.end
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
  int amount;
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
  int id = -1;
  Expense expense;
  ExpenseCategory expenseCategory;

  ExpenseData(this.expense, this.expenseCategory, {this.id});

  ExpenseData clone() => ExpenseData(
    Expense(
      "${expense.description}",
      expense.amount,
      DateTime.fromMillisecondsSinceEpoch(expense.date.millisecondsSinceEpoch)
    ),
    expenseCategory,
    id: id,
  );

  bool equals(ExpenseData other) =>
    expense.description == other.expense.description &&
    expense.amount == other.expense.amount &&
    expense.date == other.expense.date &&
    expenseCategory == other.expenseCategory;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': expenseCategory.name,
      'description': expense.description,
      'amount': expense.amount,
      'date': expense.date.millisecondsSinceEpoch
    };
  }
}

class ExpenseCategories {
  static const Bills         = const ExpenseCategory._(Color.fromARGB(255, 255, 192, 72), 'Коммунальные услуги', 'data/icons/bills.svg');
  static const EatingOut     = const ExpenseCategory._(Color.fromARGB(255, 87, 95, 207),  'Кафе и рестораны',    'data/icons/eatingout.svg');
  static const Entertainment = const ExpenseCategory._(Color.fromARGB(255, 239, 87, 119), 'Развлечения',         'data/icons/entertainment.svg');
  static const Fuel          = const ExpenseCategory._(Color.fromARGB(255, 72, 84, 96),   'Топливо',             'data/icons/fuel.svg');
  static const Groceries     = const ExpenseCategory._(Color.fromARGB(255, 55, 232, 129), 'Бакалея',             'data/icons/groceries.svg');
  static const HealthCare    = const ExpenseCategory._(Color.fromARGB(255, 255, 94, 57),  'Медицинские услуги',  'data/icons/healthcare.svg');
  static const Other         = const ExpenseCategory._(Color.fromARGB(255, 52, 171, 228), 'Прочие расходы',      'data/icons/other.svg');

  static ExpenseCategory determine(String name) {
    final values = [ Bills, EatingOut, Entertainment, Fuel, Groceries, HealthCare, Other ];
    for (var e in values) {
      if (e.name == name) {
        return e;
      }
    }
    throw Exception("Unknown expense category $name");
  }
}