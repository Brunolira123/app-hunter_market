import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hunter_market/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/login_page.dart';

// Inicializador do plugin de notificações
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.init();

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

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
      home: LoginPage(),
    );
  }
}
