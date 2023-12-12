import 'package:flutter/material.dart';
import 'package:flutter_realm/app/app.dart';
import 'package:flutter_realm/storage/shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref().init();

  runApp(const App());
}
