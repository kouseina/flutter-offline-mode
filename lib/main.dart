import 'package:flutter/material.dart';
import 'package:flutter_offline_mode/app/app.dart';
import 'package:flutter_offline_mode/storage/shared_pref.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  await SharedPref().init();

  runApp(const App());
}
