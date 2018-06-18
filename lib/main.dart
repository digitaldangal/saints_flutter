import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';
import 'homepage.dart';
import 'favs_page.dart';
import 'search_page.dart';
import 'globals.dart' as G;
import 'db.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

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

class NavigationIconView {
  NavigationIconView({
    this.icon,
    this.title,
    this.content,
    TickerProvider vsync,
  })  : item = new BottomNavigationBarItem(
          icon: icon,
          title: new Text(title),
        ),
        controller = new AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = new CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
  }

  final Widget icon;
  final String title;
  final Widget content;

  final BottomNavigationBarItem item;
  final AnimationController controller;
  CurvedAnimation _animation;

  FadeTransition transition(BuildContext context) {
    return new FadeTransition(
      opacity: _animation,
      child: new SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(0.0, 0.02), // Slightly down.
            end: Offset.zero,
          ).animate(_animation),
          child: content),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.fixed;

  List<NavigationIconView> _navigationViews;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      NavigationIconView(
        icon: const Icon(Icons.wb_sunny),
        title: 'Жития',
        content: HomePage(),
        vsync: this,
      ),
      NavigationIconView(
        icon: const Icon(Icons.favorite),
        title: 'Закладки',
        content: FavsPage(),
        vsync: this,
      ),
      NavigationIconView(
        icon: const Icon(Icons.search),
        title: 'Поиск',
        content: SearchPage(),
        vsync: this,
      ),
    ];

    for (NavigationIconView view in _navigationViews)
      view.controller.addListener(_rebuild);

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews) view.controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews)
      transitions.add(view.transition(context));

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return new Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return new TheViewModel(
      theModel: new SaintsModel(),
      child: new MaterialApp(
        title: 'Жития святых',
        home: Scaffold(
          appBar: AppBar(title: new Text("Жития святых")),
          body: new Center(child: _buildTransitionsStack()),
          bottomNavigationBar: botNavBar,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
