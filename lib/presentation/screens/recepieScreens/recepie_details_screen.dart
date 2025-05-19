import 'package:cooking_assist/presentation/screens/recepiescreens/edit_recipie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final String recipeId;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.recipeId,
  });

  @override
  Widget build(BuildContext context) {
    final name = recipe['name'] ?? "Unnamed Recipe";
    final description = recipe['description'] ?? "No description available.";
    final imageUrl = recipe['imageUrl'];

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Get.to(() => EditRecipeScreen(
                    recipeId: recipeId,
                    recipe: recipe,
                  ));
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          imageUrl != null && imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      Image.network(imageUrl, height: 250, fit: BoxFit.cover),
                )
              : Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      const Icon(Icons.fastfood, size: 80, color: Colors.grey),
                ),
          const SizedBox(height: 20),
          Text(
            name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
