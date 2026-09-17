import 'package:flutter/material.dart';

import 'package:user_app/dining/diningHomeModel.dart';

class DiningHomeList extends StatelessWidget {
  const DiningHomeList({super.key});

  static const Color deepBlue = Color(0xFF1565C0);
  static const Color mediumBlue = Color(0xFF42A5F5);
  static const Color lightBlue = Color(0xFFE3F2FD);

  static const List<DiningHomeModel> restaurants = [
    DiningHomeModel(
      imageLInk: 'assets/images/restaurent3.jpeg',
      restaurentName: 'Skyhilton',
      restaurentDiscount: '15% OFF',
      distance: '10 m away',
      rating: '4.1',
    ),
    DiningHomeModel(
      imageLInk: 'assets/images/restaurent2.jpeg',
      restaurentName: 'Best Choice Of Awadh',
      restaurentDiscount: '25% OFF',
      distance: '15 m away',
      rating: '4.3',
    ),
    DiningHomeModel(
      imageLInk: 'assets/images/restaurent4.jpeg',
      restaurentName: 'Theka-The Piccadily',
      restaurentDiscount: '20% OFF',
      distance: '50 m away',
      rating: '4.5',
    ),
    DiningHomeModel(
      imageLInk: 'assets/images/restaurent5.jpeg',
      restaurentName: 'Punjab-The Piccadily',
      restaurentDiscount: '30% OFF',
      distance: '100 m away',
      rating: '4.2',
    ),
    DiningHomeModel(
      imageLInk: 'assets/images/restaurent1.jpeg',
      restaurentName: 'Cheers N Beers',
      restaurentDiscount: '10% OFF',
      distance: '500 m away',
      rating: '4.6',
    ),
  ];

  void openRestaurantDetails(
      BuildContext context,
      DiningHomeModel restaurant,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiningRestaurantDetails(
          restaurant: restaurant,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      physics: const BouncingScrollPhysics(),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final DiningHomeModel restaurant = restaurants[index];

        return Container(
          width: 270,
          margin: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                blurRadius: 5,
                offset: Offset(0, 2),
                color: Color.fromARGB(35, 0, 0, 0),
              ),
            ],
          ),
          child: Row(
            children: [
              // Restaurant image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: SizedBox(
                  width: 125,
                  height: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        restaurant.imageLInk,
                        fit: BoxFit.cover,
                        errorBuilder: (
                            context,
                            error,
                            stackTrace,
                            ) {
                          return Container(
                            color: lightBlue,
                            child: const Icon(
                              Icons.restaurant,
                              color: deepBlue,
                              size: 40,
                            ),
                          );
                        },
                      ),

                      // Discount label
                      Positioned(
                        left: 8,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            restaurant.restaurentDiscount,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Restaurant information
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.restaurentName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: deepBlue,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        restaurant.distance,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Rating
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32),
                          borderRadius: BorderRadius.circular(6),
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
                              size: 12,
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // View Details button
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            openRestaurantDetails(
                              context,
                              restaurant,
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 13,
                          ),
                          label: const Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: deepBlue,
                            side: const BorderSide(
                              color: deepBlue,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ------------------------------------------------------------
// RESTAURANT DETAILS SCREEN
// ------------------------------------------------------------

class DiningRestaurantDetails extends StatelessWidget {
  final DiningHomeModel restaurant;

  const DiningRestaurantDetails({
    super.key,
    required this.restaurant,
  });

  static const Color deepBlue = Color(0xFF1565C0);
  static const Color mediumBlue = Color(0xFF42A5F5);
  static const Color lightBlue = Color(0xFFE3F2FD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),

      appBar: AppBar(
        backgroundColor: mediumBlue,
        elevation: 3,

        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),

        title: const Text(
          'FoodHub',
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant image
            SizedBox(
              width: double.infinity,
              height: 250,
              child: Image.asset(
                restaurant.imageLInk,
                fit: BoxFit.cover,
                errorBuilder: (
                    context,
                    error,
                    stackTrace,
                    ) {
                  return Container(
                    color: lightBlue,
                    child: const Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 90,
                        color: deepBlue,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                restaurant.restaurentName,
                style: const TextStyle(
                  color: deepBlue,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          restaurant.rating,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 15,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    restaurant.distance,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_offer_outlined,
                    color: deepBlue,
                    size: 28,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Special Offer',
                          style: TextStyle(
                            color: deepBlue,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          restaurant.restaurentDiscount,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: const Text(
                'Restaurant Information',
                style: TextStyle(
                  color: deepBlue,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            _InfoRow(
              icon: Icons.restaurant_outlined,
              title: 'Restaurant',
              value: restaurant.restaurentName,
            ),

            _InfoRow(
              icon: Icons.directions_walk,
              title: 'Distance',
              value: restaurant.distance,
            ),

            _InfoRow(
              icon: Icons.star_outline,
              title: 'Rating',
              value: restaurant.rating,
            ),

            _InfoRow(
              icon: Icons.local_offer_outlined,
              title: 'Offer',
              value: restaurant.restaurentDiscount,
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          'Opening ${restaurant.restaurentName} menu...',
                        ),
                        duration:
                        const Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.restaurant_menu,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'EXPLORE MENU',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// INFORMATION ROW
// ------------------------------------------------------------

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(20, 0, 0, 0),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF1565C0),
            size: 24,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),

          Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}