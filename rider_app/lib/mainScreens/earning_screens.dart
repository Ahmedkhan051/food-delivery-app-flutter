import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  bool isLoading = true;
  double totalEarnings = 0.0;
  int deliveredOrders = 0;

  String? get riderUID {
    return firebaseAuth.currentUser?.uid ??
        sharedPreferences?.getString("uid");
  }

  // ---------------------------------------------------------
  // GET RIDER EARNINGS FROM DELIVERED ORDERS
  // ---------------------------------------------------------

  Stream<QuerySnapshot<Map<String, dynamic>>>
  getDeliveredOrdersStream() {
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
  // CALCULATE RIDER EARNING
  // ---------------------------------------------------------
  //
  // Rider earning rule:
  // 10% of the delivered order total.
  //
  // Examples:
  // ₹100  -> ₹10
  // ₹200  -> ₹20
  // ₹500  -> ₹50
  // ₹1000 -> ₹100
  // ₹2000 -> ₹200
  //
  // If a valid riderDeliveryAmount already exists, it is used.
  // Otherwise, the amount is calculated from the order total.
  // ---------------------------------------------------------

  double getDeliveryAmount(
      Map<String, dynamic> data,
      ) {
    final dynamic storedAmount =
        data["riderDeliveryAmount"] ??
            data["deliveryFee"] ??
            data["parcelDeliveryAmount"];

    double parsedStoredAmount = 0.0;

    if (storedAmount is num) {
      parsedStoredAmount = storedAmount.toDouble();
    } else if (storedAmount != null) {
      parsedStoredAmount =
          double.tryParse(
            storedAmount.toString(),
          ) ??
              0.0;
    }

    // Use an already calculated positive rider amount.
    if (parsedStoredAmount > 0) {
      return parsedStoredAmount;
    }

    // -------------------------------------------------------
    // FALLBACK: CALCULATE 10% FROM ORDER TOTAL
    // -------------------------------------------------------

    final dynamic rawOrderTotal =
        data["totolAmmount"] ??
            data["totalAmount"] ??
            data["orderTotal"] ??
            0;

    double orderTotal = 0.0;

    if (rawOrderTotal is num) {
      orderTotal = rawOrderTotal.toDouble();
    } else {
      orderTotal =
          double.tryParse(
            rawOrderTotal.toString(),
          ) ??
              0.0;
    }

    if (orderTotal <= 0) {
      return 0.0;
    }

    return orderTotal * 0.10;
  }

  // ---------------------------------------------------------
  // UPDATE RIDER EARNINGS DOCUMENT
  // ---------------------------------------------------------

  Future<void> syncRiderEarnings(
      double earnings,
      ) async {
    final String? uid = riderUID;

    if (uid == null || uid.isEmpty) {
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("riders")
          .doc(uid)
          .set(
        {
          "earnings":
          earnings.toStringAsFixed(2),
          "updatedAt":
          FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      previousRidersEarnings =
          earnings.toStringAsFixed(2);
    } catch (_) {
      // Earnings display should still work even if
      // the rider document cannot be synchronized.
    }
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final String? uid = riderUID;

    if (uid == null || uid.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Earnings",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor:
          const Color(0xFF1565C0),
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            "Rider account not found.",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          "Earnings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor:
        const Color(0xFF1565C0),
        elevation: 0,
      ),

      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream: getDeliveredOrdersStream(),

        builder: (
            context,
            snapshot,
            ) {
          // ---------------------------------------------------
          // LOADING
          // ---------------------------------------------------

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1565C0),
              ),
            );
          }

          // ---------------------------------------------------
          // ERROR
          // ---------------------------------------------------

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding:
                const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 65,
                      color: Colors.grey,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "Unable to load rider earnings.",
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "${snapshot.error}",
                      textAlign:
                      TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // ---------------------------------------------------
          // CALCULATE TOTAL
          // ---------------------------------------------------

          final orders =
              snapshot.data?.docs ?? [];

          double earnings = 0.0;

          for (final order in orders) {
            earnings +=
                getDeliveryAmount(
                  order.data(),
                );
          }

          deliveredOrders =
              orders.length;

          totalEarnings = earnings;

          previousRidersEarnings =
              earnings.toStringAsFixed(2);

          isLoading = false;

          // Keep rider document synchronized with
          // the delivered-order total.
          syncRiderEarnings(earnings);

          // ---------------------------------------------------
          // BODY
          // ---------------------------------------------------

          return RefreshIndicator(
            onRefresh: () async {
              await Future<void>.delayed(
                const Duration(
                  milliseconds: 300,
                ),
              );

              if (!mounted) return;

              setState(() {});
            },

            child: ListView(
              physics:
              const AlwaysScrollableScrollPhysics(),

              padding:
              const EdgeInsets.all(24),

              children: [

                const SizedBox(height: 25),

                // ==========================================
                // TOTAL EARNINGS CARD
                // ==========================================

                Container(
                  width:
                  double.infinity,

                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 20,
                  ),

                  decoration:
                  BoxDecoration(
                    gradient:
                    const LinearGradient(
                      colors: [
                        Color(0xFF1565C0),
                        Color(0xFF42A5F5),
                      ],
                      begin:
                      Alignment.topLeft,
                      end:
                      Alignment.bottomRight,
                    ),

                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: Column(
                    children: [

                      const Icon(
                        Icons
                            .account_balance_wallet,
                        color: Colors.white,
                        size: 55,
                      ),

                      const SizedBox(height: 20),

                      if (isLoading)
                        const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      else
                        Text(
                          "₹${totalEarnings.toStringAsFixed(2)}",
                          style:
                          const TextStyle(
                            fontSize: 42,
                            color: Colors.white,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                      const SizedBox(height: 10),

                      const Text(
                        "TOTAL EARNINGS",
                        style:
                        TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontWeight:
                          FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==========================================
                // DELIVERED ORDERS CARD
                // ==========================================

                Card(
                  elevation: 3,

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      15,
                    ),
                  ),

                  child: Padding(
                    padding:
                    const EdgeInsets.all(20),

                    child: Row(
                      children: [

                        Container(
                          width: 52,
                          height: 52,

                          decoration:
                          BoxDecoration(
                            color:
                            const Color(
                              0xFFE3F2FD,
                            ),
                            borderRadius:
                            BorderRadius
                                .circular(
                              12,
                            ),
                          ),

                          child: const Icon(
                            Icons
                                .local_shipping,
                            color:
                            Color(
                              0xFF1565C0,
                            ),
                            size: 30,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [

                              const Text(
                                "Delivered Orders",
                                style:
                                TextStyle(
                                  fontSize: 14,
                                  color:
                                  Colors.grey,
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              Text(
                                "$deliveredOrders",
                                style:
                                const TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                  FontWeight.bold,
                                  color:
                                  Color(
                                    0xFF1565C0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // ==========================================
                // AVERAGE EARNING CARD
                // ==========================================

                Card(
                  elevation: 3,

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      15,
                    ),
                  ),

                  child: Padding(
                    padding:
                    const EdgeInsets.all(20),

                    child: Row(
                      children: [

                        Container(
                          width: 52,
                          height: 52,

                          decoration:
                          BoxDecoration(
                            color:
                            const Color(
                              0xFFE8F5E9,
                            ),
                            borderRadius:
                            BorderRadius
                                .circular(
                              12,
                            ),
                          ),

                          child: const Icon(
                            Icons.trending_up,
                            color:
                            Colors.green,
                            size: 30,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [

                              const Text(
                                "Average Per Delivery",
                                style:
                                TextStyle(
                                  fontSize: 14,
                                  color:
                                  Colors.grey,
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              Text(
                                deliveredOrders ==
                                    0
                                    ? "₹0.00"
                                    : "₹${(totalEarnings / deliveredOrders).toStringAsFixed(2)}",
                                style:
                                const TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                  FontWeight.bold,
                                  color:
                                  Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ==========================================
                // INFORMATION CARD
                // ==========================================

                Card(
                  elevation: 3,

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      15,
                    ),
                  ),

                  child: const Padding(
                    padding:
                    EdgeInsets.all(20),

                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Icon(
                          Icons.info_outline,
                          color:
                          Color(0xFF1565C0),
                          size: 28,
                        ),

                        SizedBox(width: 15),

                        Expanded(
                          child: Text(
                            "Rider earnings are calculated as 10% of the delivered order total.",
                            style:
                            TextStyle(
                              fontSize: 14,
                              color:
                              Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // ==========================================
                // BACK BUTTON
                // ==========================================

                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },

                    icon: const Icon(
                      Icons.arrow_back,
                      color:
                      Color(0xFF1565C0),
                    ),

                    label: const Text(
                      "Back",
                      style:
                      TextStyle(
                        color:
                        Color(
                          0xFF1565C0,
                        ),
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}