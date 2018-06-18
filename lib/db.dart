import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:typed_data';
import 'dart:io';

import 'globals.dart' as G;

void copyDatabase({@required String to}) async {
  await deleteDatabase(to);

  ByteData data = await rootBundle.load('assets/saints.sqlite');
  List<int> bytes =
  data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await new File(to).writeAsBytes(bytes);
}

class TheViewModel extends InheritedWidget {
  final SaintsModel theModel;

  const TheViewModel({Key key, @required this.theModel, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);

  static SaintsModel of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(TheViewModel) as TheViewModel)
          .theModel;

  @override
  bool updateShouldNotify(TheViewModel oldWidget) => false;
}

class SaintsModel {
  final _newSaintSubject = new PublishSubject<List<Saint>>();

  Observable<List<Saint>> get saints => _newSaintSubject.observable;

  update({@required DateTime date}) {
    final day = date.day.toString();
    final month = date.month.toString();

    final query = G.db.query('app_saint',
        columns: ['id', 'name', 'zhitie', 'has_icon'],
        where: 'day=$day AND month=$month');

    var dbStream = new Observable.fromFuture(query);

    _newSaintSubject.addStream(dbStream.map((List<Map> data) =>
            new List<Saint>.from(data.map((s) => new Saint(
                id: s['id'],
                name: s['name'],
                day: date.day,
                month: date.month,
                zhitie: s['zhitie'],
                hasIcon: s['has_icon'])))

        ));
  }
}

class Saint {
  int id;
  String name;
  int day;
  int month;
  String zhitie;
  int hasIcon;

  bool get has_icon  => hasIcon == 1;

  Saint(
      {@required this.id,
      @required this.name,
      @required this.day,
      @required this.month,
      @required this.zhitie,
      @required this.hasIcon});
}
