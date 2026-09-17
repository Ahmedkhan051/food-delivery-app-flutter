import 'package:flutter/material.dart';

class HomePageItems4 extends StatelessWidget {
  const HomePageItems4({super.key});

  static const List<Map<String, String>> categories = [
    {
      'name': 'Samosa',
      'image': 'assets/images/samosa.jpeg',
    },
    {
      'name': 'Chocolate',
      'image': 'assets/images/chokolate.jpeg',
    },
    {
      'name': 'Pastries',
      'image': 'assets/images/pastries1.jpeg',
    },
    {
      'name': 'Momos',
      'image': 'assets/images/momos.jpeg',
    },
    {
      'name': 'Laddoo',
      'image': 'assets/images/laddoo.jpeg',
    },
    {
      'name': 'Pizza',
      'image': 'assets/images/pizza1.jpeg',
    },
    {
      'name': 'Shake',
      'image': 'assets/images/shake.jpeg',
    },
    {
      'name': 'Soft Drinks',
      'image': 'assets/images/softdrink1.jpeg',
    },
    {
      'name': 'Gulab Jamun',
      'image': 'assets/images/gulabjamun.jpeg',
    },
    {
      'name': 'Jalebi',
      'image': 'assets/images/jalebi.webp',
    },
    {
      'name': 'Kaju Barfi',
      'image': 'assets/images/kajubarfi.jpeg',
    },
  ];

  void selectCategory(
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
          categories.sublist(8, categories.length),
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
                  selectCategory(
                    context,
                    category['name']!,
                  );
                },
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 70,
                        height: 70,
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
                                size: 30,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
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