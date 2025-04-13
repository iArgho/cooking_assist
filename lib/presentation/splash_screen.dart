import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cooking_assist/utility/path_utility.dart';
import 'package:cooking_assist/presentation/screens/authScreens/login_screen.dart';
import 'package:cooking_assist/presentation/screens/homescreens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goToNextScreen();
  }

  void _goToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      final user = FirebaseAuth.instance.currentUser;
      Get.offAll(user != null ? const HomeScreen() : const LoginPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(ImagePath().logo, width: 270),
            const SizedBox(height: 20),
            Text(
              'Cooking Assistant',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'Caveat',
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 40),
            LoadingAnimationWidget.staggeredDotsWave(
              color: Theme.of(context).primaryColor,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}
