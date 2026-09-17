import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/assistant_methods/assistant_methods.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/widgets/order_card.dart';
import 'package:seller_app/widgets/progress_bar.dart';
import 'package:seller_app/widgets/simple_Appbar.dart';

class NewOrdersScreen extends StatefulWidget {
  const NewOrdersScreen({
    super.key,
  });

  @override
  State<NewOrdersScreen> createState() => _NewOrdersScreenState();
}

class _NewOrdersScreenState extends State<NewOrdersScreen> {
  String get sellerUID {
    return sharedPreferences?.getString("uid") ?? "";
  }

  // =========================================================
  // UPDATE ORDER STATUS
  // =========================================================

  Future<void> updateOrderStatus({
    required String orderId,
    required String newStatus,
  }) async {
    if (orderId.trim().isEmpty) {
      return;
    }

    try {
      final Map<String, dynamic> updateData = {
        "status": newStatus,
        "statusUpdatedAt": FieldValue.serverTimestamp(),
      };

      // -------------------------------------------------------
      // SELLER CONFIRMS ORDER
      // -------------------------------------------------------
      if (newStatus == "Confirmed") {
        updateData["sellerConfirmedAt"] =
            FieldValue.serverTimestamp();
      }

      // -------------------------------------------------------
      // SELLER STARTS PREPARING
      // -------------------------------------------------------
      if (newStatus == "Preparing") {
        updateData["preparationStartedAt"] =
            FieldValue.serverTimestamp();

        // Keep the existing rider workflow.
        updateData["riderStage"] = "Waiting for Rider";
        updateData["riderLocationActive"] = false;
      }

      // -------------------------------------------------------
      // SELLER PACKS THE ORDER
      // -------------------------------------------------------
      if (newStatus == "Packed") {
        updateData["packedAt"] =
            FieldValue.serverTimestamp();

        // Order remains available for rider acceptance.
        updateData["riderStage"] = "Waiting for Rider";
        updateData["riderLocationActive"] = false;
      }

      // -------------------------------------------------------
      // UPDATE SHARED TOP-LEVEL ORDER DOCUMENT
      // -------------------------------------------------------
      await FirebaseFirestore.instance
          .collection("orders")
          .doc(orderId)
          .update(updateData);

      if (!mounted) {
        return;
      }

      String message;

      switch (newStatus) {
        case "Confirmed":
          message = "Order confirmed successfully.";
          break;

        case "Preparing":
          message =
          "Order is now being prepared.";
          break;

        case "Packed":
          message =
          "Order is packed and ready for a rider.";
          break;

        default:
          message = "Order status updated.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (error) {
      debugPrint(
        "SELLER ORDER STATUS UPDATE ERROR: $error",
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to update the order status.",
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // =========================================================
  // STATUS TITLE
  // =========================================================

  String getStatusTitle(String status) {
    switch (status) {
      case "Placed":
        return "New Order";

      case "Confirmed":
        return "Order Confirmed";

      case "Preparing":
        return "Preparing Food";

      case "Packed":
        return "Order Packed";

      default:
        return status.isEmpty ? "Unknown Status" : status;
    }
  }

  // =========================================================
  // STATUS DESCRIPTION
  // =========================================================

  String getStatusDescription(String status) {
    switch (status) {
      case "Placed":
        return "Customer has placed a new order.";

      case "Confirmed":
        return "You confirmed this order. Start preparing it.";

      case "Preparing":
        return "Food is being prepared.";

      case "Packed":
        return "Order is packed and ready for a rider.";

      default:
        return "Order information.";
    }
  }

  // =========================================================
  // STATUS COLOR
  // =========================================================

  Color getStatusColor(String status) {
    switch (status) {
      case "Placed":
        return const Color(0xFFFF9800);

      case "Confirmed":
        return const Color(0xFF1976D2);

      case "Preparing":
        return const Color(0xFF2E7D32);

      case "Packed":
        return const Color(0xFF7B1FA2);

      default:
        return Colors.grey;
    }
  }

  // =========================================================
  // STATUS ICON
  // =========================================================

  IconData getStatusIcon(String status) {
    switch (status) {
      case "Placed":
        return Icons.notifications_active;

      case "Confirmed":
        return Icons.check_circle;

      case "Preparing":
        return Icons.restaurant;

      case "Packed":
        return Icons.inventory_2;

      default:
        return Icons.receipt_long;
    }
  }

  // =========================================================
  // ACTION BUTTON
  // =========================================================

  Widget buildActionButton({
    required String status,
    required String orderId,
  }) {
    // ---------------------------------------------------------
    // NEW ORDER
    // ---------------------------------------------------------

    if (status == "Placed") {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () async {
            await updateOrderStatus(
              orderId: orderId,
              newStatus: "Confirmed",
            );
          },
          icon: const Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          label: const Text(
            "Confirm Order",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1976D2),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              vertical: 13,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    // ---------------------------------------------------------
    // CONFIRMED
    // ---------------------------------------------------------

    if (status == "Confirmed") {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () async {
            await updateOrderStatus(
              orderId: orderId,
              newStatus: "Preparing",
            );
          },
          icon: const Icon(
            Icons.restaurant,
            color: Colors.white,
          ),
          label: const Text(
            "Start Preparing",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              vertical: 13,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    // ---------------------------------------------------------
    // PREPARING
    // ---------------------------------------------------------

    if (status == "Preparing") {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () async {
            await updateOrderStatus(
              orderId: orderId,
              newStatus: "Packed",
            );
          },
          icon: const Icon(
            Icons.inventory_2,
            color: Colors.white,
          ),
          label: const Text(
            "Mark as Packed",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7B1FA2),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              vertical: 13,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    // ---------------------------------------------------------
    // PACKED
    // ---------------------------------------------------------

    if (status == "Packed") {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF3E5F5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFBA68C8),
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.delivery_dining,
              color: Color(0xFF7B1FA2),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Order packed. Waiting for a rider to accept this order.",
                style: TextStyle(
                  color: Color(0xFF7B1FA2),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  // =========================================================
  // ORDER STATUS HEADER
  // =========================================================

  Widget buildStatusHeader({
    required String status,
  }) {
    final Color statusColor = getStatusColor(status);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        12,
        10,
        12,
        4,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getStatusIcon(status),
              color: statusColor,
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  getStatusTitle(status),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  getStatusDescription(status),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    if (sellerUID.isEmpty) {
      return const SafeArea(
        child: Scaffold(
          body: Center(
            child: Text(
              "Seller information is not available.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: const SimpleAppBar(
          title: "New Orders",
        ),
        body: StreamBuilder<QuerySnapshot>(
          // ----------------------------------------------------
          // LOAD ORDERS BELONGING TO THIS SELLER
          // ----------------------------------------------------

          stream: FirebaseFirestore.instance
              .collection("orders")
              .where(
            "sellerUID",
            isEqualTo: sellerUID,
          )
              .snapshots(),

          builder: (context, snapshot) {
            // ----------------------------------------------------
            // LOADING
            // ----------------------------------------------------

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return Center(
                child: circularProgress(),
              );
            }

            // ----------------------------------------------------
            // ERROR
            // ----------------------------------------------------

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Unable to load orders.\n\n${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }

            // ----------------------------------------------------
            // NO DATA
            // ----------------------------------------------------

            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }

            // ----------------------------------------------------
            // FILTER SELLER ACTIVE ORDERS
            //
            // Placed     = seller must confirm
            // Confirmed  = seller must start preparing
            // Preparing  = seller is preparing
            // Packed     = waiting for rider
            // ----------------------------------------------------

            final List<QueryDocumentSnapshot> activeOrders =
            snapshot.data!.docs.where((document) {
              final dynamic rawData = document.data();

              if (rawData is! Map<String, dynamic>) {
                return false;
              }

              final String status =
                  rawData["status"]?.toString().trim() ?? "";

              return status == "Placed" ||
                  status == "Confirmed" ||
                  status == "Preparing" ||
                  status == "Packed";
            }).toList();

            // ----------------------------------------------------
            // SORT ORDERS
            //
            // Newest order first when orderTime is available.
            // ----------------------------------------------------

            activeOrders.sort(
                  (
                  QueryDocumentSnapshot a,
                  QueryDocumentSnapshot b,
                  ) {
                final dynamic rawA = a.data();
                final dynamic rawB = b.data();

                if (rawA is! Map<String, dynamic> ||
                    rawB is! Map<String, dynamic>) {
                  return 0;
                }

                final dynamic timeA = rawA["orderTime"];
                final dynamic timeB = rawB["orderTime"];

                DateTime dateA =
                DateTime.fromMillisecondsSinceEpoch(0);

                DateTime dateB =
                DateTime.fromMillisecondsSinceEpoch(0);

                if (timeA is Timestamp) {
                  dateA = timeA.toDate();
                } else if (timeA is DateTime) {
                  dateA = timeA;
                }

                if (timeB is Timestamp) {
                  dateB = timeB.toDate();
                } else if (timeB is DateTime) {
                  dateB = timeB;
                }

                return dateB.compareTo(dateA);
              },
            );

            // ----------------------------------------------------
            // NO ACTIVE ORDERS
            // ----------------------------------------------------

            if (activeOrders.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 65,
                      color: Color(0xFF42A5F5),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "No New Orders",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "New orders will appear here.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }

            // ----------------------------------------------------
            // DISPLAY ACTIVE ORDERS
            // ----------------------------------------------------

            return ListView.builder(
              padding: const EdgeInsets.only(
                top: 4,
                bottom: 20,
              ),
              itemCount: activeOrders.length,
              itemBuilder: (context, index) {
                final QueryDocumentSnapshot orderDocument =
                activeOrders[index];

                final dynamic rawOrderData =
                orderDocument.data();

                if (rawOrderData is! Map<String, dynamic>) {
                  return const SizedBox.shrink();
                }

                final Map<String, dynamic> orderData =
                    rawOrderData;

                // ------------------------------------------------
                // STATUS
                // ------------------------------------------------

                final String status =
                    orderData["status"]
                        ?.toString()
                        .trim() ??
                        "";

                // ------------------------------------------------
                // ORDER ID
                // ------------------------------------------------

                final String orderId =
                    orderDocument.id;

                // ------------------------------------------------
                // PRODUCT IDS
                // ------------------------------------------------

                final List<dynamic> productIds =
                orderData["productIds"] is List
                    ? List<dynamic>.from(
                  orderData["productIds"],
                )
                    : <dynamic>[];

                final List<String> itemIds =
                productIds
                    .map(
                      (item) =>
                      item.toString().trim(),
                )
                    .where(
                      (item) =>
                  item.isNotEmpty,
                )
                    .toList();

                // ------------------------------------------------
                // QUANTITIES
                // ------------------------------------------------

                final List<String> quantities =
                separateOrderItemQuantities(
                  productIds,
                ).map(
                      (quantity) =>
                      quantity.toString(),
                ).toList();

                if (itemIds.isEmpty) {
                  return const SizedBox.shrink();
                }

                // ------------------------------------------------
                // FIRESTORE whereIn LIMIT
                // ------------------------------------------------

                final List<String> lookupIds =
                itemIds.take(30).toList();

                // ------------------------------------------------
                // GET FOOD ITEMS
                // ------------------------------------------------

                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("items")
                      .where(
                    "itemId",
                    whereIn: lookupIds,
                  )
                      .get(),
                  builder: (
                      context,
                      itemSnapshot,
                      ) {
                    // --------------------------------------------
                    // LOADING ITEMS
                    // --------------------------------------------

                    if (itemSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Padding(
                        padding:
                        const EdgeInsets.all(20),
                        child: Center(
                          child: circularProgress(),
                        ),
                      );
                    }

                    // --------------------------------------------
                    // ITEM ERROR
                    // --------------------------------------------

                    if (itemSnapshot.hasError) {
                      return const SizedBox.shrink();
                    }

                    // --------------------------------------------
                    // NO ITEMS
                    // --------------------------------------------

                    if (!itemSnapshot.hasData ||
                        itemSnapshot.data!.docs.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    final int itemCount =
                        itemSnapshot.data!.docs.length;

                    // --------------------------------------------
                    // KEEP QUANTITY COUNT SAFE
                    // --------------------------------------------

                    final int safeQuantityCount =
                    quantities.length >= itemCount
                        ? itemCount
                        : quantities.length;

                    if (safeQuantityCount == 0) {
                      return const SizedBox.shrink();
                    }

                    // --------------------------------------------
                    // ORDER SECTION
                    // --------------------------------------------

                    return Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                      children: [
                        // ----------------------------------------
                        // STATUS
                        // ----------------------------------------

                        buildStatusHeader(
                          status: status,
                        ),

                        // ----------------------------------------
                        // EXISTING ORDER CARD
                        // ----------------------------------------

                        OrderCard(
                          itemCount: safeQuantityCount,
                          data: itemSnapshot.data!.docs,
                          orderId: orderId,
                          seperateQuantitiesList:
                          quantities
                              .take(
                            safeQuantityCount,
                          )
                              .toList(),
                        ),

                        // ----------------------------------------
                        // SELLER ACTION
                        // ----------------------------------------

                        Container(
                          margin:
                          const EdgeInsets.fromLTRB(
                            12,
                            2,
                            12,
                            12,
                          ),
                          padding:
                          const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(
                              14,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(
                                  alpha: 0.05,
                                ),
                                blurRadius: 6,
                                offset:
                                const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: buildActionButton(
                            status: status,
                            orderId: orderId,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}