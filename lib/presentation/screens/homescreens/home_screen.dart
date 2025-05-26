import 'package:cooking_assist/auth/auth.dart';
import 'package:cooking_assist/presentation/screens/authScreens/login_screen.dart';
import 'package:cooking_assist/presentation/screens/homescreens/home_page.dart';
import 'package:cooking_assist/presentation/screens/homescreens/me_page.dart';
import 'package:cooking_assist/presentation/screens/homescreens/recipe_page.dart';
import 'package:cooking_assist/presentation/screens/homescreens/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    const HomePage(),
    const RecipePage(),
    const SearchPage(),
    const MePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor, // #FD5523
              const Color(0xFFFFA06B), // lighter orange shade
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: const Text(
        'Cooking Assistant',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, size: 24, color: Colors.white),
          onPressed: () async {
            await Auth().signOut();
            Get.snackbar(
              'Logged out',
              'You have been signed out.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFFFD5523), // primary orange
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
            );
            Get.offAll(() => const LoginPage());
          },
        ),
      ],
    );
  }

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey[600],
      selectedFontSize: 16,
      unselectedFontSize: 14,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.home_rounded, size: 30),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.restaurant_menu, size: 30),
          ),
          label: 'Recipe',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.search_rounded, size: 30),
          ),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.person, size: 30),
          ),
          label: 'Me',
        ),
      ],
    );
  }
}
