library saints_flutter.globals;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

SharedPreferences prefs;
Database db;

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
