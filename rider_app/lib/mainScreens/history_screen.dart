import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../assistant_methods/assistant_methods.dart';
import '../global/global.dart';
import '../widgets/order_card.dart';
import '../widgets/progress_bar.dart';
import '../widgets/simple_appbar.dart';
import 'order_details_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // ---------------------------------------------------------
  // GET CURRENT RIDER UID
  // ---------------------------------------------------------

  String? get riderUID {
    return firebaseAuth.currentUser?.uid ??
        sharedPreferences?.getString("uid");
  }

  // ---------------------------------------------------------
  // GET DELIVERED ORDERS
  // ---------------------------------------------------------

  Stream<QuerySnapshot<Map<String, dynamic>>>
  getDeliveredOrders() {
    final String? uid = riderUID;

    if (uid == null || uid.isEmpty) {
      return FirebaseFirestore.instance
          .collection("orders")
          .where(
        "riderUID",
        isEqualTo: "__no_rider__",
      )
          .snapshots();
    }

    return FirebaseFirestore.instance
        .collection("orders")
        .where(
      "riderUID",
      isEqualTo: uid,
    )
        .where(
      "status",
      isEqualTo: "Delivered",
    )
        .snapshots();
  }

  // ---------------------------------------------------------
  // LOAD ORDER ITEMS
  // ---------------------------------------------------------

  Future<QuerySnapshot<Map<String, dynamic>>>
  getOrderItems(
      Map<String, dynamic> orderData,
      ) async {
    final dynamic productIds =
    orderData["productIds"];

    if (productIds == null ||
        productIds is! List) {
      return FirebaseFirestore.instance
          .collection("items")
          .where(
        "itemId",
        isEqualTo: "__no_item__",
      )
          .get();
    }

    final List<String> itemIds =
    separateOrderItemIds(productIds)
        .cast<String>();

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
  // FORMAT DATE
  // ---------------------------------------------------------

  String formatDeliveredAt(dynamic value) {
    try {
      DateTime? dateTime;

      if (value is Timestamp) {
        dateTime = value.toDate();
      } else if (value is DateTime) {
        dateTime = value;
      } else if (value is int) {
        dateTime =
            DateTime.fromMillisecondsSinceEpoch(
              value,
            );
      } else if (value is String) {
        final int? milliseconds =
        int.tryParse(value);

        if (milliseconds != null) {
          dateTime =
              DateTime.fromMillisecondsSinceEpoch(
                milliseconds,
              );
        } else {
          dateTime =
              DateTime.tryParse(value);
        }
      }

      if (dateTime == null) {
        return "Delivery time unavailable";
      }

      return DateFormat(
        "dd MMM yyyy • hh:mm aa",
      ).format(dateTime);
    } catch (_) {
      return "Delivery time unavailable";
    }
  }

  // ---------------------------------------------------------
  // GET EARNING FROM ORDER
  // ---------------------------------------------------------

  double getOrderEarning(
      Map<String, dynamic> data,
      ) {
    final dynamic amount =
        data["riderDeliveryAmount"] ??
            data["deliveryFee"] ??
            data["parcelDeliveryAmount"];

    if (amount is num) {
      return amount.toDouble();
    }

    if (amount != null) {
      return double.tryParse(
        amount.toString(),
      ) ??
          0.0;
    }

    return double.tryParse(
      perParcelDeliveryAmount,
    ) ??
        0.0;
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
  // BUILD HISTORY ORDER
  // ---------------------------------------------------------

  Widget buildHistoryOrder(
      QueryDocumentSnapshot<
          Map<String, dynamic>>
      order,
      ) {
    final Map<String, dynamic> orderData =
    order.data();

    final dynamic productIds =
    orderData["productIds"];

    final List<String> quantities =
    productIds is List
        ? separateOrderItemQuantities(
      productIds,
    ).cast<String>()
        : <String>[];

    final double earning =
    getOrderEarning(orderData);

    final String deliveredAt =
    formatDeliveredAt(
      orderData["deliveredAt"],
    );

    final String status =
        orderData["status"]
            ?.toString()
            .trim() ??
            "Delivered";

    return FutureBuilder<
        QuerySnapshot<Map<String, dynamic>>>(
      future: getOrderItems(orderData),
      builder: (
          context,
          itemSnapshot,
          ) {
        if (itemSnapshot.connectionState ==
            ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: circularProgress(),
            ),
          );
        }

        if (itemSnapshot.hasError) {
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Unable to load order items.",
              ),
            ),
          );
        }

        final items =
            itemSnapshot.data?.docs ?? [];

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
            borderRadius:
            BorderRadius.circular(15),
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
              // DELIVERY INFORMATION
              // ------------------------------------------------

              Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  15,
                  0,
                  15,
                  10,
                ),
                child: Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color:
                    const Color(0xFFE8F5E9),
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Status: $status",
                              style:
                              const TextStyle(
                                color:
                                Colors.green,
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 20,
                            color:
                            Colors.black54,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              deliveredAt,
                              style:
                              const TextStyle(
                                color:
                                Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Icon(
                            Icons
                                .account_balance_wallet,
                            size: 20,
                            color:
                            Color(0xFF1565C0),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Delivery Earning: "
                                "₹${earning.toStringAsFixed(2)}",
                            style:
                            const TextStyle(
                              color:
                              Color(0xFF1565C0),
                              fontWeight:
                              FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ------------------------------------------------
              // VIEW DETAILS
              // ------------------------------------------------

              Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  15,
                  0,
                  15,
                  15,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      openOrderDetails(
                        order.id,
                      );
                    },
                    icon: const Icon(
                      Icons.receipt_long,
                    ),
                    label: const Text(
                      "View Order Details",
                    ),
                    style:
                    OutlinedButton.styleFrom(
                      foregroundColor:
                      const Color(
                        0xFF1565C0,
                      ),
                      side:
                      const BorderSide(
                        color:
                        Color(0xFF1565C0),
                      ),
                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          10,
                        ),
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
  Widget build(
      BuildContext context,
      ) {
    final String? uid = riderUID;

    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(
          title: "Delivery History",
        ),
        body: uid == null || uid.isEmpty
            ? const Center(
          child: Text(
            "Rider account not found.",
            style: TextStyle(
              fontSize: 16,
              fontWeight:
              FontWeight.bold,
            ),
          ),
        )
            : StreamBuilder<
            QuerySnapshot<
                Map<String, dynamic>>>(
          stream:
          getDeliveredOrders(),
          builder:
              (context, snapshot) {

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
                  const EdgeInsets.all(
                    20,
                  ),
                  child: Text(
                    "Unable to load order history.\n\n"
                        "${snapshot.error}",
                    textAlign:
                    TextAlign.center,
                  ),
                ),
              );
            }

            final orders =
            List<
                QueryDocumentSnapshot<
                    Map<String, dynamic>>>.from(
              snapshot.data?.docs ?? [],
            );

            // ------------------------------------------------
            // NEWEST DELIVERIES FIRST
            // ------------------------------------------------

            orders.sort(
                  (a, b) {
                final dynamic aTime =
                a.data()["deliveredAt"];

                final dynamic bTime =
                b.data()["deliveredAt"];

                int aMilliseconds =
                0;

                int bMilliseconds =
                0;

                if (aTime is Timestamp) {
                  aMilliseconds =
                      aTime
                          .millisecondsSinceEpoch;
                }

                if (bTime is Timestamp) {
                  bMilliseconds =
                      bTime
                          .millisecondsSinceEpoch;
                }

                return bMilliseconds
                    .compareTo(
                  aMilliseconds,
                );
              },
            );

            // ------------------------------------------------
            // EMPTY
            // ------------------------------------------------

            if (orders.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .center,
                  children: [

                    Icon(
                      Icons.history,
                      size: 70,
                      color: Colors.grey,
                    ),

                    SizedBox(height: 15),

                    Text(
                      "No delivered orders yet.",
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
                        "Completed deliveries will "
                            "appear here with their "
                            "delivery time and earnings.",
                        textAlign:
                        TextAlign.center,
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
            // HISTORY LIST
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
                itemCount:
                orders.length,
                itemBuilder:
                    (context, index) {
                  return buildHistoryOrder(
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