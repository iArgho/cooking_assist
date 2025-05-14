import 'package:cooking_assist/widget/%20newly_added_recipes.dart';
import 'package:cooking_assist/widget/%20suggestions_list.dart';
import 'package:cooking_assist/widget/%20whats_new_carousel.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _onRefresh() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
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
              const WhatsNewCarousel(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("Suggestions",
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              const SizedBox(height: 10),
              const SuggestionsList(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("Newly Added Recipes",
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              const SizedBox(height: 10),
              const NewlyAddedRecipes(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
