import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:rider_app/models/address.dart';
import 'package:rider_app/widgets/progress_bar.dart';

import '../global/global.dart';
import '../widgets/shipment_address_design.dart';
import '../widgets/status_banner.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? orderId;

  const OrderDetailsScreen({
    super.key,
    this.orderId,
  });

  @override
  State<OrderDetailsScreen> createState() =>
      _OrderDetailsScreenState();
}

class _OrderDetailsScreenState
    extends State<OrderDetailsScreen> {

  // ---------------------------------------------------------
  // GET ORDER
  // ---------------------------------------------------------

  Future<DocumentSnapshot<Map<String, dynamic>>>
  getOrder() async {
    if (widget.orderId == null ||
        widget.orderId!.isEmpty) {
      throw Exception("Invalid order ID.");
    }

    return FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderId)
        .get();
  }

  // ---------------------------------------------------------
  // FORMAT ORDER TIME
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
        return "Not available";
      }

      return DateFormat(
        "dd MMMM yyyy hh:mm aa",
      ).format(dateTime);
    } catch (_) {
      return "Not available";
    }
  }

  // ---------------------------------------------------------
  // FORMAT NUMBER
  // ---------------------------------------------------------

  String formatNumber(dynamic value) {
    if (value == null) {
      return "Not available";
    }

    if (value is num) {
      return value.toStringAsFixed(6);
    }

    final double? number =
    double.tryParse(value.toString());

    if (number == null) {
      return "Not available";
    }

    return number.toStringAsFixed(6);
  }

  // ---------------------------------------------------------
  // GET USER ADDRESS
  // ---------------------------------------------------------

  Future<DocumentSnapshot<Map<String, dynamic>>>
  getUserAddress(
      String userUID,
      String addressId,
      ) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userUID)
        .collection("userAddress")
        .doc(addressId)
        .get();
  }

  // ---------------------------------------------------------
  // BUILD INFO ROW
  // ---------------------------------------------------------

  Widget buildInfoRow(
      IconData icon,
      String label,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF1565C0),
            size: 22,
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // RIDER INFORMATION
  // ---------------------------------------------------------

  Widget buildRiderInformation(
      Map<String, dynamic> dataMap,
      String riderId,
      String currentStatus,
      ) {
    final String riderName =
        dataMap["riderName"]?.toString().trim() ??
            "";

    final dynamic riderLat =
    dataMap["riderLat"];

    final dynamic riderLng =
    dataMap["riderLng"];

    final String riderAddress =
        dataMap["riderAddress"]
            ?.toString()
            .trim() ??
            "";

    final String riderStage =
        dataMap["riderStage"]
            ?.toString()
            .trim() ??
            "";

    final bool locationActive =
        dataMap["riderLocationActive"] == true;

    final bool hasRider =
        riderId.isNotEmpty;

    final bool hasCoordinates =
        riderLat != null &&
            riderLng != null;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            "Rider Information",
            style: TextStyle(
              color: Color(0xFF1565C0),
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          buildInfoRow(
            Icons.person_outline,
            "Rider",
            hasRider
                ? (riderName.isNotEmpty
                ? riderName
                : "Assigned")
                : "Not assigned",
          ),

          buildInfoRow(
            Icons.badge_outlined,
            "Rider ID",
            hasRider
                ? riderId
                : "Not assigned",
          ),

          buildInfoRow(
            Icons.local_shipping_outlined,
            "Stage",
            riderStage.isNotEmpty
                ? riderStage
                : currentStatus,
          ),

          buildInfoRow(
            Icons.gps_fixed,
            "Location",
            locationActive
                ? "Live location active"
                : hasCoordinates
                ? "Last location available"
                : "Not available",
          ),

          if (hasCoordinates) ...[
            buildInfoRow(
              Icons.my_location,
              "Latitude",
              formatNumber(riderLat),
            ),
            buildInfoRow(
              Icons.my_location,
              "Longitude",
              formatNumber(riderLng),
            ),
          ],

          if (riderAddress.isNotEmpty)
            buildInfoRow(
              Icons.location_on_outlined,
              "Address",
              riderAddress,
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor:
        const Color(0xFF1565C0),
        elevation: 0,
        iconTheme:
        const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: FutureBuilder<
          DocumentSnapshot<Map<String, dynamic>>>(
        future: getOrder(),

        builder: (context, snapshot) {
          // ---------------------------------------------------
          // LOADING
          // ---------------------------------------------------

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: circularProgress(),
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
                child: Text(
                  "Unable to load order details.\n\n"
                      "${snapshot.error}",
                  textAlign:
                  TextAlign.center,
                ),
              ),
            );
          }

          // ---------------------------------------------------
          // ORDER NOT FOUND
          // ---------------------------------------------------

          if (!snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(
              child: Text(
                "Order not found.",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            );
          }

          final Map<String, dynamic> dataMap =
              snapshot.data!.data() ?? {};

          // ---------------------------------------------------
          // ORDER DATA
          // ---------------------------------------------------

          final String orderStatus =
              dataMap["status"]
                  ?.toString()
                  .trim() ??
                  "";

          final String orderByUser =
              dataMap["orderedBy"]
                  ?.toString()
                  .trim() ??
                  "";

          final String sellerId =
              dataMap["sellerUID"]
                  ?.toString()
                  .trim() ??
                  "";

          final String riderId =
              dataMap["riderUID"]
                  ?.toString()
                  .trim() ??
                  "";

          final String addressId =
              dataMap["addressId"]
                  ?.toString()
                  .trim() ??
                  "";

          final dynamic totalAmount =
              dataMap["totolAmmount"] ??
                  dataMap["totalAmount"] ??
                  0;

          final dynamic isSuccess =
              dataMap["isSuccess"] ??
                  false;

          final String sellerName =
              dataMap["sellerName"]
                  ?.toString()
                  .trim() ??
                  "";

          final bool isDelivered =
              orderStatus.toLowerCase() ==
                  "delivered";

          // ---------------------------------------------------
          // CURRENT RIDER
          // ---------------------------------------------------

          final String? currentRiderUID =
              firebaseAuth.currentUser?.uid ??
                  sharedPreferences
                      ?.getString("uid");

          // ---------------------------------------------------
          // OWNERSHIP CHECK
          // ---------------------------------------------------

          if (riderId.isNotEmpty &&
              currentRiderUID != null &&
              riderId != currentRiderUID) {
            return const Center(
              child: Padding(
                padding:
                EdgeInsets.all(20),
                child: Text(
                  "This order is assigned to another rider.",
                  textAlign:
                  TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            );
          }

          // ---------------------------------------------------
          // MAIN CONTENT
          // ---------------------------------------------------

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),

                // ---------------------------------------------
                // STATUS
                // ---------------------------------------------

                StatusBanner(
                  status: isSuccess,
                  orderStatus:
                  orderStatus,
                ),

                const SizedBox(height: 15),

                // ---------------------------------------------
                // TOTAL AMOUNT
                // ---------------------------------------------

                Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: Align(
                    alignment:
                    Alignment.centerLeft,
                    child: Text(
                      "₹$totalAmount",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        Color(0xFF1565C0),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ---------------------------------------------
                // ORDER ID
                // ---------------------------------------------

                Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: Align(
                    alignment:
                    Alignment.centerLeft,
                    child: Text(
                      "Order ID: ${widget.orderId}",
                      style:
                      const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ---------------------------------------------
                // ORDER TIME
                // ---------------------------------------------

                Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: Align(
                    alignment:
                    Alignment.centerLeft,
                    child: Text(
                      "Order at: "
                          "${formatOrderTime(dataMap["orderTime"])}",
                      style:
                      const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ---------------------------------------------
                // SELLER
                // ---------------------------------------------

                if (sellerId.isNotEmpty)
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Align(
                      alignment:
                      Alignment.centerLeft,
                      child: Text(
                        sellerName.isNotEmpty
                            ? "Restaurant: $sellerName"
                            : "Restaurant ID: $sellerId",
                        style:
                        const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 15),

                const Divider(
                  thickness: 2,
                  height: 30,
                ),

                // ---------------------------------------------
                // STATUS IMAGE
                // ---------------------------------------------

                Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.circular(
                      15,
                    ),
                    child: Image.asset(
                      isDelivered
                          ? 'assets/images/succes.jpg'
                          : 'assets/images/confirm_pick.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ---------------------------------------------
                // RIDER INFORMATION
                // ---------------------------------------------

                buildRiderInformation(
                  dataMap,
                  riderId,
                  orderStatus,
                ),

                const SizedBox(height: 20),

                // ---------------------------------------------
                // DELIVERY ADDRESS
                // ---------------------------------------------

                if (orderByUser.isNotEmpty &&
                    addressId.isNotEmpty)
                  FutureBuilder<
                      DocumentSnapshot<
                          Map<String, dynamic>>>(
                    future: getUserAddress(
                      orderByUser,
                      addressId,
                    ),
                    builder:
                        (
                        context,
                        addressSnapshot,
                        ) {
                      if (addressSnapshot
                          .connectionState ==
                          ConnectionState
                              .waiting) {
                        return Center(
                          child:
                          circularProgress(),
                        );
                      }

                      if (addressSnapshot
                          .hasError ||
                          !addressSnapshot
                              .hasData ||
                          !addressSnapshot
                              .data!
                              .exists) {
                        return const Padding(
                          padding:
                          EdgeInsets.all(20),
                          child: Text(
                            "Delivery address not available.",
                            textAlign:
                            TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        );
                      }

                      final addressData =
                          addressSnapshot
                              .data!
                              .data() ??
                              {};

                      return ShipmentAddressDesign(
                        model:
                        Address.fromJson(
                          addressData,
                        ),
                        orderStatus:
                        orderStatus,
                        orderId:
                        widget.orderId,
                        sellerId:
                        sellerId,
                        orderByUser:
                        orderByUser,
                      );
                    },
                  )
                else
                  const Padding(
                    padding:
                    EdgeInsets.all(20),
                    child: Text(
                      "Delivery address not available.",
                      textAlign:
                      TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}