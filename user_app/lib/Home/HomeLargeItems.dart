import 'package:flutter/material.dart';

class HomeLargeItems extends StatelessWidget {
  const HomeLargeItems({super.key});

  static const Color deepBlue = Color(0xFF1565C0);
  static const Color mediumBlue = Color(0xFF42A5F5);

  static const List<Map<String, String>> offers = [
    {
      'image': 'assets/images/discovervibe3.gif',
      'title': 'Special Discounts',
      'subtitle': 'Save more on your favourite food',
    },
    {
      'image': 'assets/images/discovervibe2.gif',
      'title': 'Dine & Enjoy',
      'subtitle': 'Discover great restaurants around you',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: offers.map((offer) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 4,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${offer['title']} selected.',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      offer['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (
                          context,
                          error,
                          stackTrace,
                          ) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                deepBlue,
                                mediumBlue,
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.restaurant_menu,
                            color: Colors.white,
                            size: 55,
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
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer['title']!,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            offer['subtitle']!,
                            maxLines: 2,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}