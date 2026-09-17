import 'package:flutter/material.dart';

class Pizza extends StatelessWidget {
  const Pizza({super.key});

  static const List<Map<String, String>> pizzaItems = [
    {
      "image": "assets/images/pizza1.jpeg",
      "name": "Chicken Pizza",
      "price": "₹180",
    },
    {
      "image": "assets/images/pizza2.jpeg",
      "name": "Veg Pizza",
      "price": "₹150",
    },
    {
      "image": "assets/images/pizza3.jpeg",
      "name": "Cheese Pizza",
      "price": "₹170",
    },
    {
      "image": "assets/images/pizza8.jpeg",
      "name": "Lentil & Mushroom Pizza",
      "price": "₹190",
    },
    {
      "image": "assets/images/pizza5.jpeg",
      "name": "Stuffed Bean Pizza",
      "price": "₹180",
    },
    {
      "image": "assets/images/pizza6.jpeg",
      "name": "Lamb Pizza",
      "price": "₹220",
    },
    {
      "image": "assets/images/pizza7.jpeg",
      "name": "Potato Corn Pizza",
      "price": "₹160",
    },
    {
      "image": "assets/images/pizza8.jpeg",
      "name": "Supreme Veggie Pizza",
      "price": "₹200",
    },
    {
      "image": "assets/images/pizza9.jpeg",
      "name": "Butter Chicken Pizza",
      "price": "₹210",
    },
    {
      "image": "assets/images/pizza10.jpeg",
      "name": "Rajma Patty Pizza",
      "price": "₹170",
    },
  ];

  void addToCartMessage(
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
          "Pizza",
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
        itemCount: pizzaItems.length,
        itemBuilder: (context, index) {
          final item = pizzaItems[index];

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
                        Icons.local_pizza,
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
                  addToCartMessage(
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