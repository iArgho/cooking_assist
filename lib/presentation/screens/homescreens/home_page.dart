import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_assist/presentation/screens/recepiescreens/recepiedetailsscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _currentPage = 0;
  int _carouselLength = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (_pageController.hasClients && mounted && _carouselLength > 1) {
        final nextPage = (_currentPage + 1) % _carouselLength;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _currentPage = nextPage;
        _startAutoScroll();
      }
    });
  }

  Future<void> _onRefresh() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildWhatsNewCarousel(context),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Suggestions",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 10),
              _buildSuggestionsList(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Newly Added Recipes",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 10),
              _buildNewlyAddedRecipes(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWhatsNewCarousel(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('recipes')
          .where('timestamp', isNotEqualTo: null)
          .orderBy('timestamp', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 160,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final recipes = snapshot.data!.docs;
        _carouselLength = recipes.length;

        if (recipes.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("No recent recipes."),
          );
        }

        return SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final data = recipes[index].data()
                  as Map<String, dynamic>; // Cast to Map<String, dynamic>
              final name = data['name'] ?? "Recipe";
              final imageUrl = data['imageUrl'];

              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  image: imageUrl != null && imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4),
                            BlendMode.darken,
                          ),
                        )
                      : null,
                ),
                child: Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSuggestionsList() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('recipes').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("No recipe suggestions available."),
          );
        }

        // Shuffle and pick 5 random recipes
        final docs = snapshot.data!.docs;
        docs.shuffle();
        final suggestions = docs.take(5).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final data = suggestions[index].data()
                as Map<String, dynamic>; // Cast to Map<String, dynamic>
            final name = data['name'] ?? "Unnamed Recipe";
            final icon = Icons.fastfood;

            return ListTile(
              leading: Icon(icon, size: 32, color: Colors.orange),
              title: Text(name),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                final recipe = suggestions[index];
                final recipeId = recipe.id; // Get the recipe ID
                Get.to(() => RecipeDetailScreen(
                      recipe: recipe.data()
                          as Map<String, dynamic>, // Casting the data
                      recipeId: recipeId, // Passing the recipe ID
                    ));
              },
            );
          },
        );
      },
    );
  }

  Widget _buildNewlyAddedRecipes() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('recipes')
          .where('timestamp', isNotEqualTo: null)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("No recipes found."),
          );
        }

        final recipes = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            final data = recipe.data()
                as Map<String, dynamic>; // Cast to Map<String, dynamic>
            final name = data['name'] ?? "Unnamed";
            final desc = data['description'] ?? "";
            final imageUrl = data['imageUrl'];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: imageUrl != null && imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.fastfood, size: 40, color: Colors.grey),
                title: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  final recipeId = recipe.id; // Get the recipe ID
                  Get.to(() => RecipeDetailScreen(
                        recipe: recipe.data()
                            as Map<String, dynamic>, // Passing the recipe data
                        recipeId: recipeId, // Passing the recipe ID
                      ));
                },
              ),
            );
          },
        );
      },
    );
  }
}
