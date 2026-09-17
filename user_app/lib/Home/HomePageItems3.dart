import 'package:flutter/material.dart';

class HomePageItems3 extends StatelessWidget {
  const HomePageItems3({super.key});

  static const List<Map<String, String>> categories = [
    {
      'name': 'Jalebi',
      'image': 'assets/images/jalebi.webp',
    },
    {
      'name': 'Kaju Barfi',
      'image': 'assets/images/kajubarfi.jpeg',
    },
    {
      'name': 'Gulab Jamun',
      'image': 'assets/images/gulabjamun.jpeg',
    },
    {
      'name': 'Soft Drinks',
      'image': 'assets/images/softdrink.png',
    },
    {
      'name': 'Laddoo',
      'image': 'assets/images/laddoo.jpeg',
    },
    {
      'name': 'Shake',
      'image': 'assets/images/shake.jpeg',
    },
    {
      'name': 'Pastries',
      'image': 'assets/images/pastries.jpeg',
    },
    {
      'name': 'Pastries',
      'image': 'assets/images/pastries1.jpeg',
    },
    {
      'name': 'Pastie',
      'image': 'assets/images/pastries2.jpeg',
    },
    {
      'name': 'Momos',
      'image': 'assets/images/momos.jpeg',
    },
    {
      'name': 'Chocolate',
      'image': 'assets/images/chokolate.jpeg',
    },
    {
      'name': 'Pizza',
      'image': 'assets/images/pizza1.jpeg',
    },
  ];

  void showCategoryMessage(
      BuildContext context,
      String category,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$category selected.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        _buildCategoryRow(
          context,
          categories.sublist(0, 4),
        ),
        _buildCategoryRow(
          context,
          categories.sublist(4, 8),
        ),
        _buildCategoryRow(
          context,
          categories.sublist(8, 12),
        ),
      ],
    );
  }

  Widget _buildCategoryRow(
      BuildContext context,
      List<Map<String, String>> rowCategories,
      ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: rowCategories.map((category) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 8,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  showCategoryMessage(
                    context,
                    category['name']!,
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 64,
                        height: 64,
                        child: Image.asset(
                          category['image']!,
                          fit: BoxFit.cover,
                          errorBuilder: (
                              context,
                              error,
                              stackTrace,
                              ) {
                            return Container(
                              color: const Color(0xFFE3F2FD),
                              child: const Icon(
                                Icons.fastfood,
                                color: Color(0xFF1565C0),
                                size: 28,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category['name']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF1565C0),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}