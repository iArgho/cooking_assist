import 'package:cooking_assist/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class CookingAssist extends StatelessWidget {
  const CookingAssist({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cooking Assist',
      theme: ThemeData(
        primaryColor: const Color(0xFFF57758),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF57758),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w300, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w200, color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF57758),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFF57758),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF57758),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w300, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w200, color: Colors.white70),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF57758),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}