import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredRecipes = [];

  final List<Map<String, String>> _recipes = [
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

  @override
  void initState() {
    super.initState();
    _filteredRecipes = _recipes; // Show all recipes initially
  }

  void _filterRecipes(String query) {
    setState(() {
      _filteredRecipes = _recipes
          .where((recipe) =>
              recipe["title"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: _searchController,
            onChanged: _filterRecipes,
            decoration: InputDecoration(
              hintText: "Search recipes...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),

        // Recipe List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: _filteredRecipes.length,
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
                          : Image.network(_filteredRecipes[index]["image"]!, fit: BoxFit.cover),
                    ),
                  ),
                  title: Text(
                    _filteredRecipes[index]["title"]!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_filteredRecipes[index]["description"]!),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Navigate to detailed recipe page
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}