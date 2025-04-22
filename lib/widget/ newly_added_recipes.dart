import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_assist/presentation/screens/recepiescreens/recepie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewlyAddedRecipes extends StatelessWidget {
  const NewlyAddedRecipes({super.key});

  @override
  Widget build(BuildContext context) {
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
            final data = recipe.data() as Map<String, dynamic>;
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
                    : Icon(Icons.fastfood,
                        size: 40, color: Theme.of(context).primaryColor),
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
                  final recipeId = recipe.id;
                  Get.to(() => RecipeDetailScreen(
                        recipe: data,
                        recipeId: recipeId,
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
