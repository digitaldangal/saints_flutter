import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'globals.dart' as G;
import 'db.dart';
import 'main.dart';
import 'saint_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int initialPage = 100000;
  static DateTime initialDate = new DateTime.now();

  PageController _controller = new PageController(initialPage: initialPage);

  @override
  void initState() {
    super.initState();
  }

  Widget _buildPage(BuildContext context, int index) {
    final currentDate =
        initialDate.add(new Duration(days: index - initialPage));

    final currentDateOS = currentDate.subtract(new Duration(days: 13));

    final df1 = new DateFormat.yMMMMEEEEd('ru');
    final df2 = new DateFormat.yMMMMd('ru');

    return new Column(
      children: <Widget>[
        new ListTile(
            title: new Text(G.capitalize(df1.format(currentDate)),
                style: Theme.of(context).textTheme.title),
            subtitle: new Text(df2.format(currentDateOS) + ' (ст. ст.)',
                style: Theme.of(context).textTheme.subhead)),
        new SaintList(date: currentDate)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      itemBuilder: (BuildContext context, int index) {
        return _buildPage(context, index);
      },
    );
  }
}
