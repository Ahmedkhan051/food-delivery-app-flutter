import 'package:flutter/material.dart';

import 'package:user_app/dining/discoverVibesModel.dart';

class DiscoverVibeList extends StatelessWidget {
  const DiscoverVibeList({super.key});

  static final List<DiscoverVibeModel> vibes = [
    DiscoverVibeModel(
      imageLink: 'assets/images/discovervibe1.gif',
      text: 'The Ultimate Dining Wishlist',
    ),
    DiscoverVibeModel(
      imageLink: 'assets/images/discovervibe4.gif',
      text: 'A Guide to Cafe Hopping',
    ),
    DiscoverVibeModel(
      imageLink: 'assets/images/discovervibe3.gif',
      text: 'Legend Inn',
    ),
    DiscoverVibeModel(
      imageLink: 'assets/images/discovervibe2.gif',
      text: 'Roastery Cafe House',
    ),
    DiscoverVibeModel(
      imageLink: 'assets/images/discovervibe5.gif',
      text: 'Masup Cafe & Bar',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: vibes.length,
      itemBuilder: (context, index) {
        final DiscoverVibeModel vibe = vibes[index];

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 8,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${vibe.text} selected.',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: SizedBox(
              width: 150,
              height: 210,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      vibe.imageLink,
                      fit: BoxFit.cover,
                      errorBuilder: (
                          context,
                          error,
                          stackTrace,
                          ) {
                        return Container(
                          color: const Color(0xFFE3F2FD),
                          child: const Icon(
                            Icons.restaurant_menu,
                            size: 45,
                            color: Color(0xFF1565C0),
                          ),
                        );
                      },
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color.fromARGB(220, 0, 0, 0),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 10,
                      child: Text(
                        vibe.text,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}