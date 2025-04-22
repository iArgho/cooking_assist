import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WhatsNewCarousel extends StatefulWidget {
  const WhatsNewCarousel({super.key});

  @override
  State<WhatsNewCarousel> createState() => _WhatsNewCarouselState();
}

class _WhatsNewCarouselState extends State<WhatsNewCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  int _carouselLength = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (_pageController.hasClients && mounted && _carouselLength > 1) {
        final nextPage = (_currentPage + 1) % _carouselLength;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _currentPage = nextPage;
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('recipes')
          .where('timestamp', isNotEqualTo: null)
          .orderBy('timestamp', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 160,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final recipes = snapshot.data!.docs;
        _carouselLength = recipes.length;

        if (recipes.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("No recent recipes."),
          );
        }

        return SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final data = recipes[index].data() as Map<String, dynamic>;
              final name = data['name'] ?? "Recipe";
              final imageUrl = data['imageUrl'];

              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                  image: imageUrl != null && imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: Stack(
                  children: [
                    // Gradient overlay at bottom
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Title at bottom left
                    Positioned(
                      left: 16,
                      bottom: 16,
                      right: 16,
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black45,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
