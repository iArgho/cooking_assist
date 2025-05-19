import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_assist/presentation/screens/recepiescreens/recepie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredRecipes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _filterRecipes(_searchController.text);
    });
  }

  Future<void> _filterRecipes(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredRecipes = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('recipes')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      final results = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'name': data['name'] ?? '',
          'description': data['description'] ?? '',
          'imageUrl': data['imageUrl'] ?? '',
          'id': doc.id,
        };
      }).toList();

      setState(() {
        _filteredRecipes = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Search error: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredRecipes.isEmpty) {
      return const Center(child: Text("No recipes found."));
    }

    return ListView.builder(
      itemCount: _filteredRecipes.length,
      itemBuilder: (context, index) {
        final recipe = _filteredRecipes[index];
        return GestureDetector(
          onTap: () {
            Get.to(() => RecipeDetailScreen(
                  recipe: recipe,
                  recipeId: recipe['id'],
                ));
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: recipe['imageUrl'] != null &&
                      recipe['imageUrl'].isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        recipe['imageUrl'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.fastfood, size: 40, color: Colors.grey),
              title: Text(
                recipe['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                recipe['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }
}
