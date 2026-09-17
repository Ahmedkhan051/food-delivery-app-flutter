import 'package:flutter/material.dart';

import 'package:user_app/dining/popularRestaurentModel.dart';

class PopularRestaurent1 extends StatelessWidget {
  const PopularRestaurent1({super.key});

  static const List<PopularRestaurentModel> restaurants = [
    PopularRestaurentModel(
      restaurentImage: 'assets/images/restaurent4.jpeg',
      restaurentName: 'Awadh Restaurant',
      restaurentRating: '4.0',
      restaurentItemCategory: 'North Indian',
      restaurentItemPrice: 'Rs. 300 for one',
      restaurentAdderess: 'Food Street',
      restaurentDistance: '3 km',
    ),
    PopularRestaurentModel(
      restaurentImage: 'assets/images/restaurent5.jpeg',
      restaurentName: 'Skyhilton',
      restaurentRating: '4.5',
      restaurentItemCategory: 'Family Restaurant',
      restaurentItemPrice: 'Rs. 300 for one',
      restaurentAdderess: 'Park Avenue',
      restaurentDistance: '1.1 km',
    ),
    PopularRestaurentModel(
      restaurentImage: 'assets/images/restaurent1.jpeg',
      restaurentName: 'Cheers N Beers',
      restaurentRating: '4.1',
      restaurentItemCategory: 'Bar & Beverages',
      restaurentItemPrice: 'Rs. 300 for one',
      restaurentAdderess: 'City Centre',
      restaurentDistance: '2 km',
    ),
    PopularRestaurentModel(
      restaurentImage: 'assets/images/restaurent2.jpeg',
      restaurentName: 'JB Celebrations',
      restaurentRating: '4.3',
      restaurentItemCategory: 'Mithai & Street Food',
      restaurentItemPrice: 'Rs. 300 for one',
      restaurentAdderess: 'Main Market',
      restaurentDistance: '110 m',
    ),
    PopularRestaurentModel(
      restaurentImage: 'assets/images/restaurent3.jpeg',
      restaurentName: 'Royal Cafe',
      restaurentRating: '3.9',
      restaurentItemCategory: 'Cafe & Snacks',
      restaurentItemPrice: 'Rs. 300 for one',
      restaurentAdderess: 'Central Road',
      restaurentDistance: '1 km',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final PopularRestaurentModel restaurant =
        restaurants[index];

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 8,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
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
            child: Container(
              width: 360,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFE3F2FD),
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(30, 0, 0, 0),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                    child: SizedBox(
                      height: 185,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            restaurant.restaurentImage,
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
                                  size: 50,
                                ),
                              );
                            },
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                                size: 21,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                restaurant.restaurentName,
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1565C0),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32),
                                borderRadius:
                                BorderRadius.circular(7),
                              ),
                              child: Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  Text(
                                    restaurant.restaurentRating,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 13,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          restaurant.restaurentItemCategory,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          restaurant.restaurentItemPrice,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 17,
                              color: Color(0xFF42A5F5),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                restaurant.restaurentAdderess,
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              restaurant.restaurentDistance,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 36,
                          child: OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Opening ${restaurant.restaurentName}...',
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                              const Color(0xFF1565C0),
                              side: const BorderSide(
                                color: Color(0xFF1565C0),
                              ),
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(9),
                              ),
                            ),
                            child: const Text(
                              'View Restaurant',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
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