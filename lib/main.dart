import 'package:flutter/material.dart';
import 'package:flutter_offline_mode/app/app.dart';
import 'package:flutter_offline_mode/storage/shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPref().init();

  runApp(const App());
}
