import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/widgets/order_card.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/simple_Appbar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    super.key,
  });

  @override
  State<HistoryScreen> createState() =>
      _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // ---------------------------------------------------------
  // USER ID
  // ---------------------------------------------------------

  String get uid {
    return sharedPreferences?.getString("uid") ?? "";
  }

  // ---------------------------------------------------------
  // ORDER TIME
  // ---------------------------------------------------------

  DateTime getOrderTime(
      Map<String, dynamic> data,
      ) {
    final dynamic value = data["orderTime"];

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  // ---------------------------------------------------------
  // LOAD ORDER ITEMS WITHOUT COLLECTION GROUP INDEX
  // ---------------------------------------------------------

  Future<List<QueryDocumentSnapshot>> loadOrderItems(
      List<String> itemIds,
      ) async {
    if (itemIds.isEmpty) {
      return [];
    }

    // Read all items from the collection group.
    // We intentionally do not use a where() query here,
    // because the original Firebase project requires a
    // collection-group index that we do not control.
    final QuerySnapshot snapshot =
    await FirebaseFirestore.instance
        .collectionGroup("items")
        .get();

    final List<QueryDocumentSnapshot> matchingItems = [];

    for (final QueryDocumentSnapshot document
    in snapshot.docs) {
      try {
        final Map<String, dynamic> data =
        document.data() as Map<String, dynamic>;

        final String firestoreItemId =
            data["itemId"]?.toString() ?? "";

        if (itemIds.contains(firestoreItemId)) {
          matchingItems.add(document);
        }
      } catch (_) {
        // Ignore malformed item documents.
      }
    }

    return matchingItems;
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------

  @override
  Widget build(
      BuildContext context,
      ) {
    // -------------------------------------------------------
    // USER SESSION CHECK
    // -------------------------------------------------------

    if (uid.isEmpty) {
      return SafeArea(
        child: Scaffold(
          appBar: SimpleAppBar(
            title: "History",
          ),
          body: const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "User session not found.\nPlease log in again.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(
          title: "History",
        ),

        body: StreamBuilder<QuerySnapshot>(
          // -------------------------------------------------
          // ORDERS ARE STORED IN TOP-LEVEL "orders"
          // -------------------------------------------------

          stream: FirebaseFirestore.instance
              .collection("orders")
              .where(
            "orderedBy",
            isEqualTo: uid,
          )
              .snapshots(),

          builder: (
              context,
              snapshot,
              ) {
            // -----------------------------------------------
            // LOADING
            // -----------------------------------------------

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return Center(
                child: circularProgress(),
              );
            }

            // -----------------------------------------------
            // ERROR
            // -----------------------------------------------

            if (snapshot.hasError) {
              debugPrint(
                "HISTORY ORDERS ERROR: ${snapshot.error}",
              );

              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off,
                        size: 55,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Unable to load order history.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // -----------------------------------------------
            // NO FIRESTORE ORDERS
            // -----------------------------------------------

            if (!snapshot.hasData ||
                snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 65,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "You don't have any completed orders yet.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // -----------------------------------------------
            // FILTER DELIVERED ORDERS
            // -----------------------------------------------

            final List<QueryDocumentSnapshot>
            deliveredOrders = [];

            for (final QueryDocumentSnapshot document
            in snapshot.data!.docs) {
              try {
                final Map<String, dynamic> data =
                document.data()
                as Map<String, dynamic>;

                final String status =
                    data["status"]?.toString() ?? "";

                if (status == "Delivered") {
                  deliveredOrders.add(document);
                }
              } catch (_) {
                // Ignore malformed order documents.
              }
            }

            // -----------------------------------------------
            // SORT NEWEST FIRST
            // -----------------------------------------------

            deliveredOrders.sort(
                  (
                  QueryDocumentSnapshot a,
                  QueryDocumentSnapshot b,
                  ) {
                final Map<String, dynamic> dataA =
                a.data() as Map<String, dynamic>;

                final Map<String, dynamic> dataB =
                b.data() as Map<String, dynamic>;

                return getOrderTime(dataB).compareTo(
                  getOrderTime(dataA),
                );
              },
            );

            // -----------------------------------------------
            // NO COMPLETED ORDERS
            // -----------------------------------------------

            if (deliveredOrders.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 65,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "You don't have any completed orders yet.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // -----------------------------------------------
            // HISTORY LIST
            // -----------------------------------------------

            return ListView.builder(
              physics:
              const BouncingScrollPhysics(),

              padding:
              const EdgeInsets.only(
                top: 8,
                bottom: 20,
              ),

              itemCount:
              deliveredOrders.length,

              itemBuilder:
                  (
                  context,
                  index,
                  ) {
                final QueryDocumentSnapshot
                orderDocument =
                deliveredOrders[index];

                final Map<String, dynamic>
                orderData =
                orderDocument.data()
                as Map<String, dynamic>;

                // -----------------------------------------
                // PRODUCT IDS
                // -----------------------------------------

                final List<String> productIds =
                List<String>.from(
                  orderData["productIds"] ?? [],
                );

                if (productIds.isEmpty) {
                  return const SizedBox.shrink();
                }

                // -----------------------------------------
                // ITEM IDS
                // -----------------------------------------

                final List<String> itemIds =
                separateOrderItemIds(
                  productIds,
                );

                if (itemIds.isEmpty) {
                  return const SizedBox.shrink();
                }

                // -----------------------------------------
                // LOAD FOOD ITEMS WITHOUT INDEX
                // -----------------------------------------

                return FutureBuilder<
                    List<QueryDocumentSnapshot>>(
                  future: loadOrderItems(
                    itemIds,
                  ),

                  builder: (
                      context,
                      itemSnapshot,
                      ) {
                    // -------------------------------------
                    // LOADING
                    // -------------------------------------

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

                    // -------------------------------------
                    // ERROR
                    // -------------------------------------

                    if (itemSnapshot.hasError) {
                      debugPrint(
                        "HISTORY ITEM ERROR: "
                            "${itemSnapshot.error}",
                      );

                      return const Padding(
                        padding:
                        EdgeInsets.all(20),
                        child: Text(
                          "Unable to load order items.",
                          textAlign:
                          TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    // -------------------------------------
                    // NO FOOD ITEMS
                    // -------------------------------------

                    if (!itemSnapshot.hasData ||
                        itemSnapshot.data!.isEmpty) {
                      return const Padding(
                        padding:
                        EdgeInsets.all(20),
                        child: Text(
                          "Order items could not be found.",
                          textAlign:
                          TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    final List<QueryDocumentSnapshot>
                    matchingItems =
                    itemSnapshot.data!;

                    // -------------------------------------
                    // ORDER CARD
                    // -------------------------------------

                    return OrderCard(
                      itemCount:
                      matchingItems.length,

                      data:
                      matchingItems,

                      orderId:
                      orderDocument.id,

                      seperateQuantitiesList:
                      separateOrderItemQuantities(
                        productIds,
                      ),
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