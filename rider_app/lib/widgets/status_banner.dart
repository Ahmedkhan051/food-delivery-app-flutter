import 'package:flutter/material.dart';

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
    final bool isSuccessful = status ?? false;

    final String currentStatus =
    orderStatus?.trim().isNotEmpty == true
        ? orderStatus!.trim()
        : "Unknown";

    final bool isDelivered =
        currentStatus.toLowerCase() == "delivered";

    final IconData iconData =
    isSuccessful
        ? Icons.check_circle
        : Icons.cancel;

    final String message =
    isSuccessful
        ? "Successful"
        : "Unsuccessful";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
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
      height: 52,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              // Return to the actual previous screen.
              // Do not push HomeScreen or SplashScreen.
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            tooltip: "Back",
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              isDelivered
                  ? "Parcel Delivered • $message"
                  : "Order • $currentStatus • $message",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Icon(
            iconData,
            color: Colors.white,
            size: 22,
          ),
        ],
      ),
    );
  }
}