import 'package:flutter/material.dart';

import 'package:user_app/dining/popularRestaurentModel.dart';

class PopularRestaurent extends StatelessWidget {
  const PopularRestaurent({super.key});

  static const List<PopularRestaurentModel> restaurants = [
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
      restaurentDistance: '1.1 km',
    ),
    PopularRestaurentModel(
      restaurentImage: 'assets/images/restaurent3.jpeg',
      restaurentName: 'Royal Cafe',
      restaurentRating: '4.2',
      restaurentItemCategory: 'Cafe & Snacks',
      restaurentItemPrice: 'Rs. 250 for one',
      restaurentAdderess: 'Central Road',
      restaurentDistance: '1.5 km',
    ),
    PopularRestaurentModel(
      restaurentImage: 'assets/images/restaurent4.jpeg',
      restaurentName: 'Awadh Restaurant',
      restaurentRating: '4.4',
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
      restaurentItemPrice: 'Rs. 350 for one',
      restaurentAdderess: 'Park Avenue',
      restaurentDistance: '4 km',
    ),
    PopularRestaurentModel(
      restaurentImage: 'assets/images/restaurent6.jpeg',
      restaurentName: 'Punjab Kitchen',
      restaurentRating: '4.2',
      restaurentItemCategory: 'Punjabi',
      restaurentItemPrice: 'Rs. 280 for one',
      restaurentAdderess: 'Market Road',
      restaurentDistance: '2.2 km',
    ),
    PopularRestaurentModel(
      restaurentImage: 'assets/images/restaurent7.jpeg',
      restaurentName: 'Spice Garden',
      restaurentRating: '4.0',
      restaurentItemCategory: 'Indian Cuisine',
      restaurentItemPrice: 'Rs. 260 for one',
      restaurentAdderess: 'Green Avenue',
      restaurentDistance: '3.5 km',
    ),
    PopularRestaurentModel(
      restaurentImage: 'assets/images/restaurent8.jpeg',
      restaurentName: 'Food Junction',
      restaurentRating: '4.3',
      restaurentItemCategory: 'Fast Food',
      restaurentItemPrice: 'Rs. 220 for one',
      restaurentAdderess: 'Station Road',
      restaurentDistance: '1.8 km',
    ),
    PopularRestaurentModel(
      restaurentImage: 'assets/images/restaurent9.jpeg',
      restaurentName: 'Tasty Corner',
      restaurentRating: '4.1',
      restaurentItemCategory: 'Snacks & Meals',
      restaurentItemPrice: 'Rs. 240 for one',
      restaurentAdderess: 'Market Square',
      restaurentDistance: '2.7 km',
    ),
    PopularRestaurentModel(
      restaurentImage: 'assets/images/restaurent10.jpeg',
      restaurentName: 'Tunde Kababi',
      restaurentRating: '4.6',
      restaurentItemCategory: 'Kebab & Mughlai',
      restaurentItemPrice: 'Rs. 320 for one',
      restaurentAdderess: 'Old Town',
      restaurentDistance: '4.2 km',
    ),
    PopularRestaurentModel(
      restaurentImage: 'assets/images/restaurent11.jpeg',
      restaurentName: 'Urban Bites',
      restaurentRating: '4.0',
      restaurentItemCategory: 'Fast Food',
      restaurentItemPrice: 'Rs. 230 for one',
      restaurentAdderess: 'Downtown',
      restaurentDistance: '900 m',
    ),
    PopularRestaurentModel(
      restaurentImage: 'assets/images/restaurent12.jpeg',
      restaurentName: 'Taste of India',
      restaurentRating: '4.4',
      restaurentItemCategory: 'Indian Cuisine',
      restaurentItemPrice: 'Rs. 290 for one',
      restaurentAdderess: 'Lake Road',
      restaurentDistance: '3.8 km',
    ),
    PopularRestaurentModel(
      restaurentImage: 'assets/images/restaurent13.jpeg',
      restaurentName: 'Spice Route',
      restaurentRating: '4.3',
      restaurentItemCategory: 'Asian & Chinese',
      restaurentItemPrice: 'Rs. 340 for one',
      restaurentAdderess: 'Business District',
      restaurentDistance: '5 km',
    ),
    PopularRestaurentModel(
      restaurentImage: 'assets/images/restaurent14.jpeg',
      restaurentName: 'The Food Street',
      restaurentRating: '4.2',
      restaurentItemCategory: 'Street Food',
      restaurentItemPrice: 'Rs. 200 for one',
      restaurentAdderess: 'Food Market',
      restaurentDistance: '1.4 km',
    ),
    PopularRestaurentModel(
      restaurentImage: 'assets/images/restaurent15.jpeg',
      restaurentName: 'Royal Spice',
      restaurentRating: '4.1',
      restaurentItemCategory: 'Multi Cuisine',
      restaurentItemPrice: 'Rs. 310 for one',
      restaurentAdderess: 'City Road',
      restaurentDistance: '4.5 km',
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