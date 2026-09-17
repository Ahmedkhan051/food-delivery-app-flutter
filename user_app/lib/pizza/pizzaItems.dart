import 'package:flutter/material.dart';

class PizzaItems1 extends StatelessWidget {
  const PizzaItems1({super.key});

  static const List<Map<String, String>> pizzaItems = [
    {
      "image": "assets/images/pizza1.jpeg",
      "offer": "20% OFF",
      "name": "Chicken Pizza",
      "rating": "4.4",
    },
    {
      "image": "assets/images/pizza2.jpeg",
      "offer": "15% OFF",
      "name": "Veg Pizza",
      "rating": "4.3",
    },
    {
      "image": "assets/images/pizza3.jpeg",
      "offer": "20% OFF",
      "name": "Cheese Pizza",
      "rating": "4.5",
    },
    {
      "image": "assets/images/pizza5.jpeg",
      "offer": "25% OFF",
      "name": "Stuffed Bean Pizza",
      "rating": "4.2",
    },
  ];

  void showSelection(
      BuildContext context,
      String name,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$name selected"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: PageView.builder(
        itemCount: pizzaItems.length,
        controller: PageController(
          viewportFraction: 0.92,
        ),
        itemBuilder: (context, index) {
          final item = pizzaItems[index];

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 8,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                showSelection(
                  context,
                  item["name"]!,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      item["image"]!,
                      fit: BoxFit.cover,
                      errorBuilder: (
                          context,
                          error,
                          stackTrace,
                          ) {
                        return Container(
                          color: Colors.blue.shade50,
                          child: const Icon(
                            Icons.local_pizza,
                            size: 70,
                            color: Colors.blue,
                          ),
                        );
                      },
                    ),

                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.75),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item["rating"]!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      left: 14,
                      right: 14,
                      bottom: 14,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["offer"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item["name"]!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }
}