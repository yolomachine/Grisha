import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../shared.dart';

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