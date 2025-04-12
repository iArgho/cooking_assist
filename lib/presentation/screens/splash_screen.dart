import 'dart:async';
import 'package:cooking_assist/presentation/screens/authScreens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cooking_assist/utility/path_utility.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goToNextScreen();
  }

  void goToNextScreen() {
    Future.delayed(const Duration(seconds: 3)).then((_) {
      Get.offAll(const LoginPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ImagePath().logo,
              width: 270,
              fit: BoxFit.contain,
            ),
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
