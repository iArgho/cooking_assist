import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredRecipes = [];

  final List<Map<String, dynamic>> _recipes = [
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
                      _filteredRecipes[index]["icon"],
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  title: Text(
                    _filteredRecipes[index]["title"]!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_filteredRecipes[index]["description"]!),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
