import 'package:cooking_assist/utility/path_utility.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                     const SizedBox(height: 120),
                SvgPicture.asset(
                  Assets.logo,
                  width: 270,
                  fit: BoxFit.contain,
                ),
                Text(
                  'Cooking Assistance',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100), // Space before the loader
          Align(
            alignment: Alignment.bottomCenter,
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Theme.of(context).primaryColor,
              size: 40,
            ),
          ),
          const SizedBox(height: 50), // Extra padding from bottom
        ],
      ),
    );
  }
}