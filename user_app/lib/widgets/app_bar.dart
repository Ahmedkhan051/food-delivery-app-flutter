import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/mainScreens/cart_screen.dart';

class MyAppbar extends StatefulWidget
    implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  final String? sellerUID;

  const MyAppbar({
    super.key,
    this.bottom,
    this.sellerUID,
  });

  @override
  State<MyAppbar> createState() => _MyAppbarState();

  @override
  Size get preferredSize => bottom == null
      ? Size(
    56,
    AppBar().preferredSize.height,
  )
      : Size(
    56,
    80 + AppBar().preferredSize.height,
  );
}

class _MyAppbarState extends State<MyAppbar> {
  static const Color mediumBlue = Color(0xFF42A5F5);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: mediumBlue,
      elevation: 3,

      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF90CAF9),
              Color(0xFF42A5F5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),

      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        tooltip: "Back",
      ),

      title: const Text(
        "FoodHub",
        style: TextStyle(
          fontSize: 38,
          fontFamily: "Train",
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),

      centerTitle: true,

      actions: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(
                      sellerUID: widget.sellerUID,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              tooltip: "Cart",
            ),

            Positioned(
              top: 4,
              right: 2,
              child: Consumer<CartItemCounter>(
                builder: (context, counter, child) {
                  return Container(
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      counter.count.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF1565C0),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}