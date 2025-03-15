import 'package:cooking_assist/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CookingAssist extends StatelessWidget {
  const CookingAssist({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cooking Assist',
      theme: ThemeData(
        fontFamily: 'Caveat',
        primaryColor: const Color(0xFF0BDA51),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor:   Color(0xFF0BDA51),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w300, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w200, color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:  const Color(0xFF0BDA51),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Caveat',
        brightness: Brightness.dark,
        primaryColor:  const Color(0xFF0BDA51),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor:  const Color(0xFF0BDA51),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w300, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w200, color: Colors.white70),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:  const Color(0xFF0BDA51),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}