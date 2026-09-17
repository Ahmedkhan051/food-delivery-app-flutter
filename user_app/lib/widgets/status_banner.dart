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

    final IconData iconData = isSuccessful
        ? Icons.done
        : Icons.cancel;

    final String normalizedStatus =
        orderStatus?.trim().toLowerCase() ?? "placed";

    String statusText;

    switch (normalizedStatus) {
      case "confirmed":
        statusText = "Order Confirmed";
        break;

      case "preparing":
        statusText = "Preparing Your Order";
        break;

      case "out for delivery":
        statusText = "Out for Delivery";
        break;

      case "delivered":
        statusText = "Parcel Delivered";
        break;

      case "placed":
      default:
        statusText = "Order Placed";
        break;
    }

    final String resultText = isSuccessful ? "Successful" : "Unsuccessful";

    return Container(
      height: 50,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            tooltip: "Back",
          ),

          const SizedBox(width: 3),

          Flexible(
            child: Text(
              "$statusText - $resultText",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 7),

          CircleAvatar(
            radius: 9,
            backgroundColor: Colors.white,
            child: Icon(
              iconData,
              color: const Color(0xFF1565C0),
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}