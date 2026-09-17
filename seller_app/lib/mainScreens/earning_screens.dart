import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/global/global.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({
    super.key,
  });

  @override
  State<EarningScreen> createState() =>
      _EarningScreenState();
}

class _EarningScreenState
    extends State<EarningScreen> {
  static const Color darkBlue =
  Color(0xFF1565C0);

  static const Color mediumBlue =
  Color(0xFF42A5F5);

  static const Color lightBlue =
  Color(0xFF90CAF9);

  double getOrderAmount(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    ) ??
        0;
  }

  double calculateDeliveredEarnings(
      QuerySnapshot snapshot,
      ) {
    double total = 0;

    for (final QueryDocumentSnapshot document
    in snapshot.docs) {
      final dynamic rawData =
      document.data();

      if (rawData
      is! Map<String, dynamic>) {
        continue;
      }

      final String status =
          rawData["status"]
              ?.toString()
              .trim() ??
              "";

      if (status != "Delivered") {
        continue;
      }

      total += getOrderAmount(
        rawData["totolAmmount"],
      );
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final String sellerUID =
        sharedPreferences?.getString("uid") ?? "";

    if (sellerUID.isEmpty) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                darkBlue,
                mediumBlue,
                lightBlue,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const SafeArea(
            child: Center(
              child: Text(
                "Seller information is not available.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              darkBlue,
              mediumBlue,
              lightBlue,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            // Only sellerUID is used in Firestore.
            // This avoids composite-index requirements.
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
              double totalEarnings = 0;

              if (snapshot.hasData) {
                totalEarnings =
                    calculateDeliveredEarnings(
                      snapshot.data!,
                    );
              }

              return Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons
                        .account_balance_wallet_outlined,
                    size: 70,
                    color: Colors.white,
                  ),

                  const SizedBox(height: 20),

                  if (snapshot.connectionState ==
                      ConnectionState.waiting &&
                      !snapshot.hasData)
                    const SizedBox(
                      width: 35,
                      height: 35,
                      child:
                      CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  else if (snapshot.hasError)
                    const Text(
                      "Unable to load earnings",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    )
                  else
                    Text(
                      "₹${totalEarnings.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontFamily: "Signatra",
                      ),
                    ),

                  const SizedBox(height: 5),

                  const Text(
                    "Total Earnings",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight:
                      FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                    width: 200,
                    child: Divider(
                      color: Colors.white,
                      thickness: 1.5,
                    ),
                  ),

                  const SizedBox(height: 25),

                  if (snapshot.hasData &&
                      !snapshot.hasError)
                    Text(
                      "Earnings from delivered orders",
                      style: TextStyle(
                        color: Colors.white
                            .withValues(
                          alpha: 0.9,
                        ),
                        fontSize: 13,
                      ),
                    ),

                  const SizedBox(height: 15),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin:
                      const EdgeInsets.symmetric(
                        horizontal: 100,
                      ),
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: darkBlue,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Back",
                            style: TextStyle(
                              color: darkBlue,
                              fontWeight:
                              FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}