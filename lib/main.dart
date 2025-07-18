import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(HunterMarketApp());
}

class HunterMarketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hunter Market',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: LoginPage(),
    );
  }
}
