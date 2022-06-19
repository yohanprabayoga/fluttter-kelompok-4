import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:pumpmonitoring/core/auth/auth_firebase.dart';
import 'package:pumpmonitoring/ui/screen/landing.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // firebase configuration root
  await Firebase.initializeApp();

  runApp(const MyApp());
}

ThemeData _buildAppTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
      brightness: Brightness.dark,
      textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
          bodyText1: TextStyle(fontSize: 18.0)));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pump Monitoring',
        theme: _buildAppTheme(),
        home: const LandingPage(),
      ),
    );
  }
}
