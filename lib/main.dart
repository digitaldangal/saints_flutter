import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';
import 'dart:typed_data';
import 'homepage.dart';
import 'globals.dart' as G;
import 'db.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

void copyDatabase({@required String to}) async {
  await deleteDatabase(to);

  ByteData data = await rootBundle.load('assets/saints.sqlite');
  List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await new File(to).writeAsBytes(bytes);
}

void main() async {
  await initializeDateFormatting('ru', null);
  G.prefs = await SharedPreferences.getInstance();

  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = documentsDirectory.path + "/saints.sqlite";

  if (!G.prefs.getKeys().contains('db_init_4')) {
    await copyDatabase(to: path);
    G.prefs.setBool('db_init_4', true);
  }

  G.db = await openDatabase(path);

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new TheViewModel(
      theModel: new SaintsModel(),
      child: new MaterialApp(
        title: 'Жития святых',
        home: new HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
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
