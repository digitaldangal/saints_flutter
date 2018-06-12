import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'homepage.dart';

void main() async {
  await initializeDateFormatting('ru', null);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new TheViewModel(
      child: new MaterialApp(
        title: 'Жития святых',
        home: new HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class TheViewModel extends InheritedWidget {
  const TheViewModel({Key key, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);

  static TheViewModel of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(TheViewModel);
  }

  @override
  bool updateShouldNotify(TheViewModel oldWidget) => false;
}
