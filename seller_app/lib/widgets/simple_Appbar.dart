import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final PreferredSizeWidget? bottom;

  const SimpleAppBar({
    super.key,
    this.bottom,
    this.title,
  });

  @override
  Size get preferredSize {
    return bottom == null
        ? const Size.fromHeight(56)
        : const Size.fromHeight(136);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF42A5F5),
      foregroundColor: Colors.white,
      elevation: 0,

      automaticallyImplyLeading: true,

      title: Text(
        title ?? "FoodHub",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),

      centerTitle: true,

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

      bottom: bottom,
    );
  }
}