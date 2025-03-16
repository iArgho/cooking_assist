import 'package:flutter/material.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
          height: 20,
        ),
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildUserDetails(),
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
  }

  // Profile Header with Image
  Widget _buildHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        
        Container(
          height: 180,
          width: double.infinity,
        
        ),
        Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              backgroundImage: const NetworkImage(
                  "https://source.unsplash.com/200x200/?portrait"),
            ),
            const SizedBox(height: 8),
            const Text(
              "John Doe",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              "johndoe@example.com",
              style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.9)),
            ),
          ],
        ),
      ],
    );
  }

  // User Details Section
  Widget _buildUserDetails() {
    return Column(
      children: [
        _buildDetailTile(Icons.phone, "Phone", "+1 234 567 890"),
        _buildDetailTile(Icons.location_on, "Location", "New York, USA"),
      ],
    );
  }

  Widget _buildDetailTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon, color: Colors.blueAccent),
          title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          subtitle: Text(value, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ),
      ),
    );
  }

  // Settings List
  Widget _buildSettingsList(BuildContext context) {
    return Column(
      children: [
        _buildSettingsTile(Icons.person, "Edit Profile", () {}),
        _buildSettingsTile(Icons.lock, "Change Password", () {}),
        _buildSettingsTile(Icons.notifications, "Notifications", () {}),
        _buildSettingsTile(Icons.help, "Help & Support", () {}),
        _buildSettingsTile(Icons.privacy_tip, "Privacy Policy", () {}),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon, color: Colors.blueAccent),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
      ),
    );
  }

  // Logout Button with Confirmation
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

  // Logout Confirmation Dialog
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
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout logic
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}