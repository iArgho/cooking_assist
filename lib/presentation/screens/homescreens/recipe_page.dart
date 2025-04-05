import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> recipes = [
      {
        "title": "Spaghetti Carbonara",
        "description": "Classic Italian pasta with creamy sauce.",
        "image": "https://source.unsplash.com/200x200/?pasta"
      },
      {
        "title": "Grilled Chicken",
        "description": "Juicy and perfectly grilled chicken breast.",
        "image": "https://source.unsplash.com/200x200/?chicken"
      },
      {
        "title": "Avocado Toast",
        "description": "Healthy toast with fresh avocado and eggs.",
        "image": "https://source.unsplash.com/200x200/?avocado"
      },
      {
        "title": "Berry Smoothie",
        "description": "A refreshing mix of berries and yogurt.",
        "image": "https://source.unsplash.com/200x200/?smoothie"
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        bool isPrimaryColor = index % 2 == 0;

        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 60,
                height: 60,
                color: isPrimaryColor ? Theme.of(context).primaryColor : Colors.transparent,
                child: isPrimaryColor
                    ? const Icon(Icons.restaurant, color: Colors.white, size: 30)
                    : Image.network(recipes[index]["image"]!, fit: BoxFit.cover),
              ),
            ),
            title: Text(
              recipes[index]["title"]!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(recipes[index]["description"]!),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to detailed recipe page
            },
          ),
        );
      },
    );
  }
}