import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'db.dart';
import 'main.dart';
import 'saint_details.dart';

class SaintList extends StatefulWidget {
  DateTime date;
  SaintList({@required this.date});

  @override
  _SaintListState createState() => new _SaintListState();
}

class _SaintListState extends State<SaintList> {
  var saintData = null;

  Widget buildRow(BuildContext context, int index, List<Saint> listData) {
    final Saint s = listData[index];

    return new GestureDetector(
      child: new Container(
          padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              s.has_icon
                  ? Image.network(
                      "https://s3.amazonaws.com/from-alexey/saints-icons/${s.id}.jpg",
                      width: 100.0,
                      height: 100.0,
                    )
                  : Container(),
              new Expanded(
                  child: new Container(
                      padding: new EdgeInsets.only(left: 10.0),
                      child: new Text(s.name,
                          style: Theme
                              .of(context)
                              .textTheme
                              .body1
                              .copyWith(fontSize: 18.0))))
            ],
          )),
      onTap: () => Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) =>
                  new SaintDetail(listData[index]))),
    );
  }

  @override
  Widget build(BuildContext context) {
    TheViewModel.of(context).update(date: widget.date);

    return new Expanded(
        child: new StreamBuilder<List<Saint>>(
            stream: TheViewModel.of(context).saints,
            builder:
                (BuildContext context, AsyncSnapshot<List<Saint>> snapshot) {
              if (snapshot.hasData && snapshot.data.length > 0) {
                if (saintData == null) saintData = snapshot.data;

                return new ListView.builder(
                    itemCount: saintData.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildRow(context, index, saintData));
              } else {
                return new Text("");
              }
            }));
  }
}
