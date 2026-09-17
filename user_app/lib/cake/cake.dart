import 'package:flutter/material.dart';

class Cake extends StatelessWidget {
  const Cake({super.key});

  final List<Map<String, String>> cakes = const [
    {
      'name': 'Chocolate Cake',
      'price': '40',
      'image': 'assets/images/cake1.jpeg',
    },
    {
      'name': 'Strawberry Cake',
      'price': '40',
      'image': 'assets/images/cake2.jpeg',
    },
    {
      'name': 'Vanilla Cake',
      'price': '40',
      'image': 'assets/images/cake3.jpeg',
    },
    {
      'name': 'Black Forest Cake',
      'price': '40',
      'image': 'assets/images/cake4.jpeg',
    },
    {
      'name': 'Red Velvet Cake',
      'price': '40',
      'image': 'assets/images/cake5.jpeg',
    },
    {
      'name': 'Butterscotch Cake',
      'price': '40',
      'image': 'assets/images/cake6.jpeg',
    },
    {
      'name': 'Pineapple Cake',
      'price': '40',
      'image': 'assets/images/cake7.jpeg',
    },
    {
      'name': 'Fruit Cake',
      'price': '40',
      'image': 'assets/images/cake8.jpeg',
    },
    {
      'name': 'Cream Cake',
      'price': '40',
      'image': 'assets/images/cake9.jpeg',
    },
    {
      'name': 'Mango Cake',
      'price': '40',
      'image': 'assets/images/cake12.jpeg',
    },
    {
      'name': 'Coffee Cake',
      'price': '40',
      'image': 'assets/images/cake11.jpeg',
    },
  ];

  void showAddedMessage(BuildContext context, String cakeName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$cakeName selected.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        toolbarHeight: 60,
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
          'Cakes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        centerTitle: true,
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
          itemCount: cakes.length,
          itemBuilder: (context, index) {
            final cake = cakes[index];

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
                        cake['image']!,
                        height: 75,
                        width: 75,
                        fit: BoxFit.cover,
                        errorBuilder: (
                            context,
                            error,
                            stackTrace,
                            ) {
                          return Container(
                            height: 75,
                            width: 75,
                            color: const Color(0xFFE3F2FD),
                            child: const Icon(
                              Icons.cake_outlined,
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
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            cake['name']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Rs. ${cake['price']} Only',
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
                    IconButton(
                      onPressed: () {
                        showAddedMessage(
                          context,
                          cake['name']!,
                        );
                      },
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Color(0xFF1565C0),
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