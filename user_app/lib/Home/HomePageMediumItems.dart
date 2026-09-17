import 'package:flutter/material.dart';

class HomeMediumItems extends StatelessWidget {
  const HomeMediumItems({super.key});

  static const List<Map<String, String>> categories = [
    {
      'image': 'assets/images/offers.gif',
      'title': 'Offers',
      'subtitle': 'Best deals & discounts',
    },
    {
      'image': 'assets/images/cake.jpeg',
      'title': 'Cakes',
      'subtitle': 'Sweet treats for you',
    },
    {
      'image': 'assets/images/fruits.gif',
      'title': 'Healthy Food',
      'subtitle': 'Fresh & healthy choices',
    },
  ];

  void showSelectionMessage(
      BuildContext context,
      String title,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title selected.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: categories.map((category) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 6,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                showSelectionMessage(
                  context,
                  category['title']!,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE3F2FD),
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(25, 0, 0, 0),
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(12),
                          child: SizedBox(
                            width: double.infinity,
                            child: Image.asset(
                              category['image']!,
                              fit: BoxFit.cover,
                              errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                  ) {
                                return Container(
                                  color:
                                  const Color(0xFFE3F2FD),
                                  child: const Icon(
                                    Icons.fastfood,
                                    color:
                                    Color(0xFF1565C0),
                                    size: 35,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        category['title']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF1565C0),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        category['subtitle']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}