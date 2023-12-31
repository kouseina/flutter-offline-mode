import 'package:flutter/material.dart';
import 'package:flutter_offline_mode/app/app.dart';
import 'package:flutter_offline_mode/provider/link_notifier.dart';
import 'package:flutter_offline_mode/storage/shared_pref.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPref().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LinkNotifier(),
        ),
      ],
      child: const App(),
    ),
  );
}
