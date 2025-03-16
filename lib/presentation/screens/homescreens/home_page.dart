import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
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

            // What's New Carousel
            _buildWhatsNewCarousel(context),

            const SizedBox(height: 20),

            // Suggestions List
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
          ],
        ),
      ),
    );
  }

  // What's New Carousel (Alternating Image & Color Block)
  Widget _buildWhatsNewCarousel(BuildContext context) {
    final List<Map<String, String>> newItems = [
      {"type": "color", "value": "Fresh Ingredients, Fresh Taste!"},
      {"type": "color", "value": "Try Our Newest Recipes Today!"},
    ];

    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: newItems.length,
        pageSnapping: true,
        controller: _pageController,
        itemBuilder: (context, index) {
          final item = newItems[index];
          if (item["type"] == "image") {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(item["value"]!),
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else {
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
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // Suggestions List
  Widget _buildSuggestionsList() {
    final List<Map<String, String>> suggestions = [
      {"title": "Easy Pasta Recipe", "image": "assets/images/suggestion1.jpg"},
      {"title": "Healthy Smoothies", "image": "assets/images/suggestion2.jpg"},
      {"title": "Best Baking Tips", "image": "assets/images/suggestion3.jpg"},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(suggestions[index]["image"]!, width: 50, height: 50, fit: BoxFit.cover),
          ),
          title: Text(suggestions[index]["title"]!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          onTap: () {
            // Handle tap event
          },
        );
      },
    );
  }
}