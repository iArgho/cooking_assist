import 'package:cooking_assist/presentation/screens/recepieScreens/add_recepie_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'User Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const AddRecipePage());
              },
              child: const Text('Add New Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
