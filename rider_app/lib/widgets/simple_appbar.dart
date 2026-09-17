import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final PreferredSizeWidget? bottom;

  const SimpleAppBar({
    super.key,
    this.title,
    this.bottom,
  });

  @override
  Size get preferredSize {
    return Size.fromHeight(
      56 + (bottom?.preferredSize.height ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      centerTitle: true,
      elevation: 3,
      backgroundColor: Colors.transparent,

      iconTheme: const IconThemeData(
        color: Colors.white,
      ),

      title: Text(
        title?.trim().isNotEmpty == true
            ? title!.trim()
            : "FoodHub",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),

      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1565C0),
              Color(0xFF42A5F5),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),

      bottom: bottom,
    );
  }
}