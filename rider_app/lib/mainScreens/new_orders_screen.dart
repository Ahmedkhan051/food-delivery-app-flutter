import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:rider_app/mainScreens/order_details_screen.dart';
import 'package:rider_app/widgets/simple_appbar.dart';

class NewOrdersScreen extends StatelessWidget {
  const NewOrdersScreen({super.key});

  // ---------------------------------------------------------
  // OPEN ORDER DETAILS
  // ---------------------------------------------------------

  void openOrderDetails(
      BuildContext context,
      String orderId,
      ) {
    if (orderId.isEmpty) return;

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
  // CHECK WHETHER ORDER IS AVAILABLE
  // ---------------------------------------------------------

  bool isAvailableForRider(
      Map<String, dynamic> data,
      ) {
    final String riderUID =
        data["riderUID"]?.toString().trim() ?? "";

    final String status =
        data["status"]?.toString().trim() ?? "";

    // -------------------------------------------------------
    // THESE ARE THE ORDER STATUSES THAT CAN BE ACCEPTED
    // BY A RIDER.
    //
    // Confirmed = older/existing workflow support
    // Preparing = existing workflow support
    // Packed = new seller workflow
    // -------------------------------------------------------

    final bool validStatus =
        status == "Confirmed" ||
            status == "Preparing" ||
            status == "Packed";

    final bool riderNotAssigned =
        riderUID.isEmpty ||
            riderUID.toLowerCase() == "null";

    return validStatus && riderNotAssigned;
  }

  // ---------------------------------------------------------
  // ORDER TIME
  // ---------------------------------------------------------

  String formatOrderTime(dynamic orderTime) {
    try {
      DateTime? dateTime;

      if (orderTime is Timestamp) {
        dateTime = orderTime.toDate();
      } else if (orderTime is DateTime) {
        dateTime = orderTime;
      } else if (orderTime is int) {
        dateTime =
            DateTime.fromMillisecondsSinceEpoch(
              orderTime,
            );
      } else if (orderTime is String) {
        final int? milliseconds =
        int.tryParse(orderTime);

        if (milliseconds != null) {
          dateTime =
              DateTime.fromMillisecondsSinceEpoch(
                milliseconds,
              );
        } else {
          dateTime =
              DateTime.tryParse(orderTime);
        }
      }

      if (dateTime == null) {
        return "Time not available";
      }

      final String day =
      dateTime.day.toString().padLeft(2, "0");

      final String month =
      dateTime.month.toString().padLeft(2, "0");

      final String year =
      dateTime.year.toString();

      final String hour =
      dateTime.hour.toString().padLeft(2, "0");

      final String minute =
      dateTime.minute.toString().padLeft(2, "0");

      return "$day/$month/$year  $hour:$minute";
    } catch (_) {
      return "Time not available";
    }
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: "New Available Orders",
      ),
      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        // -----------------------------------------------------
        // LOAD ORDERS THAT CAN POTENTIALLY BE ACCEPTED
        //
        // Packed is now included.
        // -----------------------------------------------------

        stream: FirebaseFirestore.instance
            .collection("orders")
            .where(
          "status",
          whereIn: const [
            "Confirmed",
            "Preparing",
            "Packed",
          ],
        )
            .snapshots(),

        builder: (
            context,
            snapshot,
            ) {
          // -------------------------------------------------
          // LOADING
          // -------------------------------------------------

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1565C0),
              ),
            );
          }

          // -------------------------------------------------
          // ERROR
          // -------------------------------------------------

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding:
                const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Unable to load available orders.",
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${snapshot.error}",
                      textAlign:
                      TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // -------------------------------------------------
          // NO DATA
          // -------------------------------------------------

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Padding(
                padding:
                EdgeInsets.all(20),
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delivery_dining,
                      size: 70,
                      color: Color(0xFF1565C0),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "No new orders available.",
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "New delivery orders will appear here.",
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // -------------------------------------------------
          // FILTER AVAILABLE ORDERS
          // -------------------------------------------------

          final List<
              QueryDocumentSnapshot<
                  Map<String, dynamic>>> availableOrders = [];

          for (final document
          in snapshot.data!.docs) {
            final Map<String, dynamic> data =
            document.data();

            if (isAvailableForRider(data)) {
              availableOrders.add(
                document,
              );
            }
          }

          // -------------------------------------------------
          // NO AVAILABLE ORDERS
          // -------------------------------------------------

          if (availableOrders.isEmpty) {
            return const Center(
              child: Padding(
                padding:
                EdgeInsets.all(20),
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 70,
                      color: Colors.green,
                    ),
                    SizedBox(height: 15),
                    Text(
                      "No unassigned orders right now.",
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Check again when new orders arrive.",
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // -------------------------------------------------
          // SORT NEWEST FIRST
          // -------------------------------------------------

          availableOrders.sort(
                (
                QueryDocumentSnapshot<
                    Map<String, dynamic>> a,
                QueryDocumentSnapshot<
                    Map<String, dynamic>> b,
                ) {
              final dynamic timeA =
              a.data()["orderTime"];

              final dynamic timeB =
              b.data()["orderTime"];

              DateTime getTime(
                  dynamic value,
                  ) {
                if (value is Timestamp) {
                  return value.toDate();
                }

                if (value is DateTime) {
                  return value;
                }

                if (value is int) {
                  return DateTime
                      .fromMillisecondsSinceEpoch(
                    value,
                  );
                }

                if (value is String) {
                  final int? milliseconds =
                  int.tryParse(value);

                  if (milliseconds != null) {
                    return DateTime
                        .fromMillisecondsSinceEpoch(
                      milliseconds,
                    );
                  }

                  return DateTime.tryParse(
                    value,
                  ) ??
                      DateTime
                          .fromMillisecondsSinceEpoch(
                        0,
                      );
                }

                return DateTime
                    .fromMillisecondsSinceEpoch(
                  0,
                );
              }

              return getTime(timeB).compareTo(
                getTime(timeA),
              );
            },
          );

          // -------------------------------------------------
          // ORDER LIST
          // -------------------------------------------------

          return ListView.builder(
            padding:
            const EdgeInsets.fromLTRB(
              12,
              15,
              12,
              25,
            ),
            itemCount:
            availableOrders.length,
            itemBuilder:
                (context, index) {
              final QueryDocumentSnapshot<
                  Map<String, dynamic>>
              document =
              availableOrders[index];

              final Map<String, dynamic>
              data =
              document.data();

              final String orderId =
                  document.id;

              final String status =
                  data["status"]
                      ?.toString() ??
                      "Unknown";

              final String sellerUID =
                  data["sellerUID"]
                      ?.toString() ??
                      "";

              final String orderedBy =
                  data["orderedBy"]
                      ?.toString() ??
                      "";

              final String totalAmount =
                  data["totolAmmount"]
                      ?.toString() ??
                      data["totalAmount"]
                          ?.toString() ??
                      "0";

              final String orderTime =
              formatOrderTime(
                data["orderTime"],
              );

              return Card(
                margin:
                const EdgeInsets.only(
                  bottom: 15,
                ),
                elevation: 4,
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    16,
                  ),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.all(
                    16,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      // -----------------------------------------
                      // HEADER
                      // -----------------------------------------

                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundColor:
                            Color(0xFFE3F2FD),
                            child: Icon(
                              Icons
                                  .shopping_bag_outlined,
                              color:
                              Color(0xFF1565C0),
                              size: 28,
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Text(
                              "New Order",
                              style:
                              const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),
                          ),

                          // ---------------------------------------
                          // STATUS BADGE
                          // ---------------------------------------

                          Container(
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration:
                            BoxDecoration(
                              color:
                              status ==
                                  "Packed"
                                  ? const Color(
                                0xFFF3E5F5,
                              )
                                  : status ==
                                  "Preparing"
                                  ? const Color(
                                0xFFE8F5E9,
                              )
                                  : Colors
                                  .orange
                                  .shade100,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                20,
                              ),
                            ),
                            child: Text(
                              status,
                              style:
                              TextStyle(
                                color: status ==
                                    "Packed"
                                    ? const Color(
                                  0xFF7B1FA2,
                                )
                                    : status ==
                                    "Preparing"
                                    ? const Color(
                                  0xFF2E7D32,
                                )
                                    : Colors
                                    .orange
                                    .shade900,
                                fontWeight:
                                FontWeight
                                    .bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      const Divider(),

                      const SizedBox(
                        height: 8,
                      ),

                      // -----------------------------------------
                      // ORDER ID
                      // -----------------------------------------

                      Text(
                        "Order ID: $orderId",
                        style:
                        const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      // -----------------------------------------
                      // CUSTOMER
                      // -----------------------------------------

                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 21,
                            color:
                            Color(0xFF1565C0),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              orderedBy.isEmpty
                                  ? "Customer not available"
                                  : "Customer: $orderedBy",
                              style:
                              const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // -----------------------------------------
                      // SELLER
                      // -----------------------------------------

                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          const Icon(
                            Icons.store_outlined,
                            size: 21,
                            color:
                            Color(0xFF1565C0),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              sellerUID.isEmpty
                                  ? "Seller not available"
                                  : "Seller: $sellerUID",
                              style:
                              const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // -----------------------------------------
                      // TOTAL
                      // -----------------------------------------

                      Row(
                        children: [
                          const Icon(
                            Icons.currency_rupee,
                            size: 21,
                            color:
                            Color(0xFF1565C0),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Total: ₹$totalAmount",
                            style:
                            const TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight
                                  .bold,
                              color:
                              Color(
                                0xFF1565C0,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // -----------------------------------------
                      // ORDER TIME
                      // -----------------------------------------

                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 21,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              orderTime,
                              style:
                              const TextStyle(
                                fontSize: 13,
                                color:
                                Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // -----------------------------------------
                      // VIEW ORDER
                      // -----------------------------------------

                      SizedBox(
                        width:
                        double.infinity,
                        height: 48,
                        child:
                        ElevatedButton(
                          onPressed: () {
                            openOrderDetails(
                              context,
                              orderId,
                            );
                          },
                          style:
                          ElevatedButton
                              .styleFrom(
                            backgroundColor:
                            const Color(
                              0xFF1565C0,
                            ),
                            foregroundColor:
                            Colors.white,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                12,
                              ),
                            ),
                          ),
                          child:
                          const Text(
                            "View Order & Accept",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}