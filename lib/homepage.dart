import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'globals.dart' as G;
import 'db.dart';
import 'main.dart';

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

  Widget buildRow(BuildContext context, int index, List<Saint> listData) {
    return new GestureDetector(
        child: new Wrap(
          spacing: 40.0,
          children: <Widget>[
            new Text(listData[index].name, style: new TextStyle(fontSize: 20.0))
          ],
        ),
        onTap: () {});
  }

  Widget _buildPage(BuildContext context, int index) {
    final currentDate =
        initialDate.add(new Duration(days: index - initialPage));

    final currentDateOS = currentDate.subtract(new Duration(days: 13));

    TheViewModel.of(context).update(date: currentDate);

    final df1 = new DateFormat.yMMMMEEEEd('ru');
    final df2 = new DateFormat.yMMMMd('ru');

    return new Column(
      children: <Widget>[
        new ListTile(
            title: new Text(G.capitalize(df1.format(currentDate)),
                style: Theme.of(context).textTheme.title),
            subtitle: new Text(df2.format(currentDateOS) + ' (ст. ст.)',
                style: Theme.of(context).textTheme.subhead)),
        new Expanded(
            child: new StreamBuilder<List<Saint>>(
                stream: TheViewModel.of(context).saints,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Saint>> snapshot) {
                  if (snapshot.hasData && snapshot.data.length > 0) {
                    return new ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) =>
                            buildRow(context, index, snapshot.data));
                  } else {
                    return new Text("No items");
                  }
                }))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Жития святых")),
      body: new PageView.builder(
        controller: _controller,
        itemBuilder: (BuildContext context, int index) {
          return _buildPage(context, index);
        },
      ),
    );
  }
}
