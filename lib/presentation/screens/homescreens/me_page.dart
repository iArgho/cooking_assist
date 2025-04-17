import 'package:cooking_assist/auth/auth.dart';
import 'package:cooking_assist/presentation/screens/authScreens/edit_profile_screen.dart';
import 'package:cooking_assist/presentation/screens/authScreens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Auth().currentUser?.reload(),
      builder: (context, snapshot) {
        final user = Auth().currentUser;

        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(
                    context,
                    user?.displayName ?? "User",
                    user?.email ?? "No email",
                  ),
                  const SizedBox(height: 20),
                  _buildSettingsList(context),
                  const SizedBox(height: 20),
                  _buildLogoutButton(context),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, String name, String email) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Text(
          email,
          style: TextStyle(fontSize: 20, color: Colors.black.withOpacity(0.9)),
        ),
      ],
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Column(
      children: [
        _buildSettingsTile(Icons.person, "Edit Profile", () {
          Get.to(() => const EditProfilePage());
        }),
        _buildSettingsTile(Icons.restaurant_menu, "Add Recipe", () {
          //Get.to(() => const AddRecipePage());
        }),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon, color: Colors.blueAccent),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: const Icon(Icons.logout),
        label: const Text("Logout", style: TextStyle(fontSize: 18)),
        onPressed: () {
          _showLogoutConfirmation(context);
        },
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Auth().signOut();
              Get.offAll(() => const LoginPage());
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
