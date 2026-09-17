import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/assistant_methods/assistant_methods.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/widgets/order_card.dart';
import 'package:seller_app/widgets/progress_bar.dart';
import 'package:seller_app/widgets/simple_Appbar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    super.key,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String get sellerUID {
    return sharedPreferences?.getString("uid") ?? "";
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
      final DateTime? parsedDate = DateTime.tryParse(value);

      if (parsedDate != null) {
        return parsedDate;
      }

      final int? milliseconds =
      int.tryParse(value);

      if (milliseconds != null) {
        return DateTime.fromMillisecondsSinceEpoch(
          milliseconds,
        );
      }
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }

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
          title: "History",
        ),
        body: StreamBuilder<QuerySnapshot>(
          // Only sellerUID is used in the Firestore query.
          // This avoids the composite-index requirement.
          stream: FirebaseFirestore.instance
              .collection("orders")
              .where(
            "sellerUID",
            isEqualTo: sellerUID,
          )
              .snapshots(),
          builder: (
              context,
              snapshot,
              ) {
            // --------------------------------------------------
            // LOADING
            // --------------------------------------------------
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return Center(
                child: circularProgress(),
              );
            }

            // --------------------------------------------------
            // ERROR
            // --------------------------------------------------
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Unable to load order history.\n\n${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }

            // --------------------------------------------------
            // FILTER DELIVERED ORDERS LOCALLY
            // --------------------------------------------------
            final List<QueryDocumentSnapshot>
            deliveredOrders =
            snapshot.data!.docs.where((document) {
              final dynamic rawData =
              document.data();

              if (rawData
              is! Map<String, dynamic>) {
                return false;
              }

              final String status =
                  rawData["status"]
                      ?.toString()
                      .trim() ??
                      "";

              return status == "Delivered";
            }).toList();

            // --------------------------------------------------
            // SORT NEWEST FIRST
            // --------------------------------------------------
            deliveredOrders.sort(
                  (a, b) {
                final dynamic aData = a.data();
                final dynamic bData = b.data();

                final DateTime aTime =
                aData is Map<String, dynamic>
                    ? getOrderTime(
                  aData["orderTime"],
                )
                    : DateTime.fromMillisecondsSinceEpoch(
                  0,
                );

                final DateTime bTime =
                bData is Map<String, dynamic>
                    ? getOrderTime(
                  bData["orderTime"],
                )
                    : DateTime.fromMillisecondsSinceEpoch(
                  0,
                );

                return bTime.compareTo(aTime);
              },
            );

            // --------------------------------------------------
            // NO HISTORY
            // --------------------------------------------------
            if (deliveredOrders.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.history,
                      size: 65,
                      color: Color(0xFF42A5F5),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "No Order History",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Delivered orders will appear here.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }

            // --------------------------------------------------
            // DISPLAY HISTORY
            // --------------------------------------------------
            return ListView.builder(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 20,
              ),
              itemCount: deliveredOrders.length,
              itemBuilder: (
                  context,
                  index,
                  ) {
                final QueryDocumentSnapshot
                orderDocument =
                deliveredOrders[index];

                final dynamic rawOrderData =
                orderDocument.data();

                if (rawOrderData
                is! Map<String, dynamic>) {
                  return const SizedBox.shrink();
                }

                final Map<String, dynamic>
                orderData = rawOrderData;

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
                )
                    .map(
                      (quantity) =>
                      quantity.toString(),
                )
                    .toList();

                if (itemIds.isEmpty) {
                  return const SizedBox.shrink();
                }

                // Firestore whereIn has a value limit.
                final List<String> lookupIds =
                itemIds.take(30).toList();

                // ------------------------------------------------
                // GET ORDER ITEMS
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
                    // ERROR
                    // --------------------------------------------
                    if (itemSnapshot.hasError) {
                      return const SizedBox.shrink();
                    }

                    // --------------------------------------------
                    // NO ITEMS
                    // --------------------------------------------
                    if (!itemSnapshot.hasData ||
                        itemSnapshot
                            .data!
                            .docs
                            .isEmpty) {
                      return const SizedBox.shrink();
                    }

                    final int itemCount =
                        itemSnapshot
                            .data!
                            .docs
                            .length;

                    // ------------------------------------------------
                    // MATCH QUANTITIES SAFELY
                    // ------------------------------------------------
                    final int safeQuantityCount =
                    quantities.length >= itemCount
                        ? itemCount
                        : quantities.length;

                    if (safeQuantityCount == 0) {
                      return const SizedBox.shrink();
                    }

                    return OrderCard(
                      itemCount:
                      safeQuantityCount,
                      data:
                      itemSnapshot.data!.docs,
                      orderId:
                      orderDocument.id,
                      seperateQuantitiesList:
                      quantities
                          .take(
                        safeQuantityCount,
                      )
                          .toList(),
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