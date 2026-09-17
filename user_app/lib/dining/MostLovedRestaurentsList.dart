import 'package:flutter/material.dart';

import 'package:user_app/dining/MostLovedRestaurentsModel.dart';

class MostLovedRestaurentsList extends StatelessWidget {
  const MostLovedRestaurentsList({super.key});

  static const List<MostLovedRestaurents> restaurants = [
    MostLovedRestaurents(
      imageLink: 'assets/images/restaurent10.jpeg',
      rating: '4.1',
      restaurentName: 'Best Choice Of Awadh',
      discounts: '20% FLAT OFF',
    ),
    MostLovedRestaurents(
      imageLink: 'assets/images/restaurent2.jpeg',
      rating: '4.3',
      restaurentName: 'Tunde Kababi',
      discounts: '15% FLAT OFF',
    ),
    MostLovedRestaurents(
      imageLink: 'assets/images/restaurent3.jpeg',
      rating: '4.5',
      restaurentName: 'Skyhilton',
      discounts: '10% FLAT OFF',
    ),
    MostLovedRestaurents(
      imageLink: 'assets/images/restaurent4.jpeg',
      rating: '4.2',
      restaurentName: 'Tunde Kababi',
      discounts: '20% FLAT OFF',
    ),
    MostLovedRestaurents(
      imageLink: 'assets/images/restaurent5.jpeg',
      rating: '4.0',
      restaurentName: 'Theka-The Piccadily',
      discounts: '30% FLAT OFF',
    ),
    MostLovedRestaurents(
      imageLink: 'assets/images/restaurent6.jpeg',
      rating: '4.4',
      restaurentName: 'Punjabi-The Piccadily',
      discounts: '15% FLAT OFF',
    ),
    MostLovedRestaurents(
      imageLink: 'assets/images/restaurent1.jpeg',
      rating: '4.3',
      restaurentName: 'Cheers N Beers',
      discounts: '20% FLAT OFF',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final MostLovedRestaurents restaurant = restaurants[index];

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 10,
          ),
          child: SizedBox(
            width: 200,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${restaurant.restaurentName} selected.',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            restaurant.imageLink,
                            fit: BoxFit.cover,
                            errorBuilder: (
                                context,
                                error,
                                stackTrace,
                                ) {
                              return Container(
                                color: const Color(0xFFE3F2FD),
                                child: const Icon(
                                  Icons.restaurant,
                                  color: Color(0xFF1565C0),
                                  size: 40,
                                ),
                              );
                            },
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    restaurant.rating,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 11,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    restaurant.restaurentName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    restaurant.discounts,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF42A5F5),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}