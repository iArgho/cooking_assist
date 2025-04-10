import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recipes = [
      {
        "title": "Spaghetti Carbonara",
        "description": "Classic Italian pasta with creamy sauce.",
        "icon": Icons.restaurant,
      },
      {
        "title": "Grilled Chicken",
        "description": "Juicy and perfectly grilled chicken breast.",
        "icon": Icons.local_dining,
      },
      {
        "title": "Avocado Toast",
        "description": "Healthy toast with fresh avocado and eggs.",
        "icon": Icons.breakfast_dining,
      },
      {
        "title": "Berry Smoothie",
        "description": "A refreshing mix of berries and yogurt.",
        "icon": Icons.local_cafe,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(
                recipes[index]["icon"],
                color: Colors.white,
                size: 30,
              ),
            ),
            title: Text(
              recipes[index]["title"]!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(recipes[index]["description"]!),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        );
      },
    );
  }
}