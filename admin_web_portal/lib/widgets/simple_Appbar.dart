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
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 3,
      backgroundColor: Colors.transparent,

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

      title: Text(
        title?.trim().isNotEmpty == true
            ? title!.trim()
            : "FoodHub Admin",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),

      bottom: bottom,
    );
  }
}