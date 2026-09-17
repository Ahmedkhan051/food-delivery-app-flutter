import 'package:flutter/material.dart';

class TextWidgetHeader extends SliverPersistentHeaderDelegate {
  final String? title;

  TextWidgetHeader({
    this.title,
  });

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    const Color darkBlue = Color(0xFF1565C0);
    const Color mediumBlue = Color(0xFF42A5F5);
    const Color lightBlue = Color(0xFF90CAF9);

    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            lightBlue,
            mediumBlue,
            darkBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        title ?? "FoodHub",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant TextWidgetHeader oldDelegate) {
    return oldDelegate.title != title;
  }
}