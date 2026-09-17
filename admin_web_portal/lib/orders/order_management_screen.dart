import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});

  // =========================================================
  // CONSTANTS
  // =========================================================

  static const Color primaryColor = Color(0xFF1565C0);
  static const Color backgroundColor = Color(0xFFE3F2FD);

  // =========================================================
  // STATUS COLOR
  // =========================================================

  Color statusColor(String status) {
    switch (status.trim().toLowerCase()) {
      case "placed":
        return Colors.orange;

      case "confirmed":
        return Colors.blue;

      case "preparing":
        return Colors.deepOrange;

      case "packed":
        return Colors.deepPurple;

      case "out for delivery":
        return Colors.indigo;

      case "delivered":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  // =========================================================
  // RIDER STAGE
  // =========================================================

  String getRiderStage(
      Map<String, dynamic> data,
      String orderStatus,
      ) {
    final String storedStage =
        data["riderStage"]?.toString().trim() ?? "";

    // Use the actual stored rider stage first.
    if (storedStage.isNotEmpty) {
      return storedStage;
    }

    final String normalizedStatus =
    orderStatus.trim().toLowerCase();

    if (normalizedStatus == "delivered") {
      return "Delivered";
    }

    if (normalizedStatus == "out for delivery") {
      return "On the Way";
    }

    final String riderUID =
        data["riderUID"]?.toString().trim() ?? "";

    if (riderUID.isNotEmpty) {
      return "Going to Store";
    }

    return "Waiting for Rider";
  }

  // =========================================================
  // GET DATE
  // =========================================================

  DateTime? parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    if (value is double) {
      return DateTime.fromMillisecondsSinceEpoch(
        value.toInt(),
      );
    }

    if (value is String) {
      final DateTime? parsedDate = DateTime.tryParse(value);

      if (parsedDate != null) {
        return parsedDate;
      }

      final int? milliseconds = int.tryParse(value);

      if (milliseconds != null) {
        return DateTime.fromMillisecondsSinceEpoch(
          milliseconds,
        );
      }
    }

    return null;
  }

  // =========================================================
  // FORMAT DATE
  // =========================================================

  String formatDate(dynamic value) {
    final DateTime? date = parseDate(value);

    if (date == null) {
      return "Not available";
    }

    String twoDigits(int number) {
      return number.toString().padLeft(2, "0");
    }

    return "${twoDigits(date.day)}/"
        "${twoDigits(date.month)}/"
        "${date.year} "
        "${twoDigits(date.hour)}:"
        "${twoDigits(date.minute)}";
  }

  // =========================================================
  // GET ORDER TOTAL
  // =========================================================

  String getOrderTotal(Map<String, dynamic> data) {
    // Keep support for your existing field names.
    final dynamic value =
        data["totolAmmount"] ??
            data["totalAmount"] ??
            data["orderTotal"] ??
            0;

    if (value is num) {
      return value.toStringAsFixed(2);
    }

    final double parsedValue =
        double.tryParse(value.toString()) ?? 0.0;

    return parsedValue.toStringAsFixed(2);
  }

  // =========================================================
  // GET STRING VALUE
  // =========================================================

  String getString(
      Map<String, dynamic> data,
      String field, {
        String defaultValue = "",
      }) {
    final dynamic value = data[field];

    if (value == null) {
      return defaultValue;
    }

    final String result = value.toString().trim();

    if (result.isEmpty) {
      return defaultValue;
    }

    return result;
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // =======================================================
      // APP BAR
      // =======================================================

      appBar: AppBar(
        title: const Text(
          "Order Management",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 3,
      ),

      // =======================================================
      // FIRESTORE ORDERS STREAM
      // =======================================================

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .snapshots(),

        builder: (context, snapshot) {
          // =====================================================
          // LOADING
          // =====================================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }

          // =====================================================
          // ERROR
          // =====================================================

          if (snapshot.hasError) {
            return _buildErrorView(
              snapshot.error.toString(),
            );
          }

          // =====================================================
          // GET ORDERS
          // =====================================================

          final List<QueryDocumentSnapshot<Map<String, dynamic>>>
          orders = snapshot.data?.docs.toList() ?? [];

          // =====================================================
          // SORT NEWEST FIRST
          // =====================================================

          orders.sort((a, b) {
            final DateTime? aDate =
            parseDate(a.data()["orderTime"]);

            final DateTime? bDate =
            parseDate(b.data()["orderTime"]);

            if (aDate == null && bDate == null) {
              return 0;
            }

            if (aDate == null) {
              return 1;
            }

            if (bDate == null) {
              return -1;
            }

            return bDate.compareTo(aDate);
          });

          // =====================================================
          // NO ORDERS
          // =====================================================

          if (orders.isEmpty) {
            return _buildEmptyView();
          }

          // =====================================================
          // ORDER COUNTS
          // =====================================================

          final Map<String, int> counts =
          _calculateOrderCounts(orders);

          // =====================================================
          // MAIN CONTENT
          // =====================================================

          return RefreshIndicator(
            color: primaryColor,

            onRefresh: () async {
              // Firestore StreamBuilder automatically updates.
              // This small delay provides refresh feedback.
              await Future<void>.delayed(
                const Duration(milliseconds: 300),
              );
            },

            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),

              children: [
                // =================================================
                // SUMMARY
                // =================================================

                _buildSummaryCard(counts),

                const SizedBox(height: 24),

                // =================================================
                // ALL ORDERS TITLE
                // =================================================

                const Text(
                  "All Orders",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),

                const SizedBox(height: 12),

                // =================================================
                // ORDER CARDS
                // =================================================

                ...orders.map(
                      (order) => _buildOrderCard(order),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // =========================================================
  // CALCULATE ORDER COUNTS
  // =========================================================

  Map<String, int> _calculateOrderCounts(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> orders,
      ) {
    int placed = 0;
    int confirmed = 0;
    int preparing = 0;
    int packed = 0;
    int outForDelivery = 0;
    int delivered = 0;

    for (final order in orders) {
      final String status =
      getString(order.data(), "status");

      switch (status.toLowerCase()) {
        case "placed":
          placed++;
          break;

        case "confirmed":
          confirmed++;
          break;

        case "preparing":
          preparing++;
          break;

        case "packed":
          packed++;
          break;

        case "out for delivery":
          outForDelivery++;
          break;

        case "delivered":
          delivered++;
          break;
      }
    }

    return {
      "Placed": placed,
      "Confirmed": confirmed,
      "Preparing": preparing,
      "Packed": packed,
      "Out for Delivery": outForDelivery,
      "Delivered": delivered,
    };
  }

  // =========================================================
  // ERROR VIEW
  // =========================================================

  Widget _buildErrorView(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 65,
              color: Colors.grey,
            ),

            const SizedBox(height: 15),

            const Text(
              "Unable to load orders.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // EMPTY ORDERS VIEW
  // =========================================================

  Widget _buildEmptyView() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 70,
            color: Color(0xFF42A5F5),
          ),

          SizedBox(height: 15),

          Text(
            "No Orders Found",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),

          SizedBox(height: 6),

          Text(
            "Orders will appear here in real time.",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SUMMARY CARD
  // =========================================================

  Widget _buildSummaryCard(
      Map<String, int> counts,
      ) {
    return Card(
      elevation: 4,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Order Overview",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 18),

            Wrap(
              spacing: 10,
              runSpacing: 10,

              children: [
                _summaryChip(
                  "Placed",
                  counts["Placed"] ?? 0,
                  Colors.orange,
                ),

                _summaryChip(
                  "Confirmed",
                  counts["Confirmed"] ?? 0,
                  Colors.blue,
                ),

                _summaryChip(
                  "Preparing",
                  counts["Preparing"] ?? 0,
                  Colors.deepOrange,
                ),

                _summaryChip(
                  "Packed",
                  counts["Packed"] ?? 0,
                  Colors.deepPurple,
                ),

                _summaryChip(
                  "Out for Delivery",
                  counts["Out for Delivery"] ?? 0,
                  Colors.indigo,
                ),

                _summaryChip(
                  "Delivered",
                  counts["Delivered"] ?? 0,
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // ORDER CARD
  // =========================================================

  Widget _buildOrderCard(
      QueryDocumentSnapshot<Map<String, dynamic>> order,
      ) {
    final Map<String, dynamic> data = order.data();

    // ---------------------------------------------------------
    // ORDER ID
    // ---------------------------------------------------------

    final String storedOrderId =
    getString(data, "orderId");

    final String orderId =
    storedOrderId.isNotEmpty
        ? storedOrderId
        : order.id;

    // ---------------------------------------------------------
    // ORDER STATUS
    // ---------------------------------------------------------

    final String status =
    getString(
      data,
      "status",
      defaultValue: "Unknown",
    );

    // ---------------------------------------------------------
    // RIDER INFORMATION
    // ---------------------------------------------------------

    final String riderUID =
    getString(data, "riderUID");

    final String riderName =
    getString(data, "riderName");

    final String riderStage =
    getRiderStage(
      data,
      status,
    );

    // ---------------------------------------------------------
    // CUSTOMER / SELLER
    // ---------------------------------------------------------

    final String purchaserUID =
    getString(data, "orderedBy");

    final String sellerUID =
    getString(data, "sellerUID");

    // ---------------------------------------------------------
    // TOTAL
    // ---------------------------------------------------------

    final String total =
    getOrderTotal(data);

    // ---------------------------------------------------------
    // LOCATION
    // ---------------------------------------------------------

    final bool locationActive =
        data["riderLocationActive"] == true;

    final String latitude =
        data["riderLat"]?.toString() ??
            "Not available";

    final String longitude =
        data["riderLng"]?.toString() ??
            "Not available";

    final String riderAddress =
    getString(data, "riderAddress");

    // ---------------------------------------------------------
    // STATUS COLOR
    // ---------------------------------------------------------

    final Color currentStatusColor =
    statusColor(status);

    // =========================================================
    // CARD
    // =========================================================

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =================================================
            // ORDER HEADER
            // =================================================

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Icon(
                  Icons.receipt_long,
                  color: primaryColor,
                  size: 28,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    "Order #$orderId",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // STATUS BADGE
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),

                    decoration: BoxDecoration(
                      color: currentStatusColor.withValues(
                        alpha: 0.12,
                      ),

                      borderRadius:
                      BorderRadius.circular(20),
                    ),

                    child: Text(
                      status,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        color: currentStatusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 25),

            // =================================================
            // ORDER DETAILS
            // =================================================

            _infoRow(
              "Order Total",
              "₹$total",
              Icons.currency_rupee,
            ),

            _infoRow(
              "Customer UID",
              purchaserUID.isEmpty
                  ? "Not available"
                  : purchaserUID,
              Icons.person_outline,
            ),

            _infoRow(
              "Seller UID",
              sellerUID.isEmpty
                  ? "Not available"
                  : sellerUID,
              Icons.storefront_outlined,
            ),

            _infoRow(
              "Order Time",
              formatDate(data["orderTime"]),
              Icons.access_time,
            ),

            const SizedBox(height: 8),

            // =================================================
            // RIDER TRACKING
            // =================================================

            const Text(
              "Rider Tracking",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 10),

            _infoRow(
              "Rider",
              riderUID.isEmpty
                  ? "Waiting for Rider"
                  : riderName.isEmpty
                  ? riderUID
                  : riderName,
              Icons.delivery_dining,
            ),

            _infoRow(
              "Rider Stage",
              riderStage,
              Icons.route,
            ),

            _infoRow(
              "Location Status",
              locationActive
                  ? "LIVE"
                  : "OFFLINE",
              locationActive
                  ? Icons.location_on
                  : Icons.location_off,
            ),

            _infoRow(
              "Latitude",
              latitude,
              Icons.north,
            ),

            _infoRow(
              "Longitude",
              longitude,
              Icons.east,
            ),

            // =================================================
            // RIDER ADDRESS
            // =================================================

            if (riderAddress.isNotEmpty)
              _infoRow(
                "Rider Address",
                riderAddress,
                Icons.location_city,
              ),

            const SizedBox(height: 8),

            // =================================================
            // LOCATION INFORMATION BOX
            // =================================================

            _buildLocationStatusBox(
              locationActive: locationActive,
              riderAssigned: riderUID.isNotEmpty,
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // LOCATION STATUS BOX
  // =========================================================

  Widget _buildLocationStatusBox({
    required bool locationActive,
    required bool riderAssigned,
  }) {
    final IconData icon =
    locationActive
        ? Icons.gps_fixed
        : Icons.gps_off;

    final Color iconColor =
    locationActive
        ? Colors.green
        : Colors.grey;

    String message;

    if (locationActive) {
      message =
      "Rider location is currently active.";
    } else if (!riderAssigned) {
      message =
      "No rider has been assigned yet.";
    } else {
      message =
      "Rider location is currently offline.";
    }

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FF),

        borderRadius:
        BorderRadius.circular(12),

        border: Border.all(
          color: const Color(0xFFE0E0E0),
        ),
      ),

      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SUMMARY CHIP
  // =========================================================

  Widget _summaryChip(
      String title,
      int count,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.10,
        ),

        borderRadius:
        BorderRadius.circular(12),

        border: Border.all(
          color: color.withValues(
            alpha: 0.25,
          ),
        ),
      ),

      child: Text(
        "$title: $count",

        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
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
      padding: const EdgeInsets.only(
        bottom: 10,
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Icon(
            icon,
            size: 19,
            color: Colors.grey.shade600,
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 125,

            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}