import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/global/global.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final List<String> orderStatuses = [
    "Placed",
    "Confirmed",
    "Preparing",
    "Packed",
    "Out for Delivery",
    "Delivered",
  ];

  IconData getStatusIcon(String status) {
    switch (status) {
      case "Placed":
        return Icons.shopping_bag_outlined;

      case "Confirmed":
        return Icons.check_circle_outline;

      case "Preparing":
        return Icons.restaurant_outlined;

      case "Packed":
        return Icons.inventory_2_outlined;

      case "Out for Delivery":
        return Icons.delivery_dining;

      case "Delivered":
        return Icons.done_all;

      default:
        return Icons.notifications_outlined;
    }
  }

  String getNotificationTitle(String status) {
    switch (status) {
      case "Placed":
        return "Order Placed";

      case "Confirmed":
        return "Order Confirmed";

      case "Preparing":
        return "Food is Being Prepared";

      case "Packed":
        return "Order Packed";

      case "Out for Delivery":
        return "Order Out for Delivery";

      case "Delivered":
        return "Order Delivered";

      default:
        return "Order Update";
    }
  }

  String getNotificationMessage(String status) {
    switch (status) {
      case "Placed":
        return "Your order has been placed successfully.";

      case "Confirmed":
        return "The restaurant has confirmed your order.";

      case "Preparing":
        return "Your food is now being prepared.";

      case "Packed":
        return "Your order is packed and ready for pickup.";

      case "Out for Delivery":
        return "Your order is on the way to your delivery address.";

      case "Delivered":
        return "Your order has been delivered successfully. Enjoy your meal!";

      default:
        return "There is an update on your order.";
    }
  }

  String formatOrderDate(dynamic value) {
    DateTime? date;

    if (value is Timestamp) {
      date = value.toDate();
    } else if (value is DateTime) {
      date = value;
    } else if (value is int) {
      date = DateTime.fromMillisecondsSinceEpoch(value);
    } else if (value is String) {
      date = DateTime.tryParse(value);
    }

    if (date == null) {
      return "";
    }

    String twoDigits(int number) {
      return number.toString().padLeft(2, '0');
    }

    return "${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year} "
        "${twoDigits(date.hour)}:${twoDigits(date.minute)}";
  }

  DateTime getOrderTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    if (value is String) {
      return DateTime.tryParse(value) ??
          DateTime.fromMillisecondsSinceEpoch(0);
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  List<Map<String, dynamic>> buildNotifications(
      List<QueryDocumentSnapshot> orders,
      ) {
    final List<Map<String, dynamic>> notifications = [];

    for (final order in orders) {
      final Map<String, dynamic> data =
      order.data() as Map<String, dynamic>;

      final String status =
      (data["status"] ?? "Placed").toString().trim();

      final String orderId =
      (data["orderId"] ?? order.id).toString();

      notifications.add({
        "title": getNotificationTitle(status),
        "message": getNotificationMessage(status),
        "status": status,
        "orderId": orderId,
        "time": formatOrderDate(data["orderTime"]),
        "orderTime": getOrderTime(data["orderTime"]),
        "icon": getStatusIcon(status),
      });
    }

    notifications.sort((a, b) {
      final DateTime aTime = a["orderTime"] as DateTime;
      final DateTime bTime = b["orderTime"] as DateTime;

      return bTime.compareTo(aTime);
    });

    return notifications;
  }

  Widget buildNotificationCard(
      BuildContext context,
      Map<String, dynamic> notification,
      ) {
    final String status = notification["status"] as String;
    final IconData icon = notification["icon"] as IconData;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 25,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification["title"] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      status,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  notification["message"] as String,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.35,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.receipt_long_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        "Order: ${notification["orderId"]}",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    if ((notification["time"] as String).isNotEmpty) ...[
                      const SizedBox(width: 8),

                      Text(
                        notification["time"] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNotificationsContent(
      BuildContext context,
      String uid,
      ) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("orders")
          .where(
        "orderedBy",
        isEqualTo: uid,
      )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Unable to load notifications.\n\n${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        }

        final List<QueryDocumentSnapshot> orders =
            snapshot.data?.docs ?? [];

        if (orders.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "No notifications yet",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Your order updates will appear here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final List<Map<String, dynamic>> notifications =
        buildNotifications(orders);

        return ListView(
          padding: const EdgeInsets.all(15),
          children: [
            const Text(
              "Order Updates",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              "Latest status of your orders.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 15),

            ...notifications.map(
                  (notification) => buildNotificationCard(
                context,
                notification,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String uid =
        sharedPreferences?.getString("uid") ?? "";

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: uid.isEmpty
          ? const Center(
        child: Text(
          "Please login to view notifications.",
        ),
      )
          : buildNotificationsContent(
        context,
        uid,
      ),
    );
  }
}