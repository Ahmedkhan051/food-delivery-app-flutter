import 'package:flutter/material.dart';

import 'package:user_app/dining/mustTriesModel.dart';

class MustTriesList extends StatelessWidget {
  const MustTriesList({super.key});

  static final List<MustTriesModel> mustTries = [
    MustTriesModel(
      imageLink: 'assets/images/restaurent10.jpeg',
      text: '8 Best Insta-Worthy Places',
    ),
    MustTriesModel(
      imageLink: 'assets/images/restaurent9.jpeg',
      text: '12 Must-Visit Legendary Places',
    ),
    MustTriesModel(
      imageLink: 'assets/images/restaurent8.jpeg',
      text: '5 Places For Smoky Kebabs',
    ),
    MustTriesModel(
      imageLink: 'assets/images/restaurent6.jpeg',
      text: '10 Best Bars & Pubs',
    ),
    MustTriesModel(
      imageLink: 'assets/images/restaurent5.jpeg',
      text: '8 Serene Rooftop Places',
    ),
    MustTriesModel(
      imageLink: 'assets/images/restaurent4.jpeg',
      text: '8 Places For Binge-Worthy Desserts',
    ),
    MustTriesModel(
      imageLink: 'assets/images/restaurent3.jpeg',
      text: '5 Flavourful Thalis',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: mustTries.length,
      itemBuilder: (context, index) {
        final MustTriesModel item = mustTries[index];

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
                  content: Text('${item.text} selected.'),
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
                      item.imageLink,
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
                            size: 42,
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
                        item.text,
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