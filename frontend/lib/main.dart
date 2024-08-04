import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/auth_service.dart';
import 'package:frontend/screens/login.dart';

Future<void> main() async {
  await dotenv.load();
    WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  await authService.checkAndDeleteExpiredToken();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Watchlist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
