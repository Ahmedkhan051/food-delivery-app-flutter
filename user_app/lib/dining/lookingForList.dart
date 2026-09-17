import 'package:flutter/material.dart';

import 'package:user_app/dining/lookingForModel.dart';

class LookingForList extends StatelessWidget {
  const LookingForList({super.key});

  static final List<List<LookingForModel>> categories = [
    [
      LookingForModel(
        name: 'Nightlife & Drinks',
        imageLink: 'assets/images/restaurent1.jpeg',
      ),
      LookingForModel(
        name: 'Family Dining',
        imageLink: 'assets/images/restaurent2.jpeg',
      ),
      LookingForModel(
        name: 'Dinner',
        imageLink: 'assets/images/restaurent3.jpeg',
      ),
    ],
    [
      LookingForModel(
        name: 'Romantic Places',
        imageLink: 'assets/images/restaurent4.jpeg',
      ),
      LookingForModel(
        name: 'Indoor Dining',
        imageLink: 'assets/images/restaurent5.jpeg',
      ),
      LookingForModel(
        name: 'Outdoor Dining',
        imageLink: 'assets/images/restaurent6.jpeg',
      ),
    ],
    [
      LookingForModel(
        name: 'Newly Opened',
        imageLink: 'assets/images/restaurent8.jpeg',
      ),
      LookingForModel(
        name: 'Desserts',
        imageLink: 'assets/images/cake1.jpeg',
      ),
      LookingForModel(
        name: 'Events',
        imageLink: 'assets/images/restaurent10.jpeg',
      ),
    ],
  ];

  void showSelectedMessage(
      BuildContext context,
      String name,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name selected.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int itemCount = categories.first.length;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 8,
          ),
          child: Column(
            children: [
              _LookingForCard(
                model: categories[0][index],
                onTap: () {
                  showSelectedMessage(
                    context,
                    categories[0][index].name,
                  );
                },
              ),
              const SizedBox(height: 8),
              _LookingForCard(
                model: categories[1][index],
                onTap: () {
                  showSelectedMessage(
                    context,
                    categories[1][index].name,
                  );
                },
              ),
              const SizedBox(height: 8),
              _LookingForCard(
                model: categories[2][index],
                onTap: () {
                  showSelectedMessage(
                    context,
                    categories[2][index].name,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LookingForCard extends StatelessWidget {
  final LookingForModel model;
  final VoidCallback onTap;

  const _LookingForCard({
    required this.model,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 100,
              width: 120,
              child: Image.asset(
                model.imageLink,
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
                      color: Color(0xFF1565C0),
                      size: 38,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 120,
            child: Text(
              model.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF1565C0),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}