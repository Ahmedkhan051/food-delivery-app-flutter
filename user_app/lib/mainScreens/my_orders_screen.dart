import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/widgets/order_card.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/simple_Appbar.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({
    super.key,
  });

  @override
  State<MyOrdersScreen> createState() =>
      _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  // ---------------------------------------------------------
  // ACTIVE ORDER STATUSES
  // ---------------------------------------------------------

  static const List<String> activeStatuses = [
    "Placed",
    "Confirmed",
    "Preparing",
    "Packed",
    "Out for Delivery",
  ];

  // ---------------------------------------------------------
  // GET USER ID
  // ---------------------------------------------------------

  String get uid {
    return sharedPreferences?.getString("uid") ?? "";
  }

  // ---------------------------------------------------------
  // CHECK ACTIVE STATUS
  // ---------------------------------------------------------

  bool isActiveOrder(String status) {
    return activeStatuses.contains(status);
  }

  // ---------------------------------------------------------
  // GET ORDER TIME
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
  // RIDER STAGE TITLE
  // ---------------------------------------------------------

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
        return "Delivered";

      default:
        return stage.isEmpty
            ? "Waiting for Rider"
            : stage;
    }
  }

  // ---------------------------------------------------------
  // RIDER STAGE ICON
  // ---------------------------------------------------------

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
        return Icons.done_all;

      default:
        return Icons.delivery_dining;
    }
  }

  // ---------------------------------------------------------
  // GET RIDER STAGE
  // ---------------------------------------------------------

  String getRiderStage(
      Map<String, dynamic> orderData,
      String orderStatus,
      ) {
    final String storedStage =
        orderData["riderStage"]
            ?.toString()
            .trim() ??
            "";

    if (storedStage.isNotEmpty) {
      return storedStage;
    }

    if (orderStatus == "Delivered") {
      return "Delivered";
    }

    if (orderStatus == "Out for Delivery") {
      return "On the Way";
    }

    final String riderUID =
        orderData["riderUID"]
            ?.toString()
            .trim() ??
            "";

    if (riderUID.isNotEmpty) {
      return "Going to Store";
    }

    return "Waiting for Rider";
  }

  // ---------------------------------------------------------
  // RIDER LOCATION STATUS
  // ---------------------------------------------------------

  bool isRiderLocationActive(
      Map<String, dynamic> orderData,
      ) {
    return orderData["riderLocationActive"] == true;
  }

  // ---------------------------------------------------------
  // RIDER LOCATION COORDINATES
  // ---------------------------------------------------------

  bool hasRiderCoordinates(
      Map<String, dynamic> orderData,
      ) {
    final dynamic rawLat = orderData["riderLat"];
    final dynamic rawLng = orderData["riderLng"];

    final double? lat =
    rawLat is num
        ? rawLat.toDouble()
        : double.tryParse(
      rawLat?.toString() ?? "",
    );

    final double? lng =
    rawLng is num
        ? rawLng.toDouble()
        : double.tryParse(
      rawLng?.toString() ?? "",
    );

    return lat != null && lng != null;
  }

  // ---------------------------------------------------------
  // BUILD RIDER TRACKING SUMMARY
  // ---------------------------------------------------------

  Widget buildRiderTracking(
      Map<String, dynamic> orderData,
      ) {
    final String orderStatus =
        orderData["status"]?.toString() ?? "Placed";

    final String riderUID =
        orderData["riderUID"]
            ?.toString()
            .trim() ??
            "";

    final String riderName =
        orderData["riderName"]
            ?.toString()
            .trim() ??
            "";

    final String riderStage =
    getRiderStage(
      orderData,
      orderStatus,
    );

    final bool locationActive =
    isRiderLocationActive(
      orderData,
    );

    final bool coordinatesAvailable =
    hasRiderCoordinates(
      orderData,
    );

    if (riderUID.isEmpty) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
          top: 10,
        ),
        padding: const EdgeInsets.all(
          12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius:
          BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.delivery_dining,
              color: Colors.grey,
              size: 25,
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    "Delivery Rider",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Waiting for rider",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                      FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        top: 10,
      ),
      padding: const EdgeInsets.all(
        12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF90CAF9),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // -----------------------------------------------
          // RIDER NAME + LIVE STATUS
          // -----------------------------------------------

          Row(
            children: [
              const Icon(
                Icons.delivery_dining,
                color: Color(0xFF1565C0),
                size: 25,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Delivery Rider",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      riderName.isEmpty
                          ? "Assigned Rider"
                          : riderName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style:
                      const TextStyle(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        Color(0xFF1565C0),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration:
                BoxDecoration(
                  color: locationActive
                      ? Colors.green.shade50
                      : Colors.grey.shade100,
                  borderRadius:
                  BorderRadius.circular(
                    15,
                  ),
                ),
                child: Row(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    Icon(
                      locationActive
                          ? Icons.gps_fixed
                          : Icons.gps_off,
                      size: 14,
                      color: locationActive
                          ? Colors.green
                          : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      locationActive
                          ? "LIVE"
                          : "OFFLINE",
                      style:
                      TextStyle(
                        fontSize: 10,
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

          const SizedBox(
            height: 10,
          ),

          // -----------------------------------------------
          // RIDER STAGE
          // -----------------------------------------------

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Icon(
                getRiderStageIcon(
                  riderStage,
                ),
                size: 20,
                color:
                const Color(0xFF1565C0),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Delivery Stage",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      getRiderStageTitle(
                        riderStage,
                      ),
                      style:
                      const TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // -----------------------------------------------
          // LOCATION AVAILABLE
          // -----------------------------------------------

          if (coordinatesAvailable)
            Padding(
              padding:
              const EdgeInsets.only(
                top: 8,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 18,
                    color:
                    Color(0xFF42A5F5),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      locationActive
                          ? "Rider location is updating live."
                          : "Last rider location is available.",
                      style:
                      const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // LOAD ORDER ITEMS
  // ---------------------------------------------------------

  Future<List<QueryDocumentSnapshot>>
  loadOrderItems(
      List<String> itemIds,
      ) async {
    if (itemIds.isEmpty) {
      return [];
    }

    // Read the items collection group without
    // requiring a collection-group index.
    final QuerySnapshot snapshot =
    await FirebaseFirestore.instance
        .collectionGroup("items")
        .get();

    final List<QueryDocumentSnapshot>
    matchingItems = [];

    for (final QueryDocumentSnapshot
    document in snapshot.docs) {
      try {
        final Map<String, dynamic> data =
        document.data()
        as Map<String, dynamic>;

        final String firestoreItemId =
            data["itemId"]?.toString() ??
                "";

        if (itemIds.contains(
          firestoreItemId,
        )) {
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
    if (uid.isEmpty) {
      return SafeArea(
        child: Scaffold(
          appBar: SimpleAppBar(
            title: "My Orders",
          ),
          body: const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "User session not found.\nPlease log in again.",
                textAlign:
                TextAlign.center,
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
          title: "My Orders",
        ),
        body: StreamBuilder<
            QuerySnapshot>(
          // --------------------------------------------------
          // SHARED TOP-LEVEL ORDERS
          // --------------------------------------------------

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
            // ------------------------------------------------
            // LOADING ORDERS
            // ------------------------------------------------

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return Center(
                child: circularProgress(),
              );
            }

            // ------------------------------------------------
            // ORDER ERROR
            // ------------------------------------------------

            if (snapshot.hasError) {
              debugPrint(
                "MY ORDERS ERROR: ${snapshot.error}",
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
                        "Unable to load your orders.",
                        textAlign:
                        TextAlign.center,
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

            // ------------------------------------------------
            // NO FIRESTORE DATA
            // ------------------------------------------------

            if (!snapshot.hasData ||
                snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "You don't have any active orders yet.",
                    textAlign:
                    TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }

            // ------------------------------------------------
            // FILTER ACTIVE ORDERS
            // ------------------------------------------------

            final List<QueryDocumentSnapshot>
            activeOrders = [];

            for (final QueryDocumentSnapshot
            document
            in snapshot.data!.docs) {
              try {
                final Map<String, dynamic>
                data =
                document.data()
                as Map<String, dynamic>;

                final String status =
                    data["status"]
                        ?.toString() ??
                        "";

                if (isActiveOrder(status)) {
                  activeOrders.add(
                    document,
                  );
                }
              } catch (_) {
                // Ignore malformed order documents.
              }
            }

            // ------------------------------------------------
            // SORT NEWEST FIRST
            // ------------------------------------------------

            activeOrders.sort(
                  (
                  QueryDocumentSnapshot a,
                  QueryDocumentSnapshot b,
                  ) {
                final Map<String, dynamic>
                dataA =
                a.data()
                as Map<String, dynamic>;

                final Map<String, dynamic>
                dataB =
                b.data()
                as Map<String, dynamic>;

                return getOrderTime(dataB)
                    .compareTo(
                  getOrderTime(dataA),
                );
              },
            );

            // ------------------------------------------------
            // NO ACTIVE ORDERS
            // ------------------------------------------------

            if (activeOrders.isEmpty) {
              return const Center(
                child: Padding(
                  padding:
                  EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons
                            .receipt_long_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "You don't have any active orders yet.",
                        textAlign:
                        TextAlign.center,
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

            // ------------------------------------------------
            // ACTIVE ORDER LIST
            // ------------------------------------------------

            return ListView.builder(
              physics:
              const BouncingScrollPhysics(),
              padding:
              const EdgeInsets.only(
                top: 8,
                bottom: 20,
              ),
              itemCount:
              activeOrders.length,
              itemBuilder: (
                  context,
                  index,
                  ) {
                final QueryDocumentSnapshot
                orderDocument =
                activeOrders[index];

                final Map<String, dynamic>
                orderData =
                orderDocument.data()
                as Map<String, dynamic>;

                // ------------------------------------------
                // PRODUCT IDS
                // ------------------------------------------

                final List<String>
                productIds =
                List<String>.from(
                  orderData["productIds"] ??
                      [],
                );

                if (productIds.isEmpty) {
                  return const SizedBox.shrink();
                }

                // ------------------------------------------
                // ITEM IDS
                // ------------------------------------------

                final List<String> itemIds =
                separateOrderItemIds(
                  productIds,
                );

                if (itemIds.isEmpty) {
                  return const SizedBox.shrink();
                }

                // ------------------------------------------
                // ORDER CARD + RIDER INFORMATION
                // ------------------------------------------

                return Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<
                        List<
                            QueryDocumentSnapshot>>(
                      future:
                      loadOrderItems(
                        itemIds,
                      ),
                      builder: (
                          context,
                          itemSnapshot,
                          ) {
                        // ------------------------------------
                        // LOADING ITEMS
                        // ------------------------------------

                        if (itemSnapshot
                            .connectionState ==
                            ConnectionState
                                .waiting) {
                          return Padding(
                            padding:
                            const EdgeInsets
                                .all(
                              20,
                            ),
                            child: Center(
                              child:
                              circularProgress(),
                            ),
                          );
                        }

                        // ------------------------------------
                        // ITEM ERROR
                        // ------------------------------------

                        if (itemSnapshot
                            .hasError) {
                          debugPrint(
                            "MY ORDERS ITEM ERROR: "
                                "${itemSnapshot.error}",
                          );

                          return const Padding(
                            padding:
                            EdgeInsets.all(
                              20,
                            ),
                            child: Text(
                              "Unable to load order items.",
                              textAlign:
                              TextAlign.center,
                              style:
                              TextStyle(
                                color:
                                Colors.grey,
                              ),
                            ),
                          );
                        }

                        // ------------------------------------
                        // NO MATCHING ITEMS
                        // ------------------------------------

                        if (!itemSnapshot
                            .hasData ||
                            itemSnapshot
                                .data!
                                .isEmpty) {
                          return const Padding(
                            padding:
                            EdgeInsets.all(
                              20,
                            ),
                            child: Text(
                              "Order items could not be found.",
                              textAlign:
                              TextAlign.center,
                              style:
                              TextStyle(
                                color:
                                Colors.grey,
                              ),
                            ),
                          );
                        }

                        final List<
                            QueryDocumentSnapshot>
                        matchingItems =
                        itemSnapshot.data!;

                        // ------------------------------------
                        // ORDER CARD
                        // ------------------------------------

                        return OrderCard(
                          itemCount:
                          matchingItems
                              .length,
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
                    ),

                    // ------------------------------------------
                    // RIDER TRACKING SUMMARY
                    // ------------------------------------------

                    Padding(
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 10,
                      ),
                      child:
                      buildRiderTracking(
                        orderData,
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}