import 'package:flutter/material.dart';
import 'package:hunter_market/pages/home_page.dart';


void main() {
  runApp(const HunterApp());
}

class HunterApp extends StatelessWidget {
  const HunterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hunter Market',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      debugShowCheckedModeBanner: false,
      home:  HomePage(),
    );
  }
}
