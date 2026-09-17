import 'package:flutter/material.dart';

class Burger extends StatefulWidget {
  const Burger({super.key});

  @override
  State<Burger> createState() => _BurgerState();
}

class _BurgerState extends State<Burger> {
  final List<Map<String, dynamic>> burgers = [
    {
      'name': 'Chicken Burger',
      'price': 40,
      'image': 'assets/images/burger1.jpeg',
    },
    {
      'name': 'Veg Burger',
      'price': 40,
      'image': 'assets/images/burger2.jpeg',
    },
    {
      'name': 'Cheese Burger',
      'price': 40,
      'image': 'assets/images/burger6.jpeg',
    },
    {
      'name': 'Lentil and Mushroom Burger',
      'price': 40,
      'image': 'assets/images/burger4.jpeg',
    },
    {
      'name': 'Stuffed Bean Burger',
      'price': 40,
      'image': 'assets/images/burger11.jpeg',
    },
    {
      'name': 'Lamb Burger with Radish Slaw',
      'price': 40,
      'image': 'assets/images/burger12.jpeg',
    },
    {
      'name': 'Potato Corn Burger',
      'price': 40,
      'image': 'assets/images/burger3.jpeg',
    },
    {
      'name': 'Supreme Veggie Burger',
      'price': 40,
      'image': 'assets/images/burger7.jpeg',
    },
    {
      'name': 'Butter Chicken Twin Burgers',
      'price': 40,
      'image': 'assets/images/burger9.jpeg',
    },
    {
      'name': 'Rajma Patty Burger',
      'price': 40,
      'image': 'assets/images/burger7.jpeg',
    },
    {
      'name': 'Pizza Burger',
      'price': 40,
      'image': 'assets/images/burger4.jpeg',
    },
  ];

  late List<int> quantities;

  @override
  void initState() {
    super.initState();
    quantities = List<int>.filled(burgers.length, 0);
  }

  void increment(int index) {
    if (quantities[index] < 9) {
      setState(() {
        quantities[index]++;
      });
    }
  }

  void decrement(int index) {
    if (quantities[index] > 0) {
      setState(() {
        quantities[index]--;
      });
    }
  }

  int get totalItems {
    return quantities.fold(0, (sum, quantity) => sum + quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
        backgroundColor: const Color(0xFF1565C0),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Burgers',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Use the main FoodHub cart to review your items.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                ),
                if (totalItems > 0)
                  Positioned(
                    right: 4,
                    top: 7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        totalItems.toString(),
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
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE3F2FD),
              Colors.white,
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: burgers.length,
          itemBuilder: (context, index) {
            final burger = burgers[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        burger['image'],
                        height: 75,
                        width: 75,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 75,
                            width: 75,
                            color: const Color(0xFFE3F2FD),
                            child: const Icon(
                              Icons.fastfood,
                              color: Color(0xFF1565C0),
                              size: 35,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            burger['name'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Rs. ${burger['price']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1565C0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              decrement(index);
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 38,
                            ),
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          Text(
                            quantities[index].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              increment(index);
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 38,
                            ),
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}