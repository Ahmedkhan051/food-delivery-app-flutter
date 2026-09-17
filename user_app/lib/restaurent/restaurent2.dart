import 'package:flutter/material.dart';

import 'package:user_app/restaurent/restaurent1Model.dart';

class Restaurent2 extends StatelessWidget {
  const Restaurent2({super.key});

  static final List<Restaurent1Model> restaurants = [
    Restaurent1Model(
      imageLink: 'assets/images/veg10.jpeg',
      restaurentItemNameAndPrice: 'Chilli Paneer • ₹295',
      icon1: Icons.favorite_border,
      restaurentName: 'Naivedyam By Moti Mahal',
      restaurentItemCategory: 'Pure Veg • North Indian • Chinese',
      restaurentItemCategoryIcon: Icons.eco,
      restaurentRating: '4.0',
      restaurentDiscount: '40% off up to ₹100',
      deliveryTiming: '40-50 min',
      restaurentDistance: '10 km',
      restaurentPrice: '₹250 for one',
    ),
    Restaurent1Model(
      imageLink: 'assets/images/veg9.jpeg',
      restaurentItemNameAndPrice: 'Paneer Tikka • ₹280',
      icon1: Icons.favorite_border,
      restaurentName: 'Green Leaf Kitchen',
      restaurentItemCategory: 'Pure Veg • Indian',
      restaurentItemCategoryIcon: Icons.eco,
      restaurentRating: '4.2',
      restaurentDiscount: '30% off up to ₹100',
      deliveryTiming: '35-45 min',
      restaurentDistance: '8 km',
      restaurentPrice: '₹220 for one',
    ),
    Restaurent1Model(
      imageLink: 'assets/images/veg8.jpeg',
      restaurentItemNameAndPrice: 'Veg Biryani • ₹260',
      icon1: Icons.favorite_border,
      restaurentName: 'Veggie Delight',
      restaurentItemCategory: 'Biryani • North Indian',
      restaurentItemCategoryIcon: Icons.eco,
      restaurentRating: '4.4',
      restaurentDiscount: '25% off up to ₹90',
      deliveryTiming: '30-40 min',
      restaurentDistance: '6 km',
      restaurentPrice: '₹210 for one',
    ),
    Restaurent1Model(
      imageLink: 'assets/images/veg7.jpeg',
      restaurentItemNameAndPrice: 'Masala Dosa • ₹180',
      icon1: Icons.favorite_border,
      restaurentName: 'South Spice',
      restaurentItemCategory: 'South Indian • Vegetarian',
      restaurentItemCategoryIcon: Icons.eco,
      restaurentRating: '4.3',
      restaurentDiscount: '20% off up to ₹80',
      deliveryTiming: '25-35 min',
      restaurentDistance: '5 km',
      restaurentPrice: '₹170 for one',
    ),
    Restaurent1Model(
      imageLink: 'assets/images/veg6.jpeg',
      restaurentItemNameAndPrice: 'Veg Manchurian • ₹230',
      icon1: Icons.favorite_border,
      restaurentName: 'Urban Veg House',
      restaurentItemCategory: 'Chinese • Fast Food',
      restaurentItemCategoryIcon: Icons.eco,
      restaurentRating: '4.1',
      restaurentDiscount: '35% off up to ₹100',
      deliveryTiming: '35-45 min',
      restaurentDistance: '9 km',
      restaurentPrice: '₹200 for one',
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
                                  Icons.restaurant,
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
                              padding: const EdgeInsets.symmetric(
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
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${restaurant.restaurentName} added to favourites",
                                    ),
                                    duration:
                                    const Duration(seconds: 1),
                                  ),
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
                                    padding: const EdgeInsets.all(8),
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
                                        size: 14,
                                        color: Colors.white,
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
                              overflow: TextOverflow.ellipsis,
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