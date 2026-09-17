import 'package:flutter/material.dart';

class NonVeg extends StatelessWidget {
  const NonVeg({super.key});

  static const List<Map<String, String>> nonVegItems = [
    {
      "image": "assets/images/nonveg1.jpeg",
      "name": "Chicken Biryani",
      "price": "₹180",
    },
    {
      "image": "assets/images/nonveg2.jpeg",
      "name": "Chicken Tikka",
      "price": "₹160",
    },
    {
      "image": "assets/images/nonveg3.jpeg",
      "name": "Chicken Burger",
      "price": "₹140",
    },
    {
      "image": "assets/images/nonveg4.jpeg",
      "name": "Chicken Roll",
      "price": "₹100",
    },
    {
      "image": "assets/images/nonveg5.jpeg",
      "name": "Chicken Wings",
      "price": "₹150",
    },
    {
      "image": "assets/images/nonveg6.jpeg",
      "name": "Chicken Kebab",
      "price": "₹170",
    },
    {
      "image": "assets/images/nonveg7.jpeg",
      "name": "Fish Fry",
      "price": "₹190",
    },
    {
      "image": "assets/images/nonveg8.jpeg",
      "name": "Mutton Biryani",
      "price": "₹220",
    },
    {
      "image": "assets/images/nonveg10.jpeg",
      "name": "Mutton Kebab",
      "price": "₹210",
    },
    {
      "image": "assets/images/nonveg11.jpeg",
      "name": "Chicken Curry",
      "price": "₹180",
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
          "Non-Veg",
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
        itemCount: nonVegItems.length,
        itemBuilder: (context, index) {
          final item = nonVegItems[index];

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
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                  errorBuilder: (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return Container(
                      width: 65,
                      height: 65,
                      color: Colors.blue.shade50,
                      child: const Icon(
                        Icons.fastfood,
                        color: Colors.blue,
                      ),
                    );
                  },
                ),
              ),
              title: Text(
                item["name"]!,
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