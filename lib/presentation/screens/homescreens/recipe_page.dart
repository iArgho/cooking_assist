import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_assist/presentation/screens/recepiescreens/recepie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  List<bool> _expandedStates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('recipes')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No recipes found."));
          }

          final recipes = snapshot.data!.docs;

          if (_expandedStates.length != recipes.length) {
            _expandedStates = List.generate(recipes.length, (_) => false);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final doc = recipes[index];
              final data = doc.data() as Map<String, dynamic>;
              final recipeId = doc.id;

              final title = data['name'] ?? 'Untitled';
              final description = data['description'] ?? '';
              final imageUrl = data['imageUrl'] ?? '';
              final isExpanded = _expandedStates[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: () {
                    Get.to(() => RecipeDetailScreen(
                          recipe: data,
                          recipeId: recipeId,
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : CircleAvatar(
                                radius: 30,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: const Icon(
                                  Icons.fastfood,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                description,
                                maxLines: isExpanded ? null : 2,
                                overflow: isExpanded
                                    ? TextOverflow.visible
                                    : TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _expandedStates[index] =
                                        !_expandedStates[index];
                                  });
                                },
                                child: Text(
                                  isExpanded ? "Show less" : "Show more",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
