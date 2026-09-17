import 'package:flutter/material.dart';

class TextWidgetHeader extends SliverPersistentHeaderDelegate {
  final String? title;

  const TextWidgetHeader({
    this.title,
  });

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
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
      child: Text(
        title ?? "FoodHub",
        maxLines: 2,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontFamily: "Train",
          fontSize: 25,
          letterSpacing: 1.2,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(
      covariant TextWidgetHeader oldDelegate,
      ) {
    return oldDelegate.title != title;
  }
}