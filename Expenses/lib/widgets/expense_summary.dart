import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared.dart';
import 'expense_chart_widget.dart';


class ExpenseSummary extends StatelessWidget {
  final Map<ExpenseCategory, int> distribution;
  final DateTimeRange period;

  const ExpenseSummary({Key key, @required this.distribution, @required this.period}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dateLabel = monthFormatter.format(period.start);
    if (period.start.month != period.end.month) {
      dateLabel += " - " + monthFormatter.format(period.end);
    }
    var total = 0.0;
    for (final e in distribution.values) {
      total += e;
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              dateLabel,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            SizedBox(width: 250, height: 250, child: ExpenseChartWidget(distribution)),
            Text(
              currencyFormatter.format(total),
              style: TextStyle(fontSize: 35),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
