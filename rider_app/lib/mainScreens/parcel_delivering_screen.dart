import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:rider_app/assistant_methods/get_current_location.dart';
import 'package:rider_app/global/global.dart';
import 'package:rider_app/maps/map_utils.dart';
import 'package:rider_app/splashScreen/splash_screen.dart';

class ParcelDeliveringScreen extends StatefulWidget {
  final String? purchaserId;
  final String? purchaserAddress;
  final String? purchaserLat;
  final String? purchaserLng;

  final String? sellerId;
  final String? getOrderId;

  const ParcelDeliveringScreen({
    super.key,
    this.purchaserId,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
    this.sellerId,
    this.getOrderId,
  });

  @override
  State<ParcelDeliveringScreen> createState() =>
      _ParcelDeliveringScreenState();
}

class _ParcelDeliveringScreenState
    extends State<ParcelDeliveringScreen> {
  bool isLoading = true;
  bool isConfirming = false;

  String orderTotalAmount = "";
  String sellerId = "";
  String riderUID = "";

  // ---------------------------------------------------------
  // LIVE LOCATION
  // ---------------------------------------------------------

  Timer? _locationTimer;
  bool _locationUpdating = false;

  // ---------------------------------------------------------
  // GET CURRENT RIDER UID
  // ---------------------------------------------------------

  String? get currentRiderUID {
    return firebaseAuth.currentUser?.uid ??
        sharedPreferences?.getString("uid");
  }

  // ---------------------------------------------------------
  // GET RIDER NAME
  // ---------------------------------------------------------

  String get riderName {
    return sharedPreferences?.getString("name") ??
        firebaseAuth.currentUser?.displayName ??
        "Rider";
  }

  // ---------------------------------------------------------
  // LOAD ORDER DATA
  // ---------------------------------------------------------

  Future<void> getOrderTotalAmount() async {
    try {
      if (widget.getOrderId == null ||
          widget.getOrderId!.isEmpty) {
        return;
      }

      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection("orders")
          .doc(widget.getOrderId)
          .get();

      if (!snapshot.exists) {
        return;
      }

      final Map<String, dynamic> data =
          snapshot.data() ?? {};

      orderTotalAmount =
          (data["totolAmmount"] ??
              data["totalAmount"] ??
              0)
              .toString();

      sellerId =
          data["sellerUID"]?.toString() ??
              widget.sellerId ??
              "";

      riderUID =
          data["riderUID"]?.toString() ??
              currentRiderUID ??
              "";
    } catch (_) {
      // Keep default values.
    }
  }

  // ---------------------------------------------------------
  // UPDATE LIVE RIDER LOCATION
  // ---------------------------------------------------------

  Future<void> updateLiveRiderLocation() async {
    if (_locationUpdating) return;

    final String? riderId = currentRiderUID;
    final String? orderId = widget.getOrderId;

    if (riderId == null ||
        riderId.isEmpty ||
        orderId == null ||
        orderId.isEmpty) {
      return;
    }

    _locationUpdating = true;

    try {
      final UserLocation userLocation =
      UserLocation();

      final bool success =
      await userLocation.getCurrentLocation();

      if (!success || position == null) {
        return;
      }

      final double currentLat =
          position!.latitude;

      final double currentLng =
          position!.longitude;

      // -------------------------------------------------------
      // UPDATE RIDER DOCUMENT
      // -------------------------------------------------------

      await FirebaseFirestore.instance
          .collection("riders")
          .doc(riderId)
          .set(
        {
          "lat": currentLat,
          "lng": currentLng,

          "location": {
            "lat": currentLat,
            "lng": currentLng,
          },

          "updatedAt":
          FieldValue.serverTimestamp(),

          "locationUpdatedAt":
          FieldValue.serverTimestamp(),

          "activeOrderId": orderId,

          "activeOrderStatus":
          "Out for Delivery",
        },
        SetOptions(merge: true),
      );

      // -------------------------------------------------------
      // UPDATE SHARED ORDER DOCUMENT
      // -------------------------------------------------------

      await FirebaseFirestore.instance
          .collection("orders")
          .doc(orderId)
          .update(
        {
          "riderUID": riderId,
          "riderName": riderName,

          "riderLat": currentLat,
          "riderLng": currentLng,

          "riderAddress":
          completeAddress,

          "riderLocation": {
            "lat": currentLat,
            "lng": currentLng,
          },

          "riderLocationUpdatedAt":
          FieldValue.serverTimestamp(),

          "riderLocationActive": true,

          "riderStage":
          "Out for Delivery",
        },
      );
    } catch (_) {
      // Ignore temporary GPS/network errors.
    } finally {
      _locationUpdating = false;
    }
  }

  // ---------------------------------------------------------
  // CONFIRM DELIVERY
  // ---------------------------------------------------------

  Future<void>
  confirmParcelHasBeenDelivered() async {
    if (isConfirming) return;

    final String? riderId =
        currentRiderUID;

    if (widget.getOrderId == null ||
        widget.getOrderId!.isEmpty) {
      _showMessage(
        "Invalid order.",
      );
      return;
    }

    if (riderId == null ||
        riderId.isEmpty) {
      _showMessage(
        "Rider account not found.",
      );
      return;
    }

    if (!mounted) return;

    setState(() {
      isConfirming = true;
    });

    try {
      // -------------------------------------------------------
      // GET FINAL RIDER LOCATION
      // -------------------------------------------------------

      final UserLocation userLocation =
      UserLocation();

      final bool locationSuccess =
      await userLocation
          .getCurrentLocation();

      if (!locationSuccess ||
          position == null) {
        if (!mounted) return;

        setState(() {
          isConfirming = false;
        });

        _showMessage(
          "Unable to get your current location. "
              "Please enable location and try again.",
        );

        return;
      }

      final double finalLat =
          position!.latitude;

      final double finalLng =
          position!.longitude;

      // -------------------------------------------------------
      // ORDER REFERENCE
      // -------------------------------------------------------

      final DocumentReference<
          Map<String, dynamic>> orderReference =
      FirebaseFirestore.instance
          .collection("orders")
          .doc(widget.getOrderId);

      // -------------------------------------------------------
      // GET LATEST ORDER
      // -------------------------------------------------------

      final DocumentSnapshot<
          Map<String, dynamic>> orderSnapshot =
      await orderReference.get();

      if (!orderSnapshot.exists) {
        if (!mounted) return;

        setState(() {
          isConfirming = false;
        });

        _showMessage(
          "Order no longer exists.",
        );

        return;
      }

      final Map<String, dynamic> orderData =
          orderSnapshot.data() ?? {};

      // -------------------------------------------------------
      // VERIFY RIDER OWNERSHIP
      // -------------------------------------------------------

      final String assignedRider =
          orderData["riderUID"]
              ?.toString()
              .trim() ??
              "";

      if (assignedRider.isNotEmpty &&
          assignedRider != riderId) {
        if (!mounted) return;

        setState(() {
          isConfirming = false;
        });

        _showMessage(
          "This order is assigned to another rider.",
        );

        return;
      }

      // -------------------------------------------------------
      // CHECK CURRENT STATUS
      // -------------------------------------------------------

      final String currentStatus =
          orderData["status"]
              ?.toString()
              .trim() ??
              "";

      if (currentStatus
          .toLowerCase() ==
          "delivered") {
        if (!mounted) return;

        setState(() {
          isConfirming = false;
        });

        _showMessage(
          "This order has already been delivered.",
        );

        return;
      }

      // -------------------------------------------------------
      // UPDATE SHARED ORDER
      // -------------------------------------------------------

      await orderReference.update(
        {
          "status": "Delivered",

          "riderUID": riderId,

          "riderName": riderName,

          "deliveryAddress":
          widget.purchaserAddress ??
              "",

          // Final rider position.
          "lat": finalLat,
          "lng": finalLng,

          "riderLat": finalLat,
          "riderLng": finalLng,

          "riderAddress":
          completeAddress,

          "riderLocation": {
            "lat": finalLat,
            "lng": finalLng,
          },

          "riderLocationUpdatedAt":
          FieldValue.serverTimestamp(),

          "riderLocationActive": false,

          "riderStage": "Delivered",

          "riderDeliveryAmount":
          double.tryParse(
            perParcelDeliveryAmount,
          ) ??
              0.0,

          "deliveredAt":
          FieldValue.serverTimestamp(),

          "statusUpdatedAt":
          FieldValue.serverTimestamp(),
        },
      );

      // -------------------------------------------------------
      // UPDATE USER'S ORDER COPY
      // -------------------------------------------------------

      final String purchaserId =
          orderData["orderedBy"]
              ?.toString()
              .trim() ??
              widget.purchaserId ??
              "";

      if (purchaserId.isNotEmpty) {
        try {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(purchaserId)
              .collection("orders")
              .doc(widget.getOrderId)
              .update(
            {
              "status": "Delivered",

              "riderUID": riderId,

              "riderName": riderName,

              "riderLat": finalLat,
              "riderLng": finalLng,

              "riderAddress":
              completeAddress,

              "riderLocation": {
                "lat": finalLat,
                "lng": finalLng,
              },

              "riderLocationActive": false,

              "riderStage": "Delivered",

              "deliveredAt":
              FieldValue.serverTimestamp(),

              "statusUpdatedAt":
              FieldValue.serverTimestamp(),
            },
          );
        } catch (_) {
          // Main order is the source of truth.
        }
      }

      // -------------------------------------------------------
      // UPDATE RIDER DOCUMENT
      // -------------------------------------------------------

      final DocumentReference<
          Map<String, dynamic>> riderReference =
      FirebaseFirestore.instance
          .collection("riders")
          .doc(riderId);

      final DocumentSnapshot<
          Map<String, dynamic>> riderSnapshot =
      await riderReference.get();

      double currentEarnings = 0.0;

      if (riderSnapshot.exists) {
        final Map<String, dynamic> riderData =
            riderSnapshot.data() ?? {};

        currentEarnings =
            double.tryParse(
              riderData["earnings"]
                  ?.toString() ??
                  "",
            ) ??
                0.0;
      }

      // -------------------------------------------------------
      // DELIVERY EARNING
      // -------------------------------------------------------

      final double deliveryAmount =
          double.tryParse(
            perParcelDeliveryAmount,
          ) ??
              0.0;

      final double newEarnings =
          currentEarnings +
              deliveryAmount;

      // -------------------------------------------------------
      // MARK RIDER AVAILABLE
      // -------------------------------------------------------

      await riderReference.set(
        {
          "earnings":
          newEarnings.toStringAsFixed(2),

          "lat": finalLat,
          "lng": finalLng,

          "location": {
            "lat": finalLat,
            "lng": finalLng,
          },

          "locationUpdatedAt":
          FieldValue.serverTimestamp(),

          "updatedAt":
          FieldValue.serverTimestamp(),

          "activeOrderId": "",

          "activeOrderStatus":
          "Available",
        },
        SetOptions(merge: true),
      );

      previousRidersEarnings =
          newEarnings.toStringAsFixed(2);

      // -------------------------------------------------------
      // SUCCESS
      // -------------------------------------------------------

      if (!mounted) return;

      setState(() {
        isConfirming = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Order marked as delivered successfully.",
          ),
        ),
      );

      await Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const MySplashScreen(),
        ),
            (route) => false,
      );
    } on FirebaseException catch (error) {
      if (!mounted) return;

      setState(() {
        isConfirming = false;
      });

      _showMessage(
        error.message ??
            "Unable to complete delivery.",
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isConfirming = false;
      });

      _showMessage(
        "Unable to complete delivery. Please try again.",
      );
    }
  }

  // ---------------------------------------------------------
  // SHOW MESSAGE
  // ---------------------------------------------------------

  void _showMessage(
      String message,
      ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // ---------------------------------------------------------
  // INIT
  // ---------------------------------------------------------

  @override
  void initState() {
    super.initState();

    riderUID =
        currentRiderUID ?? "";

    getOrderTotalAmount().then((_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    });

    // -------------------------------------------------------
    // INITIAL LOCATION
    // -------------------------------------------------------

    updateLiveRiderLocation();

    // -------------------------------------------------------
    // LIVE LOCATION EVERY 15 SECONDS
    // -------------------------------------------------------

    _locationTimer =
        Timer.periodic(
          const Duration(
            seconds: 15,
          ),
              (_) {
            updateLiveRiderLocation();
          },
        );
  }

  // ---------------------------------------------------------
  // DISPOSE
  // ---------------------------------------------------------

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------

  @override
  Widget build(
      BuildContext context,
      ) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF1565C0),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Delivery",
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

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            Image.asset(
              "assets/images/confirm2.png",
              height: 240,
            ),

            const SizedBox(height: 15),

            // ------------------------------------------------
            // LIVE LOCATION STATUS
            // ------------------------------------------------

            Container(
              margin:
              const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              padding:
              const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              decoration:
              BoxDecoration(
                color:
                const Color(0xFFE8F5E9),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: Row(
                children: [

                  const Icon(
                    Icons.gps_fixed,
                    color: Colors.green,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      _locationUpdating
                          ? "Updating your live location..."
                          : "Live rider location is active",
                      style:
                      const TextStyle(
                        color: Colors.green,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ------------------------------------------------
            // DROP-OFF LOCATION
            // ------------------------------------------------

            InkWell(
              onTap: () {
                final double? destinationLat =
                double.tryParse(
                  widget.purchaserLat ??
                      "",
                );

                final double? destinationLng =
                double.tryParse(
                  widget.purchaserLng ??
                      "",
                );

                if (position == null ||
                    destinationLat == null ||
                    destinationLng == null) {
                  _showMessage(
                    "Delivery location is not available.",
                  );

                  return;
                }

                MapUtils
                    .launchMapFromSourceToDestination(
                  position!.latitude,
                  position!.longitude,
                  destinationLat,
                  destinationLng,
                );
              },

              child: Container(
                margin:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                padding:
                const EdgeInsets.all(15),

                decoration:
                BoxDecoration(
                  color:
                  const Color(0xFFE3F2FD),
                  borderRadius:
                  BorderRadius.circular(15),
                ),

                child: Row(
                  children: [

                    Image.asset(
                      "assets/images/restaurant.png",
                      width: 50,
                      height: 50,
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Text(
                        "Show Delivery Drop-off Location",
                        style: TextStyle(
                          color:
                          Color(0xFF1565C0),
                          fontSize: 17,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),

                    const Icon(
                      Icons.navigation,
                      color:
                      Color(0xFF1565C0),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ------------------------------------------------
            // ORDER TOTAL
            // ------------------------------------------------

            if (orderTotalAmount.isNotEmpty)
              Text(
                "Order Total: ₹$orderTotalAmount",
                style:
                const TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.bold,
                  color:
                  Colors.black87,
                ),
              ),

            const SizedBox(height: 25),

            // ------------------------------------------------
            // CONFIRM DELIVERY
            // ------------------------------------------------

            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 30,
              ),

              child: SizedBox(
                width: double.infinity,
                height: 55,

                child:
                ElevatedButton.icon(
                  onPressed:
                  isConfirming
                      ? null
                      : confirmParcelHasBeenDelivered,

                  icon: isConfirming
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(
                    Icons.check_circle,
                  ),

                  label: Text(
                    isConfirming
                        ? "Confirming..."
                        : "Order Delivered - Confirm",
                  ),

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF1565C0),
                    foregroundColor:
                    Colors.white,
                    disabledBackgroundColor:
                    Colors.grey,
                    disabledForegroundColor:
                    Colors.white,
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}