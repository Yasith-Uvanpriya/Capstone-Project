import 'package:flutter/material.dart';
import 'home_page.dart';
import 'accident_reporting_page.dart';
import 'home.dart';
import 'login_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AcciaLert',
      debugShowCheckedModeBanner: false,
      home: Home(), // Entry screen
    );
  }
}
