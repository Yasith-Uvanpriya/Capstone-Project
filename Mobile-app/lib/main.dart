import 'package:flutter/material.dart';
import 'package:acii_alert_app/pages/home_page.dart';
import 'package:acii_alert_app/pages/accident_reporting_page.dart';

void main() {
  runApp(AcciAlertApp());
}

class AcciAlertApp extends StatelessWidget {
  const AcciAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AcciAlert App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      routes: {'/report': (context) => const AccidentReportPage()},
    );
  }
}
