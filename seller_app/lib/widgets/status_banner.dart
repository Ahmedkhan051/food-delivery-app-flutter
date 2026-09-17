import 'package:flutter/material.dart';

import '../mainScreens/home_screen.dart';

class StatusBanner extends StatelessWidget {
  final bool? status;
  final String? orderStatus;

  const StatusBanner({
    super.key,
    this.status,
    this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF1565C0);
    const Color mediumBlue = Color(0xFF42A5F5);

    final bool isSuccessful = status ?? false;

    final String message =
    isSuccessful ? "Successful" : "Unsuccessful";

    final IconData iconData =
    isSuccessful ? Icons.done : Icons.cancel;

    final bool isEnded = orderStatus == "ended";

    return Container(
      height: 50,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF90CAF9),
            Color(0xFF42A5F5),
            Color(0xFF1565C0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Text(
              isEnded
                  ? "Parcel Delivered • $message"
                  : "Order Placed • $message",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 8),

          CircleAvatar(
            radius: 10,
            backgroundColor: Colors.white.withValues(alpha: 0.25),
            child: Icon(
              iconData,
              color: Colors.white,
              size: 14,
            ),
          ),

          const SizedBox(width: 15),
        ],
      ),
    );
  }
}