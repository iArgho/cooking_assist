import 'package:cooking_assist/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class CookingAsist extends StatelessWidget {
  const CookingAsist({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cooking Asist',
      home: SplashScreen(),
    );
  }
}
