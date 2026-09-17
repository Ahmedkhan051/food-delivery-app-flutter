import 'package:flutter/material.dart';

import 'package:user_app/dining/PopularRestaurentItemsModel.dart';

class PopularRestaurentItems extends StatelessWidget {
  const PopularRestaurentItems({super.key});

  static const List<PopularRestaurentItemsModel> restaurants = [
    PopularRestaurentItemsModel(
      restaurentImage: 'assets/images/restaurent9.jpeg',
      restaurentName: 'JB Celebrations',
      restaurentItemPrice: 'Rs. 300 for one',
      restaurentAddress: 'Alambag',
      restaurentDistance: '100 m',
      restaurentRating: '4.5',
      restaurentItemCategory: 'Mithai & Street Food',
    ),
    PopularRestaurentItemsModel(
      restaurentImage: 'assets/images/restaurent1.jpeg',
      restaurentName: 'Cheers N Beers',
      restaurentItemPrice: 'Rs. 250 for one',
      restaurentAddress: 'Alambag',
      restaurentDistance: '1 km',
      restaurentRating: '4.0',
      restaurentItemCategory: 'Beers & Drinks',
    ),
    PopularRestaurentItemsModel(
      restaurentImage: 'assets/images/restaurent8.jpeg',
      restaurentName: 'Skyhilton',
      restaurentItemPrice: 'Rs. 300 for one',
      restaurentAddress: 'Alambag',
      restaurentDistance: '5 km',
      restaurentRating: '4.5',
      restaurentItemCategory: 'Family Restaurant',
    ),
    PopularRestaurentItemsModel(
      restaurentImage: 'assets/images/restaurent3.jpeg',
      restaurentName: 'Royal Cafe',
      restaurentItemPrice: 'Rs. 350 for one',
      restaurentAddress: 'Alambag',
      restaurentDistance: '2 km',
      restaurentRating: '4.3',
      restaurentItemCategory: 'Cafe & Snacks',
    ),
    PopularRestaurentItemsModel(
      restaurentImage: 'assets/images/restaurent6.jpeg',
      restaurentName: 'Awadh Restaurant',
      restaurentItemPrice: 'Rs. 250 for one',
      restaurentAddress: 'Alambag',
      restaurentDistance: '2 km',
      restaurentRating: '4.5',
      restaurentItemCategory: 'Pure Veg',
    ),
    PopularRestaurentItemsModel(
      restaurentImage: 'assets/images/restaurent2.jpeg',
      restaurentName: 'Best Choice Of Awadh',
      restaurentItemPrice: 'Rs. 280 for one',
      restaurentAddress: 'Alambag',
      restaurentDistance: '800 m',
      restaurentRating: '4.4',
      restaurentItemCategory: 'North Indian',
    ),
    PopularRestaurentItemsModel(
      restaurentImage: 'assets/images/restaurent4.jpeg',
      restaurentName: 'Theka-The Piccadily',
      restaurentItemPrice: 'Rs. 450 for one',
      restaurentAddress: 'Alambag',
      restaurentDistance: '3 km',
      restaurentRating: '4.5',
      restaurentItemCategory: 'Multi Cuisine',
    ),
    PopularRestaurentItemsModel(
      restaurentImage: 'assets/images/restaurent5.jpeg',
      restaurentName: 'Punjab-The Piccadily',
      restaurentItemPrice: 'Rs. 320 for one',
      restaurentAddress: 'Alambag',
      restaurentDistance: '1.5 km',
      restaurentRating: '4.2',
      restaurentItemCategory: 'Punjabi',
    ),
    PopularRestaurentItemsModel(
      restaurentImage: 'assets/images/restaurent10.jpeg',
      restaurentName: 'Tunde Kababi',
      restaurentItemPrice: 'Rs. 300 for one',
      restaurentAddress: 'Alambag',
      restaurentDistance: '2.5 km',
      restaurentRating: '4.6',
      restaurentItemCategory: 'Kebab & Mughlai',
    ),
    PopularRestaurentItemsModel(
      restaurentImage: 'assets/images/restaurent7.jpeg',
      restaurentName: 'Royal Spice',
      restaurentItemPrice: 'Rs. 260 for one',
      restaurentAddress: 'Alambag',
      restaurentDistance: '4 km',
      restaurentRating: '4.1',
      restaurentItemCategory: 'Indian',
    ),
    PopularRestaurentItemsModel(
      restaurentImage: 'assets/images/restaurent11.jpeg',
      restaurentName: 'Food Junction',
      restaurentItemPrice: 'Rs. 220 for one',
      restaurentAddress: 'Alambag',
      restaurentDistance: '1.2 km',
      restaurentRating: '4.2',
      restaurentItemCategory: 'Fast Food',
    ),
    PopularRestaurentItemsModel(
      restaurentImage: 'assets/images/restaurent12.jpeg',
      restaurentName: 'Taste Of India',
      restaurentItemPrice: 'Rs. 280 for one',
      restaurentAddress: 'Alambag',
      restaurentDistance: '3.5 km',
      restaurentRating: '4.4',
      restaurentItemCategory: 'Indian Cuisine',
    ),
    PopularRestaurentItemsModel(
      restaurentImage: 'assets/images/restaurent13.jpeg',
      restaurentName: 'Spice Route',
      restaurentItemPrice: 'Rs. 340 for one',
      restaurentAddress: 'Alambag',
      restaurentDistance: '4.5 km',
      restaurentRating: '4.3',
      restaurentItemCategory: 'Asian & Chinese',
    ),
    PopularRestaurentItemsModel(
      restaurentImage: 'assets/images/restaurent14.jpeg',
      restaurentName: 'Urban Bites',
      restaurentItemPrice: 'Rs. 240 for one',
      restaurentAddress: 'Alambag',
      restaurentDistance: '900 m',
      restaurentRating: '4.0',
      restaurentItemCategory: 'Fast Food',
    ),
    PopularRestaurentItemsModel(
      restaurentImage: 'assets/images/restaurent15.jpeg',
      restaurentName: 'The Food Street',
      restaurentItemPrice: 'Rs. 200 for one',
      restaurentAddress: 'Alambag',
      restaurentDistance: '1.8 km',
      restaurentRating: '4.2',
      restaurentItemCategory: 'Street Food',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: restaurants.length,
      scrollDirection: Axis.horizontal,
      controller: PageController(
        viewportFraction: 0.90,
      ),
      itemBuilder: (context, index) {
        final PopularRestaurentItemsModel restaurant =
        restaurants[index];

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 8,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                  // Restaurant image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: SizedBox(
                      height: 190,
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
                                  size: 55,
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
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
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
                                  overflow: TextOverflow.ellipsis,
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
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            restaurant.restaurentItemPrice,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 6),

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
                                  restaurant.restaurentAddress,
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Text(
                                restaurant.restaurentDistance,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

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