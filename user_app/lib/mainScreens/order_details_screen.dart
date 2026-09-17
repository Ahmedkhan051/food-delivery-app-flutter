import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_app/models/address.dart';

import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/shipment_address_design.dart';

import '../global/global.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? orderId;

  const OrderDetailsScreen({
    super.key,
    this.orderId,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  // =========================================================
  // ORDER STATUS LIST
  // =========================================================

  static const List<String> orderStatuses = [
    "Placed",
    "Confirmed",
    "Preparing",
    "Packed",
    "Out for Delivery",
    "Delivered",
  ];

  // =========================================================
  // STATUS INDEX
  // =========================================================

  int getStatusIndex(String status) {
    final int index = orderStatuses.indexOf(status);

    if (index == -1) {
      return 0;
    }

    return index;
  }

  // =========================================================
  // STATUS TITLE
  // =========================================================

  String getStatusTitle(String status) {
    switch (status) {
      case "Placed":
        return "Order Placed";

      case "Confirmed":
        return "Order Confirmed";

      case "Preparing":
        return "Preparing Food";

      case "Packed":
        return "Order Packed";

      case "Out for Delivery":
        return "Out for Delivery";

      case "Delivered":
        return "Delivered";

      default:
        return status;
    }
  }

  // =========================================================
  // STATUS DESCRIPTION
  // =========================================================

  String getStatusDescription(String status) {
    switch (status) {
      case "Placed":
        return "Your order has been received.";

      case "Confirmed":
        return "The restaurant has confirmed your order.";

      case "Preparing":
        return "Your food is being prepared.";

      case "Packed":
        return "Your order is packed and ready for the rider.";

      case "Out for Delivery":
        return "Your order is on the way.";

      case "Delivered":
        return "Your order has been delivered.";

      default:
        return "Your order is being processed.";
    }
  }

  // =========================================================
  // STATUS ICON
  // =========================================================

  IconData getStatusIcon(String status) {
    switch (status) {
      case "Placed":
        return Icons.receipt_long;

      case "Confirmed":
        return Icons.check_circle_outline;

      case "Preparing":
        return Icons.restaurant;

      case "Packed":
        return Icons.inventory_2;

      case "Out for Delivery":
        return Icons.delivery_dining;

      case "Delivered":
        return Icons.done_all;

      default:
        return Icons.receipt_long;
    }
  }

  // =========================================================
  // ORDER DATE
  // =========================================================

  DateTime? getOrderDate(dynamic value) {
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
      final DateTime? parsed = DateTime.tryParse(value);

      if (parsed != null) {
        return parsed;
      }

      final int? milliseconds = int.tryParse(value);

      if (milliseconds != null) {
        return DateTime.fromMillisecondsSinceEpoch(milliseconds);
      }
    }

    return null;
  }

  // =========================================================
  // RIDER STAGE TITLE
  // =========================================================

  String getRiderStageTitle(String stage) {
    switch (stage) {
      case "Waiting for Rider":
        return "Waiting for Rider";

      case "Going to Store":
        return "Rider Going to Store";

      case "At Store":
        return "Rider Reached Store";

      case "Picked Up":
        return "Order Picked Up";

      case "On the Way":
        return "Rider On the Way";

      case "Delivered":
        return "Delivery Completed";

      default:
        return stage.isEmpty ? "Waiting for Rider" : stage;
    }
  }

  // =========================================================
  // RIDER STAGE DESCRIPTION
  // =========================================================

  String getRiderStageDescription(String stage) {
    switch (stage) {
      case "Waiting for Rider":
        return "Waiting for a rider to accept your order.";

      case "Going to Store":
        return "The rider is travelling to the restaurant.";

      case "At Store":
        return "The rider has reached the restaurant.";

      case "Picked Up":
        return "The rider has collected your order.";

      case "On the Way":
        return "The rider is travelling to your delivery address.";

      case "Delivered":
        return "Your order has been delivered.";

      default:
        return "Delivery information is being updated.";
    }
  }

  // =========================================================
  // RIDER STAGE ICON
  // =========================================================

  IconData getRiderStageIcon(String stage) {
    switch (stage) {
      case "Waiting for Rider":
        return Icons.hourglass_empty;

      case "Going to Store":
        return Icons.navigation;

      case "At Store":
        return Icons.storefront;

      case "Picked Up":
        return Icons.inventory_2;

      case "On the Way":
        return Icons.delivery_dining;

      case "Delivered":
        return Icons.home_filled;

      default:
        return Icons.delivery_dining;
    }
  }

  // =========================================================
  // RIDER STAGE INDEX
  // =========================================================

  int getRiderStageIndex(String stage) {
    const List<String> stages = [
      "Waiting for Rider",
      "Going to Store",
      "At Store",
      "Picked Up",
      "On the Way",
      "Delivered",
    ];

    final int index = stages.indexOf(stage);

    if (index == -1) {
      return 0;
    }

    return index;
  }

  // =========================================================
  // GET RIDER STAGE
  // =========================================================

  String getDisplayedRiderStage(
      Map<String, dynamic> data,
      String orderStatus,
      ) {
    final String storedStage =
        data["riderStage"]?.toString().trim() ?? "";

    // If riderStage exists in Firestore, always use it.
    if (storedStage.isNotEmpty) {
      return storedStage;
    }

    // Delivered order.
    if (orderStatus == "Delivered") {
      return "Delivered";
    }

    // Order has been handed to delivery process.
    if (orderStatus == "Out for Delivery") {
      return "On the Way";
    }

    // Rider exists but stage has not yet been updated.
    if (data["riderUID"] != null &&
        data["riderUID"].toString().trim().isNotEmpty) {
      return "Waiting for Rider";
    }

    // No rider assigned.
    return "Waiting for Rider";
  }

  // =========================================================
  // RIDER LOCATION ACTIVE
  // =========================================================

  bool isRiderLocationActive(Map<String, dynamic> data) {
    return data["riderLocationActive"] == true;
  }

  // =========================================================
  // FORMAT LOCATION UPDATE TIME
  // =========================================================

  String formatLocationUpdatedAt(dynamic value) {
    final DateTime? date = getOrderDate(value);

    if (date == null) {
      return "Not available";
    }

    return DateFormat(
      "dd MMM yyyy, hh:mm:ss aa",
    ).format(date);
  }

  // =========================================================
  // GET RIDER LATITUDE
  // =========================================================

  double? getRiderLatitude(Map<String, dynamic> data) {
    final dynamic value = data["riderLat"];

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? "");
  }

  // =========================================================
  // GET RIDER LONGITUDE
  // =========================================================

  double? getRiderLongitude(Map<String, dynamic> data) {
    final dynamic value = data["riderLng"];

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? "");
  }

  // =========================================================
  // CHECK VALID COORDINATES
  // =========================================================

  bool hasRiderCoordinates(Map<String, dynamic> data) {
    final double? lat = getRiderLatitude(data);
    final double? lng = getRiderLongitude(data);

    if (lat == null || lng == null) {
      return false;
    }

    // Valid latitude range.
    if (lat < -90 || lat > 90) {
      return false;
    }

    // Valid longitude range.
    if (lng < -180 || lng > 180) {
      return false;
    }

    return true;
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final String uid =
        sharedPreferences?.getString("uid") ?? "";

    // =======================================================
    // INVALID ORDER INFORMATION
    // =======================================================

    if (uid.isEmpty ||
        widget.orderId == null ||
        widget.orderId!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Order Details"),
          backgroundColor: const Color(0xFF42A5F5),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Order information is not available.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    // =======================================================
    // MAIN SCREEN
    // =======================================================

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),

      appBar: AppBar(
        title: const Text("Track Your Order"),
        backgroundColor: const Color(0xFF42A5F5),
        foregroundColor: Colors.white,
      ),

      // =====================================================
      // REAL-TIME FIRESTORE ORDER LISTENER
      // =====================================================

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .doc(widget.orderId)
            .snapshots(),

        builder: (context, snapshot) {
          // =================================================
          // LOADING
          // =================================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: circularProgress(),
            );
          }

          // =================================================
          // ERROR
          // =================================================

          if (snapshot.hasError) {
            debugPrint(
              "ORDER DETAILS ERROR: ${snapshot.error}",
            );

            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Unable to load order details.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }

          // =================================================
          // ORDER NOT FOUND
          // =================================================

          if (!snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 65,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Order not found.",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // =================================================
          // ORDER DATA
          // =================================================

          final dynamic rawData =
          snapshot.data!.data();

          if (rawData is! Map<String, dynamic>) {
            return const Center(
              child: Text(
                "Invalid order data.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          final Map<String, dynamic> dataMap = rawData;

          // =================================================
          // BASIC ORDER INFORMATION
          // =================================================

          final String orderStatus =
          dataMap["status"]?.toString().trim().isNotEmpty ==
              true
              ? dataMap["status"]
              .toString()
              .trim()
              : "Placed";

          final String orderId =
          dataMap["orderId"]?.toString().trim().isNotEmpty ==
              true
              ? dataMap["orderId"]
              .toString()
              .trim()
              : widget.orderId!;

          // Support both:
          // 1. Correct field: totalAmount
          // 2. Old existing field: totolAmmount
          final String totalAmount =
              dataMap["totalAmount"]?.toString() ??
                  dataMap["totolAmmount"]?.toString() ??
                  "0";

          final String paymentMethod =
          dataMap["paymentDetails"]
              ?.toString()
              .trim()
              .isNotEmpty ==
              true
              ? dataMap["paymentDetails"]
              .toString()
              .trim()
              : "Cash on Delivery";

          final bool isSuccess =
              dataMap["isSuccess"] == true ||
                  dataMap["isSuccess"]?.toString().toLowerCase() ==
                      "true";

          final DateTime? orderDate =
          getOrderDate(dataMap["orderTime"]);

          final int currentStatusIndex =
          getStatusIndex(orderStatus);

          // =================================================
          // RIDER DATA
          // =================================================

          final String riderUID =
              dataMap["riderUID"]?.toString().trim() ?? "";

          final String riderName =
              dataMap["riderName"]?.toString().trim() ?? "";

          final String riderStage =
          getDisplayedRiderStage(
            dataMap,
            orderStatus,
          );

          final String riderAddress =
              dataMap["riderAddress"]?.toString().trim() ?? "";

          final String riderLocation =
              dataMap["riderLocation"]?.toString().trim() ?? "";

          final bool locationActive =
          isRiderLocationActive(dataMap);

          final double? riderLat =
          getRiderLatitude(dataMap);

          final double? riderLng =
          getRiderLongitude(dataMap);

          final bool coordinatesAvailable =
          hasRiderCoordinates(dataMap);

          final String locationUpdateTime =
          formatLocationUpdatedAt(
            dataMap["riderLocationUpdatedAt"],
          );

          final int riderStageIndex =
          getRiderStageIndex(riderStage);

          // =================================================
          // SCREEN CONTENT
          // =================================================

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // =================================================
                // CURRENT ORDER STATUS
                // =================================================

                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF90CAF9),
                        Color(0xFF42A5F5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        getStatusIcon(orderStatus),
                        size: 58,
                        color: Colors.white,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        getStatusTitle(orderStatus),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        getStatusDescription(orderStatus),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // =================================================
                // RIDER TRACKING CARD
                // =================================================

                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // =================================================
                      // RIDER TRACKING HEADER
                      // =================================================

                      Row(
                        children: [
                          const Icon(
                            Icons.delivery_dining,
                            color: Color(0xFF1565C0),
                            size: 27,
                          ),

                          const SizedBox(width: 8),

                          const Expanded(
                            child: Text(
                              "Rider Tracking",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1565C0),
                              ),
                            ),
                          ),

                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: locationActive
                                  ? Colors.green.shade50
                                  : Colors.grey.shade100,
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize:
                              MainAxisSize.min,
                              children: [
                                Icon(
                                  locationActive
                                      ? Icons.gps_fixed
                                      : Icons.gps_off,
                                  size: 16,
                                  color: locationActive
                                      ? Colors.green
                                      : Colors.grey,
                                ),

                                const SizedBox(width: 5),

                                Text(
                                  locationActive
                                      ? "LIVE"
                                      : "OFFLINE",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: locationActive
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // =================================================
                      // RIDER ASSIGNMENT
                      // =================================================

                      Container(
                        padding:
                        const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color:
                          const Color(0xFFE3F2FD),
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration:
                              const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF90CAF9),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Color(0xFF1565C0),
                                size: 28,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Delivery Rider",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),

                                  const SizedBox(height: 3),

                                  Text(
                                    riderUID.isEmpty &&
                                        riderName.isEmpty
                                        ? "Waiting for rider"
                                        : riderName.isEmpty
                                        ? "Rider assigned"
                                        : riderName,
                                    style: const TextStyle(
                                      color:
                                      Color(0xFF1565C0),
                                      fontSize: 17,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // =================================================
                      // RIDER STAGE
                      // =================================================

                      Container(
                        padding:
                        const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(12),
                          border: Border.all(
                            color:
                            const Color(0xFFBBDEFB),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Icon(
                              getRiderStageIcon(
                                riderStage,
                              ),
                              size: 28,
                              color:
                              const Color(0xFF1565C0),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Current Delivery Stage",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),

                                  const SizedBox(height: 3),

                                  Text(
                                    getRiderStageTitle(
                                      riderStage,
                                    ),
                                    style:
                                    const TextStyle(
                                      color:
                                      Color(0xFF1565C0),
                                      fontSize: 17,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    getRiderStageDescription(
                                      riderStage,
                                    ),
                                    style:
                                    const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // =================================================
                      // LIVE LOCATION
                      // =================================================

                      Container(
                        padding:
                        const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: locationActive
                              ? const Color(0xFFF1F8E9)
                              : const Color(0xFFF5F5F5),
                          borderRadius:
                          BorderRadius.circular(12),
                          border: Border.all(
                            color: locationActive
                                ? Colors.green.shade200
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  locationActive
                                      ? Icons.my_location
                                      : Icons.location_disabled,
                                  color: locationActive
                                      ? Colors.green
                                      : Colors.grey,
                                  size: 24,
                                ),

                                const SizedBox(width: 8),

                                const Expanded(
                                  child: Text(
                                    "Rider Location",
                                    style: TextStyle(
                                      color:
                                      Color(0xFF1565C0),
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),

                                if (locationActive)
                                  const Text(
                                    "Updating",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Address
                            if (riderAddress.isNotEmpty)
                              _trackingInfoRow(
                                "Address",
                                riderAddress,
                                Icons.location_on,
                              ),

                            // Location
                            if (riderLocation.isNotEmpty)
                              _trackingInfoRow(
                                "Location",
                                riderLocation,
                                Icons.place,
                              ),

                            // Coordinates
                            if (coordinatesAvailable &&
                                riderLat != null &&
                                riderLng != null)
                              Column(
                                children: [
                                  _trackingInfoRow(
                                    "Latitude",
                                    riderLat
                                        .toStringAsFixed(6),
                                    Icons.north,
                                  ),

                                  _trackingInfoRow(
                                    "Longitude",
                                    riderLng
                                        .toStringAsFixed(6),
                                    Icons.east,
                                  ),
                                ],
                              )
                            else
                              const Padding(
                                padding:
                                EdgeInsets.only(top: 5),
                                child: Text(
                                  "Live coordinates are not available yet.",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ),

                            const Divider(height: 20),

                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 18,
                                  color: Colors.grey,
                                ),

                                const SizedBox(width: 8),

                                Expanded(
                                  child: Text(
                                    "Last updated: "
                                        "$locationUpdateTime",
                                    style:
                                    const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // =================================================
                // DELIVERY JOURNEY
                // =================================================

                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Delivery Journey",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1565C0),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // =================================================
                      // ORDER PLACED
                      // =================================================

                      _buildJourneyStep(
                        title: "Order Placed",
                        description:
                        "Your order was received.",
                        completed:
                        currentStatusIndex >= 0,
                        current:
                        orderStatus == "Placed",
                        icon: Icons.receipt_long,
                        showLine: true,
                      ),

                      // =================================================
                      // CONFIRMED
                      // =================================================

                      _buildJourneyStep(
                        title: "Order Confirmed",
                        description:
                        "The restaurant confirmed your order.",
                        completed:
                        currentStatusIndex >= 1,
                        current:
                        orderStatus == "Confirmed",
                        icon: Icons.check_circle,
                        showLine: true,
                      ),

                      // =================================================
                      // PREPARING
                      // =================================================

                      _buildJourneyStep(
                        title: "Preparing Food",
                        description:
                        "The restaurant is preparing your food.",
                        completed:
                        currentStatusIndex >= 2,
                        current:
                        orderStatus == "Preparing",
                        icon: Icons.restaurant,
                        showLine: true,
                      ),

                      // =================================================
                      // PACKED
                      // =================================================

                      _buildJourneyStep(
                        title: "Order Packed",
                        description:
                        "Your order is packed and ready for the rider.",
                        completed:
                        currentStatusIndex >= 3,
                        current:
                        orderStatus == "Packed",
                        icon: Icons.inventory_2,
                        showLine: true,
                      ),

                      // =================================================
                      // RIDER ASSIGNED
                      // =================================================

                      _buildJourneyStep(
                        title: "Rider Assigned",
                        description: riderUID.isEmpty
                            ? "Waiting for a rider."
                            : riderName.isEmpty
                            ? "A rider has been assigned."
                            : "$riderName is assigned to your order.",
                        completed:
                        riderUID.isNotEmpty,
                        current: riderUID.isNotEmpty &&
                            riderStage ==
                                "Waiting for Rider",
                        icon: Icons.person,
                        showLine: true,
                      ),

                      // =================================================
                      // GOING TO STORE
                      // =================================================

                      _buildJourneyStep(
                        title: "Rider Going to Store",
                        description:
                        "The rider is travelling to the restaurant.",
                        completed:
                        riderStageIndex >= 1,
                        current:
                        riderStage == "Going to Store",
                        icon: Icons.navigation,
                        showLine: true,
                      ),

                      // =================================================
                      // AT STORE
                      // =================================================

                      _buildJourneyStep(
                        title: "Rider Reached Store",
                        description:
                        "The rider has reached the restaurant.",
                        completed:
                        riderStageIndex >= 2,
                        current:
                        riderStage == "At Store",
                        icon: Icons.storefront,
                        showLine: true,
                      ),

                      // =================================================
                      // PICKED UP
                      // =================================================

                      _buildJourneyStep(
                        title: "Order Picked Up",
                        description:
                        "The rider collected your order.",
                        completed:
                        riderStageIndex >= 3,
                        current:
                        riderStage == "Picked Up",
                        icon: Icons.inventory_2,
                        showLine: true,
                      ),

                      // =================================================
                      // ON THE WAY
                      // =================================================

                      _buildJourneyStep(
                        title: "Rider On the Way",
                        description:
                        "The rider is travelling to you.",
                        completed:
                        riderStageIndex >= 4 ||
                            orderStatus ==
                                "Out for Delivery",
                        current:
                        riderStage == "On the Way" ||
                            orderStatus ==
                                "Out for Delivery",
                        icon: Icons.delivery_dining,
                        showLine: true,
                      ),

                      // =================================================
                      // DELIVERED
                      // =================================================

                      _buildJourneyStep(
                        title: "Delivered",
                        description:
                        "Your order has been delivered.",
                        completed:
                        orderStatus == "Delivered" ||
                            riderStage == "Delivered",
                        current:
                        orderStatus == "Delivered" ||
                            riderStage == "Delivered",
                        icon: Icons.done_all,
                        showLine: false,
                      ),
                    ],
                  ),
                ),

                // =================================================
                // ORDER INFORMATION
                // =================================================

                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Order Information",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1565C0),
                        ),
                      ),

                      const SizedBox(height: 15),

                      _infoRow(
                        "Order ID",
                        orderId,
                        Icons.receipt_long,
                      ),

                      _infoRow(
                        "Amount",
                        "₹$totalAmount",
                        Icons.currency_rupee,
                      ),

                      _infoRow(
                        "Payment",
                        paymentMethod,
                        Icons.payment,
                      ),

                      _infoRow(
                        "Status",
                        orderStatus,
                        getStatusIcon(orderStatus),
                      ),

                      _infoRow(
                        "Order Date",
                        orderDate != null
                            ? DateFormat(
                          "dd MMMM yyyy",
                        ).format(orderDate)
                            : "Not available",
                        Icons.calendar_today,
                      ),

                      _infoRow(
                        "Order Time",
                        orderDate != null
                            ? DateFormat(
                          "hh:mm aa",
                        ).format(orderDate)
                            : "Not available",
                        Icons.access_time,
                      ),

                      // =================================================
                      // RIDER INFORMATION
                      // =================================================

                      if (riderUID.isNotEmpty) ...[
                        const Divider(height: 25),

                        const Text(
                          "Rider Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1565C0),
                          ),
                        ),

                        const SizedBox(height: 8),

                        _infoRow(
                          "Rider",
                          riderName.isEmpty
                              ? "Assigned Rider"
                              : riderName,
                          Icons.person,
                        ),

                        _infoRow(
                          "Stage",
                          getRiderStageTitle(
                            riderStage,
                          ),
                          getRiderStageIcon(
                            riderStage,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // =================================================
                // ORDER IMAGE
                // =================================================

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.circular(14),
                    child: orderStatus == "Delivered"
                        ? Image.asset(
                      "assets/images/delivered.jpg",
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return _buildImageFallback(
                          Icons.check_circle,
                        );
                      },
                    )
                        : Image.asset(
                      "assets/images/state.jpg",
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return _buildImageFallback(
                          Icons.local_shipping,
                        );
                      },
                    ),
                  ),
                ),

                // =================================================
                // DELIVERY ADDRESS
                // =================================================

                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Delivery Address",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1565C0),
                        ),
                      ),

                      const SizedBox(height: 10),

                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("users")
                            .doc(uid)
                            .collection("userAddress")
                            .doc(
                          dataMap["addressId"]
                              ?.toString(),
                        )
                            .get(),

                        builder:
                            (context, addressSnapshot) {
                          if (addressSnapshot
                              .connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: circularProgress(),
                            );
                          }

                          if (addressSnapshot.hasError ||
                              !addressSnapshot.hasData ||
                              !addressSnapshot.data!.exists) {
                            return const Padding(
                              padding:
                              EdgeInsets.all(10),
                              child: Text(
                                "Delivery address is not available.",
                                textAlign:
                                TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          final dynamic rawAddress =
                          addressSnapshot.data!.data();

                          if (rawAddress
                          is! Map<String, dynamic>) {
                            return const Padding(
                              padding:
                              EdgeInsets.all(10),
                              child: Text(
                                "Invalid delivery address.",
                                textAlign:
                                TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          final Map<String, dynamic>
                          addressData = rawAddress;

                          return ShipmentAddressDesign(
                            model: Address.fromJson(
                              addressData,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // =================================================
                // PAYMENT SUCCESS
                // =================================================

                if (isSuccess)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(
                      12,
                      5,
                      12,
                      20,
                    ),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius:
                      BorderRadius.circular(14),
                      border: Border.all(
                        color:
                        Colors.green.shade200,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),

                        SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            "Order placed successfully.",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // =========================================================
  // TRACKING INFO ROW
  // =========================================================

  Widget _trackingInfoRow(
      String title,
      String value,
      IconData icon,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xFF42A5F5),
          ),

          const SizedBox(width: 8),

          SizedBox(
            width: 78,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // DELIVERY JOURNEY STEP
  // =========================================================

  Widget _buildJourneyStep({
    required String title,
    required String description,
    required bool completed,
    required bool current,
    required IconData icon,
    required bool showLine,
  }) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completed
                      ? const Color(0xFF42A5F5)
                      : Colors.grey.shade300,
                  border: current
                      ? Border.all(
                    color:
                    const Color(0xFF1565C0),
                    width: 2,
                  )
                      : null,
                ),
                child: Icon(
                  completed ? Icons.check : icon,
                  size: 18,
                  color: Colors.white,
                ),
              ),

              if (showLine)
                Container(
                  width: 3,
                  height: 48,
                  color: completed
                      ? const Color(0xFF90CAF9)
                      : Colors.grey.shade300,
                ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 1,
              bottom: 18,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: current
                        ? FontWeight.bold
                        : FontWeight.w600,
                    color: current
                        ? const Color(0xFF1565C0)
                        : completed
                        ? Colors.black87
                        : Colors.grey,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  current
                      ? "Current stage"
                      : completed
                      ? "Completed"
                      : description,
                  style: TextStyle(
                    fontSize: 12,
                    color: current
                        ? const Color(0xFF1565C0)
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // INFORMATION ROW
  // =========================================================

  Widget _infoRow(
      String title,
      String value,
      IconData icon,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 21,
            color: const Color(0xFF42A5F5),
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 90,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // IMAGE FALLBACK
  // =========================================================

  Widget _buildImageFallback(
      IconData icon,
      ) {
    return Container(
      width: double.infinity,
      height: 180,
      color: const Color(0xFFE3F2FD),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 80,
        color: const Color(0xFF42A5F5),
      ),
    );
  }
}