import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../assistant_methods/assistant_methods.dart';
import '../global/global.dart';
import '../widgets/order_card.dart';
import '../widgets/progress_bar.dart';
import '../widgets/simple_appbar.dart';
import 'order_details_screen.dart';

class ParcelInProgress extends StatefulWidget {
  const ParcelInProgress({super.key});

  @override
  State<ParcelInProgress> createState() =>
      _ParcelInProgressState();
}

class _ParcelInProgressState extends State<ParcelInProgress> {

  // ---------------------------------------------------------
  // GET CURRENT RIDER UID
  // ---------------------------------------------------------

  String? get riderUID {
    return firebaseAuth.currentUser?.uid ??
        sharedPreferences?.getString("uid");
  }

  // ---------------------------------------------------------
  // LOAD ORDER ITEMS
  // ---------------------------------------------------------

  Future<QuerySnapshot<Map<String, dynamic>>> getOrderItems(
      Map<String, dynamic> orderData,
      ) async {
    final dynamic productIds = orderData["productIds"];

    if (productIds == null || productIds is! List) {
      return FirebaseFirestore.instance
          .collection("items")
          .where(
        "itemId",
        isEqualTo: "__no_item__",
      )
          .get();
    }

    final List<String> itemIds =
    separateOrderItemIds(productIds).cast<String>();

    if (itemIds.isEmpty) {
      return FirebaseFirestore.instance
          .collection("items")
          .where(
        "itemId",
        isEqualTo: "__no_item__",
      )
          .get();
    }

    return FirebaseFirestore.instance
        .collection("items")
        .where(
      "itemId",
      whereIn: itemIds,
    )
        .get();
  }

  // ---------------------------------------------------------
  // STATUS COLOR
  // ---------------------------------------------------------

  Color statusBackground(String status) {
    switch (status.toLowerCase()) {
      case "confirmed":
        return const Color(0xFFE3F2FD);

      case "preparing":
        return const Color(0xFFFFF3E0);

      case "out for delivery":
        return const Color(0xFFE8F5E9);

      default:
        return const Color(0xFFF5F5F5);
    }
  }

  Color statusTextColor(String status) {
    switch (status.toLowerCase()) {
      case "confirmed":
        return const Color(0xFF1565C0);

      case "preparing":
        return Colors.orange.shade800;

      case "out for delivery":
        return Colors.green.shade700;

      default:
        return Colors.black87;
    }
  }

  // ---------------------------------------------------------
  // OPEN ORDER DETAILS
  // ---------------------------------------------------------

  void openOrderDetails(String orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderDetailsScreen(
          orderId: orderId,
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // BUILD ORDER
  // ---------------------------------------------------------

  Widget buildOrder(
      QueryDocumentSnapshot<Map<String, dynamic>> order,
      ) {
    final Map<String, dynamic> orderData = order.data();

    final dynamic productIds =
    orderData["productIds"];

    final List<String> quantities =
    productIds is List
        ? separateOrderItemQuantities(
      productIds,
    ).cast<String>()
        : <String>[];

    final String status =
    orderData["status"]?.toString().trim().isNotEmpty == true
        ? orderData["status"].toString().trim()
        : "Unknown";

    final String sellerUID =
        orderData["sellerUID"]?.toString() ?? "";

    return FutureBuilder<
        QuerySnapshot<Map<String, dynamic>>>(
      future: getOrderItems(orderData),
      builder: (context, snapshot) {

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: circularProgress(),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              "Unable to load order items.",
            ),
          );
        }

        final items =
            snapshot.data?.docs ?? [];

        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [

              // ------------------------------------------------
              // ORDER ITEMS
              // ------------------------------------------------

              OrderCard(
                itemCount: items.length,
                data: items,
                orderId: order.id,
                seperateQuantitiesList:
                quantities,
              ),

              // ------------------------------------------------
              // STATUS
              // ------------------------------------------------

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  15,
                  0,
                  15,
                  10,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: statusBackground(status),
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        status.toLowerCase() ==
                            "preparing"
                            ? Icons.restaurant
                            : Icons.check_circle,
                        color:
                        statusTextColor(status),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Order Status: $status",
                          style: TextStyle(
                            color:
                            statusTextColor(status),
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ------------------------------------------------
              // SELLER
              // ------------------------------------------------

              if (sellerUID.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    15,
                    0,
                    15,
                    10,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Restaurant ID: $sellerUID",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

              // ------------------------------------------------
              // VIEW ORDER
              // ------------------------------------------------

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  15,
                  0,
                  15,
                  15,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      openOrderDetails(order.id);
                    },
                    icon: const Icon(
                      Icons.receipt_long,
                    ),
                    label: const Text(
                      "View Order Details",
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                      const Color(0xFF1565C0),
                      side: const BorderSide(
                        color: Color(0xFF1565C0),
                      ),
                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final String? uid = riderUID;

    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(
          title: "Parcel in Progress",
        ),

        body: uid == null || uid.isEmpty
            ? const Center(
          child: Text(
            "Rider account not found.",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : StreamBuilder<
            QuerySnapshot<
                Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .where(
            "riderUID",
            isEqualTo: uid,
          )
              .snapshots(),

          builder: (context, snapshot) {

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return Center(
                child: circularProgress(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding:
                  const EdgeInsets.all(20),
                  child: Text(
                    "Unable to load orders.\n\n"
                        "${snapshot.error}",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            // ------------------------------------------------
            // ONLY ASSIGNED NON-FINAL ORDERS
            // ------------------------------------------------

            final allOrders =
                snapshot.data?.docs ?? [];

            final orders =
            allOrders.where((order) {

              final String status =
                  order.data()["status"]
                      ?.toString()
                      .trim()
                      .toLowerCase() ??
                      "";

              return status == "confirmed" ||
                  status == "preparing";
            }).toList();

            // ------------------------------------------------
            // EMPTY
            // ------------------------------------------------

            if (orders.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      size: 70,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 15),
                    Text(
                      "No parcels in progress.",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      child: Text(
                        "Orders assigned to you will "
                            "appear here while the restaurant "
                            "is confirming or preparing them.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // ------------------------------------------------
            // LIST
            // ------------------------------------------------

            return RefreshIndicator(
              onRefresh: () async {
                await Future<void>.delayed(
                  const Duration(
                    milliseconds: 300,
                  ),
                );
              },
              child: ListView.builder(
                padding:
                const EdgeInsets.only(
                  top: 8,
                  bottom: 20,
                ),
                itemCount: orders.length,
                itemBuilder:
                    (context, index) {

                  return buildOrder(
                    orders[index],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}