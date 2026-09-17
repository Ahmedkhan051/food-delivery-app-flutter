import 'package:flutter/material.dart';

class VegItems1 extends StatelessWidget {
  const VegItems1({super.key});

  static const List<Map<String, String>> vegItems = [
    {
      "image": "assets/images/veg1.jpeg",
      "offer": "20% OFF",
      "name": "Paneer Tikka",
      "rating": "4.4",
    },
    {
      "image": "assets/images/veg2.jpeg",
      "offer": "30% OFF",
      "name": "Veg Biryani",
      "rating": "4.3",
    },
    {
      "image": "assets/images/veg3.jpeg",
      "offer": "25% OFF",
      "name": "Masala Dosa",
      "rating": "4.5",
    },
    {
      "image": "assets/images/veg4.jpeg",
      "offer": "20% OFF",
      "name": "Veg Manchurian",
      "rating": "4.2",
    },
  ];

  void showSelection(
      BuildContext context,
      String itemName,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$itemName selected"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: PageView.builder(
        controller: PageController(
          viewportFraction: 0.92,
        ),
        itemCount: vegItems.length,
        itemBuilder: (context, index) {
          final Map<String, String> item = vegItems[index];

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
                            Icons.eco,
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