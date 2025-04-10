import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildWhatsNewCarousel(context),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Suggestions",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildSuggestionsList(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Newly Added Recipes",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildNewlyAddedRecipes(),
          ],
        ),
      ),
    );
  }

  Widget _buildWhatsNewCarousel(BuildContext context) {
    final List<Map<String, String>> newItems = [
      {"type": "color", "value": "Fresh Ingredients, Fresh Taste!"},
      {"type": "color", "value": "Try Our Newest Recipes Today!"},
    ];

    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index % newItems.length;
          });
        },
        itemBuilder: (context, index) {
          final item = newItems[index % newItems.length];
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                item["value"]!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuggestionsList() {
    final List<Map<String, dynamic>> items = [
      {"title": "Easy Pasta Recipe", "icon": Icons.restaurant},
      {"title": "Healthy Smoothies", "icon": Icons.local_drink},
      {"title": "Best Baking Tips", "icon": Icons.cake},
    ];

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (int i = 0; i < 5; i++)
          ListTile(
            leading: Icon(items[i % items.length]["icon"], size: 40, color: Theme.of(context).primaryColor),
            title: Text(
              items[i % items.length]["title"]!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            onTap: () {},
          ),
      ],
    );
  }

  Widget _buildNewlyAddedRecipes() {
    final List<Map<String, dynamic>> newRecipes = [
      {"title": "Spicy Tacos", "icon": Icons.local_dining},
      {"title": "Avocado Toast", "icon": Icons.breakfast_dining},
      {"title": "Homemade Pizza", "icon": Icons.local_pizza},
    ];

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (var recipe in newRecipes)
          ListTile(
            leading: Icon(recipe["icon"], size: 40, color: Theme.of(context).primaryColor),
            title: Text(
              recipe["title"]!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            onTap: () {},
          ),
      ],
    );
  }
}
