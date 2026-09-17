import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../assistant_methods/assistant_methods.dart';
import '../global/global.dart';
import '../widgets/order_card.dart';
import '../widgets/progress_bar.dart';
import '../widgets/simple_appbar.dart';
import 'order_details_screen.dart';
import 'parcel_delivering_screen.dart';

class NotYetDeliveredScreen extends StatefulWidget {
  const NotYetDeliveredScreen({super.key});

  @override
  State<NotYetDeliveredScreen> createState() =>
      _NotYetDeliveredScreenState();
}

class _NotYetDeliveredScreenState
    extends State<NotYetDeliveredScreen> {

  // ---------------------------------------------------------
  // GET CURRENT RIDER UID
  // ---------------------------------------------------------

  String? get riderUID {
    return firebaseAuth.currentUser?.uid ??
        sharedPreferences?.getString("uid");
  }

  // ---------------------------------------------------------
  // LOAD ITEMS FOR ORDER
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
  // OPEN DELIVERY SCREEN
  // ---------------------------------------------------------

  void openDeliveryScreen(
      Map<String, dynamic> orderData,
      String orderId,
      ) {
    final String purchaserId =
        orderData["orderedBy"]?.toString() ?? "";

    final String sellerId =
        orderData["sellerUID"]?.toString() ?? "";

    final String deliveryAddress =
        orderData["deliveryAddress"]?.toString() ??
            orderData["address"]?.toString() ??
            "";

    final String purchaserLat =
        orderData["purchaserLat"]?.toString() ??
            orderData["userLat"]?.toString() ??
            "";

    final String purchaserLng =
        orderData["purchaserLng"]?.toString() ??
            orderData["userLng"]?.toString() ??
            "";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ParcelDeliveringScreen(
          purchaserId:
          purchaserId.isNotEmpty
              ? purchaserId
              : null,
          purchaserAddress:
          deliveryAddress.isNotEmpty
              ? deliveryAddress
              : null,
          purchaserLat:
          purchaserLat.isNotEmpty
              ? purchaserLat
              : null,
          purchaserLng:
          purchaserLng.isNotEmpty
              ? purchaserLng
              : null,
          sellerId:
          sellerId.isNotEmpty
              ? sellerId
              : null,
          getOrderId: orderId,
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // BUILD ORDER CARD
  // ---------------------------------------------------------

  Widget buildOrder(
      QueryDocumentSnapshot<Map<String, dynamic>> order,
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

    final String status =
    orderData["status"]?.toString().trim().isNotEmpty ==
        true
        ? orderData["status"].toString().trim()
        : "Unknown";

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
              // ORDER
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
                    vertical: 12,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delivery_dining,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Status: $status",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ------------------------------------------------
              // VIEW ORDER
              // ------------------------------------------------

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
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
                    style:
                    OutlinedButton.styleFrom(
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

              const SizedBox(height: 10),

              // ------------------------------------------------
              // CONTINUE DELIVERY
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
                  child: ElevatedButton.icon(
                    onPressed: () {
                      openDeliveryScreen(
                        orderData,
                        order.id,
                      );
                    },
                    icon: const Icon(
                      Icons.navigation,
                    ),
                    label: const Text(
                      "Continue Delivery",
                    ),
                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFF1565C0),
                      foregroundColor:
                      Colors.white,
                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 14,
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
          title: "Active Deliveries",
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
                    "Unable to load active deliveries.\n\n"
                        "${snapshot.error}",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final allOrders =
                snapshot.data?.docs ?? [];

            // ------------------------------------------------
            // ACTIVE DELIVERY = OUT FOR DELIVERY
            // ------------------------------------------------

            final orders =
            allOrders.where((order) {
              final String status =
                  order.data()["status"]
                      ?.toString()
                      .trim()
                      .toLowerCase() ??
                      "";

              return status ==
                  "out for delivery";
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
                      Icons
                          .local_shipping_outlined,
                      size: 70,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 15),
                    Text(
                      "No active deliveries.",
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
                        "Picked-up orders that are "
                            "on their way to customers "
                            "will appear here.",
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