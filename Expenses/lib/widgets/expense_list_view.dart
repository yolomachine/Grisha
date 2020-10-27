import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared.dart';

class ExpenseListView extends StatelessWidget {
  final List<Widget> items;

  const ExpenseListView({Key key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScrollConfiguration(
        behavior: DisableOverscrollRendering(),
        child: ListView.separated(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            Widget container = Container(
              height: 80,
              child: Center(child: items[index]),
            );
            if (index == 0) {
              container = Padding(padding: EdgeInsets.only(top: 20), child: container);
            }
            return container;
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ),
      ),
    );
  }
}
