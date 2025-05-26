import 'package:cooking_assist/presentation/splash_screen.dart';
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
        primaryColor: const Color(0xFFFD5523), // updated
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFD5523), // updated
          secondary: Color(0xFFFFD700),
          error: Color(0xFFFF6B6B),
          surface: Color(0xFFF5F5F5),
          onPrimary: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFD5523), // updated
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: Colors.black54,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFD5523), // updated
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.w500),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardColor: const Color(0xFFF5F5F5),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Caveat',
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFD5523), // updated
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFD5523), // updated
          secondary: Color(0xFFFFD700),
          error: Color(0xFFFF6B6B),
          surface: Color(0xFF1E1E1E),
          onPrimary: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFD5523), // updated
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: Colors.white70,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFD5523), // updated
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.w500),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardColor: const Color(0xFF1E1E1E),
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
