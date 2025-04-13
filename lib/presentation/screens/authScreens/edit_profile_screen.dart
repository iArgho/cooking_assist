import 'package:cooking_assist/auth/auth.dart';
import 'package:cooking_assist/presentation/screens/homescreens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final user = Auth().currentUser;

  @override
  void initState() {
    super.initState();
    _nameController.text = user?.displayName ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final newName = _nameController.text.trim();
    if (newName.isNotEmpty && newName != user?.displayName) {
      try {
        await Auth().updateDisplayName(newName);
        Get.back();
        Get.snackbar("Success", "Profile updated");
      } catch (e) {
        Get.snackbar("Error", e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user?.email ?? '',
              enabled: false,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _saveProfile();
                  Get.offAll(() => const HomeScreen());
                },
                child: const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
