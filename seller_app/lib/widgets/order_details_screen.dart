import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seller_app/model/address.dart';
import 'package:seller_app/widgets/progress_bar.dart';
import 'package:seller_app/widgets/shipment_address_design.dart';
import 'package:seller_app/widgets/status_banner.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? orderId;

  const OrderDetailsScreen({
    super.key,
    this.orderId,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String orderStatus = "";
  String orderByUser = "";
  String sellerId = "";

  Future<void> getOrderInfo() async {
    final String? currentOrderId = widget.orderId;

    if (currentOrderId == null || currentOrderId.isEmpty) {
      return;
    }

    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("orders")
          .doc(currentOrderId)
          .get();

      final dynamic rawData = snapshot.data();

      if (rawData is! Map<String, dynamic>) {
        return;
      }

      if (!mounted) return;

      setState(() {
        orderStatus = rawData["status"]?.toString() ?? "";
        orderByUser = rawData["orderedBy"]?.toString() ?? "";
        sellerId = rawData["sellerUID"]?.toString() ?? "";
      });
    } catch (error) {
      // Keep the screen usable if order information cannot be loaded.
    }
  }

  @override
  void initState() {
    super.initState();
    getOrderInfo();
  }

  @override
  Widget build(BuildContext context) {
    final String? currentOrderId = widget.orderId;

    if (currentOrderId == null || currentOrderId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Order Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF42A5F5),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            "Order information is unavailable.",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF42A5F5),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("orders")
              .doc(currentOrderId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: circularProgress(),
                ),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "Unable to load order details.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              );
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "Order not found.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }

            final dynamic rawData = snapshot.data!.data();

            if (rawData is! Map<String, dynamic>) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "Invalid order information.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }

            final Map<String, dynamic> dataMap = rawData;

            final String currentOrderStatus =
                dataMap["status"]?.toString() ?? "";

            final String currentOrderByUser =
                dataMap["orderedBy"]?.toString() ?? "";

            final String currentSellerId =
                dataMap["sellerUID"]?.toString() ?? "";

            final String totalAmount =
                dataMap["totolAmmount"]?.toString() ?? "0";

            final bool isSuccess = dataMap["isSuccess"] == true;

            final String addressId =
                dataMap["addressId"]?.toString() ?? "";

            final String orderTimeString =
                dataMap["orderTime"]?.toString() ?? "";

            DateTime? orderDateTime;

            final int? orderTime = int.tryParse(orderTimeString);

            if (orderTime != null) {
              orderDateTime =
                  DateTime.fromMillisecondsSinceEpoch(orderTime);
            }

            return Column(
              children: [
                StatusBanner(
                  status: isSuccess,
                  orderStatus: currentOrderStatus,
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "₹$totalAmount",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    "Order ID = $currentOrderId",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    orderDateTime != null
                        ? "Order at: ${DateFormat("dd MMMM yyyy hh:mm aa").format(orderDateTime)}"
                        : "Order time unavailable",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ),

                const Divider(
                  thickness: 4,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: currentOrderStatus != "ended"
                      ? Image.asset(
                    "assets/images/packing.png",
                    height: 180,
                    fit: BoxFit.contain,
                  )
                      : Image.asset(
                    "assets/images/delivered.jpg",
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),

                const Divider(
                  thickness: 4,
                ),

                if (currentOrderByUser.isNotEmpty &&
                    addressId.isNotEmpty)
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("users")
                        .doc(currentOrderByUser)
                        .collection("userAddress")
                        .doc(addressId)
                        .get(),
                    builder: (context, addressSnapshot) {
                      if (addressSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: circularProgress(),
                          ),
                        );
                      }

                      if (addressSnapshot.hasError ||
                          !addressSnapshot.hasData ||
                          !addressSnapshot.data!.exists) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "Shipping address is unavailable.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        );
                      }

                      final dynamic addressRawData =
                      addressSnapshot.data!.data();

                      if (addressRawData is! Map<String, dynamic>) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "Invalid shipping address.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        );
                      }

                      return ShipmentAddressDesign(
                        model: Address.fromJson(addressRawData),
                        orderStatus: currentOrderStatus,
                        orderId: currentOrderId,
                        sellerId: currentSellerId,
                        orderByUser: currentOrderByUser,
                      );
                    },
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Shipping address is unavailable.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}