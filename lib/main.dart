import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myfitpal/auth/login_screen.dart';

void main() async {
  // Ensure that Firebase is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyFitPal',
      home: const LoginScreen(),
      // home: const SplashScreen(),
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}
