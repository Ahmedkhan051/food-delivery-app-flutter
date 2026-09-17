import 'package:flutter/material.dart';

class Veg extends StatelessWidget {
  const Veg({super.key});

  static const List<Map<String, String>> vegItems = [
    {
      "image": "assets/images/veg1.jpeg",
      "name": "Paneer Tikka",
      "price": "₹180",
    },
    {
      "image": "assets/images/veg2.jpeg",
      "name": "Veg Biryani",
      "price": "₹160",
    },
    {
      "image": "assets/images/veg3.jpeg",
      "name": "Masala Dosa",
      "price": "₹120",
    },
    {
      "image": "assets/images/veg4.jpeg",
      "name": "Veg Manchurian",
      "price": "₹150",
    },
    {
      "image": "assets/images/veg5.jpeg",
      "name": "Paneer Butter Masala",
      "price": "₹190",
    },
    {
      "image": "assets/images/veg6.jpeg",
      "name": "Veg Noodles",
      "price": "₹140",
    },
    {
      "image": "assets/images/veg7.jpeg",
      "name": "Chole Bhature",
      "price": "₹170",
    },
    {
      "image": "assets/images/veg8.jpeg",
      "name": "Veg Pizza",
      "price": "₹180",
    },
    {
      "image": "assets/images/veg9.jpeg",
      "name": "Palak Paneer",
      "price": "₹175",
    },
    {
      "image": "assets/images/veg10.jpeg",
      "name": "Veg Thali",
      "price": "₹220",
    },
  ];

  void showItemMessage(
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF42A5F5),
        foregroundColor: Colors.white,
        elevation: 3,
        title: const Text(
          "Veg Food",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 20,
        ),
        itemCount: vegItems.length,
        itemBuilder: (context, index) {
          final item = vegItems[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  item["image"]!,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return Container(
                      width: 70,
                      height: 70,
                      color: Colors.blue.shade50,
                      child: const Icon(
                        Icons.eco,
                        color: Colors.blue,
                        size: 35,
                      ),
                    );
                  },
                ),
              ),
              title: Text(
                item["name"]!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  item["price"]!,
                  style: const TextStyle(
                    color: Color(0xFF1565C0),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  showItemMessage(
                    context,
                    item["name"]!,
                  );
                },
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Color(0xFF1976D2),
                ),
                tooltip: "Add to cart",
              ),
            ),
          );
        },
      ),
    );
  }
}