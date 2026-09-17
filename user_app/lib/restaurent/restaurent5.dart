import 'package:flutter/material.dart';

import 'package:user_app/restaurent/restaurent1Model.dart';

class Restaurent5 extends StatelessWidget {
  const Restaurent5({super.key});

  static final List<Restaurent1Model> restaurants = [
    Restaurent1Model(
      imageLink: 'assets/images/burger1.jpeg',
      restaurentItemNameAndPrice: 'Classic Burger • ₹160',
      icon1: Icons.favorite_border,
      restaurentName: 'Mc Donald',
      restaurentItemCategory: 'Burgers • Fast Food',
      restaurentItemCategoryIcon: Icons.lunch_dining,
      restaurentRating: '4.4',
      restaurentDiscount: '40% off up to ₹100',
      deliveryTiming: '25-35 min',
      restaurentDistance: '5 km',
      restaurentPrice: '₹180 for one',
    ),
    Restaurent1Model(
      imageLink: 'assets/images/burger2.jpeg',
      restaurentItemNameAndPrice: 'Cheese Burger • ₹190',
      icon1: Icons.favorite_border,
      restaurentName: 'Burger Point',
      restaurentItemCategory: 'Burgers • Snacks',
      restaurentItemCategoryIcon: Icons.lunch_dining,
      restaurentRating: '4.3',
      restaurentDiscount: '30% off up to ₹80',
      deliveryTiming: '30-40 min',
      restaurentDistance: '6 km',
      restaurentPrice: '₹200 for one',
    ),
    Restaurent1Model(
      imageLink: 'assets/images/burger3.jpeg',
      restaurentItemNameAndPrice: 'Chicken Burger • ₹210',
      icon1: Icons.favorite_border,
      restaurentName: 'Burger Hub',
      restaurentItemCategory: 'Chicken • Fast Food',
      restaurentItemCategoryIcon: Icons.lunch_dining,
      restaurentRating: '4.5',
      restaurentDiscount: '25% off up to ₹100',
      deliveryTiming: '25-35 min',
      restaurentDistance: '7 km',
      restaurentPrice: '₹220 for one',
    ),
    Restaurent1Model(
      imageLink: 'assets/images/burger4.jpeg',
      restaurentItemNameAndPrice: 'Veggie Burger • ₹170',
      icon1: Icons.favorite_border,
      restaurentName: 'Urban Burger',
      restaurentItemCategory: 'Veg • Burgers',
      restaurentItemCategoryIcon: Icons.lunch_dining,
      restaurentRating: '4.2',
      restaurentDiscount: '20% off up to ₹70',
      deliveryTiming: '30-40 min',
      restaurentDistance: '8 km',
      restaurentPrice: '₹190 for one',
    ),
    Restaurent1Model(
      imageLink: 'assets/images/burger6.jpeg',
      restaurentItemNameAndPrice: 'Double Patty Burger • ₹240',
      icon1: Icons.favorite_border,
      restaurentName: 'Big Bite',
      restaurentItemCategory: 'Burgers • Combos',
      restaurentItemCategoryIcon: Icons.lunch_dining,
      restaurentRating: '4.1',
      restaurentDiscount: '35% off up to ₹120',
      deliveryTiming: '35-45 min',
      restaurentDistance: '9 km',
      restaurentPrice: '₹250 for one',
    ),
  ];

  void showRestaurantMessage(
      BuildContext context,
      Restaurent1Model restaurant,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${restaurant.restaurentName} selected",
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void addFavourite(
      BuildContext context,
      String restaurantName,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "$restaurantName added to favourites",
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: PageView.builder(
        controller: PageController(
          viewportFraction: 0.90,
        ),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final Restaurent1Model restaurant =
          restaurants[index];

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 8,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                showRestaurantMessage(
                  context,
                  restaurant,
                );
              },
              child: Card(
                elevation: 3,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 6,
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
                                color: Colors.blue.shade50,
                                child: const Icon(
                                  Icons.lunch_dining,
                                  size: 70,
                                  color: Colors.blue,
                                ),
                              );
                            },
                          ),

                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius:
                                BorderRadius.circular(8),
                              ),
                              child: Text(
                                restaurant
                                    .restaurentItemNameAndPrice,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              onPressed: () {
                                addFavourite(
                                  context,
                                  restaurant.restaurentName,
                                );
                              },
                              icon: const Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding:
                                    const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      restaurant
                                          .restaurentDiscount,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize:
                                    MainAxisSize.min,
                                    children: [
                                      Text(
                                        restaurant.restaurentRating,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      const Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.restaurentName,
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Row(
                              children: [
                                Icon(
                                  restaurant
                                      .restaurentItemCategoryIcon,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    restaurant
                                        .restaurentItemCategory,
                                    maxLines: 1,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  restaurant.deliveryTiming,
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  restaurant.restaurentDistance,
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  restaurant.restaurentPrice,
                                  style: const TextStyle(
                                    color: Color(0xFF1565C0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}