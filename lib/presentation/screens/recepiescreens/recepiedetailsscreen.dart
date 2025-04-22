import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final String recipeId;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.recipeId, // Make sure to use recipeId if needed
  });

  @override
  Widget build(BuildContext context) {
    final name = recipe['name'] ?? "Unnamed Recipe";
    final description = recipe['description'] ?? "No description available.";
    final imageUrl = recipe['imageUrl'];

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Icon(Icons.fastfood,
                        size: 80, color: Colors.grey),
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            // Optionally use the recipeId here if needed
            // Example: Text('Recipe ID: $recipeId'),
          ],
        ),
      ),
    );
  }
}
