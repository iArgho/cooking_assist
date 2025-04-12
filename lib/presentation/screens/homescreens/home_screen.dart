import 'package:cooking_assist/presentation/screens/authScreens/login_screen.dart';
import 'package:cooking_assist/presentation/screens/homescreens/home_page.dart';
import 'package:cooking_assist/presentation/screens/homescreens/me_page.dart';
import 'package:cooking_assist/presentation/screens/homescreens/recipe_page.dart';
import 'package:cooking_assist/presentation/screens/homescreens/search_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    HomePage(),
    RecipePage(),
    SearchPage(),
    MePage(),
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              const Color.fromARGB(255, 29, 222, 129)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      title: const Text(
        'Cooking Assistant',
        style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, size: 24, color: Colors.white),
          onPressed: () {
            Get.offAll(const LoginPage());
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
