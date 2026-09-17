import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:rider_app/assistant_methods/get_current_location.dart';
import 'package:rider_app/global/global.dart';
import 'package:rider_app/maps/map_utils.dart';
import 'package:rider_app/mainScreens/parcel_delivering_screen.dart';

class ParcelPickingScreen extends StatefulWidget {
  final String? purchaserId;
  final String? sellerId;
  final String? getOrderId;
  final String? purchaserAddress;
  final String? purchaserLat;
  final String? purchaserLng;

  const ParcelPickingScreen({
    super.key,
    this.purchaserId,
    this.sellerId,
    this.getOrderId,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
  });

  @override
  State<ParcelPickingScreen> createState() =>
      _ParcelPickingScreenState();
}

class _ParcelPickingScreenState
    extends State<ParcelPickingScreen> {
  double? sellerLat;
  double? sellerLng;

  bool isLoading = false;

  // ---------------------------------------------------------
  // LIVE LOCATION VARIABLES
  // ---------------------------------------------------------

  Timer? _locationTimer;
  bool _locationUpdating = false;

  // ---------------------------------------------------------
  // GET RIDER UID
  // ---------------------------------------------------------

  String? get riderUID {
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
  // GET SELLER LOCATION
  // ---------------------------------------------------------

  Future<void> getSellerData() async {
    try {
      if (widget.sellerId == null ||
          widget.sellerId!.isEmpty) {
        return;
      }

      final DocumentSnapshot<Map<String, dynamic>>
      snapshot =
      await FirebaseFirestore.instance
          .collection("sellers")
          .doc(widget.sellerId)
          .get();

      if (!snapshot.exists) {
        return;
      }

      final Map<String, dynamic> data =
          snapshot.data() ?? {};

      sellerLat = _toDouble(data["lat"]);
      sellerLng = _toDouble(data["lng"]);

      if (!mounted) return;

      setState(() {});
    } catch (_) {
      // Keep default null values.
    }
  }

  // ---------------------------------------------------------
  // SAFE DOUBLE CONVERSION
  // ---------------------------------------------------------

  double? _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value != null) {
      return double.tryParse(
        value.toString(),
      );
    }

    return null;
  }

  // ---------------------------------------------------------
  // UPDATE LIVE RIDER LOCATION
  // ---------------------------------------------------------

  Future<void> updateLiveRiderLocation() async {
    if (_locationUpdating) return;

    final String? riderId = riderUID;
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

          "locationUpdatedAt":
          FieldValue.serverTimestamp(),

          "updatedAt":
          FieldValue.serverTimestamp(),

          "activeOrderId": orderId,

          "activeOrderStatus": "Picking Up",

        },
        SetOptions(merge: true),
      );

      // -------------------------------------------------------
      // UPDATE SHARED ORDER
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

          "riderAddress": completeAddress,

          "riderLocation": {
            "lat": currentLat,
            "lng": currentLng,
          },

          "riderLocationUpdatedAt":
          FieldValue.serverTimestamp(),

          "riderLocationActive": true,

          "riderStage": "Picking Up",

          "statusUpdatedAt":
          FieldValue.serverTimestamp(),
        },
      );
    } catch (_) {
      // Temporary GPS/network failure should not
      // interrupt the pickup screen.
    } finally {
      _locationUpdating = false;
    }
  }

  // ---------------------------------------------------------
  // CONFIRM PARCEL PICKED
  // ---------------------------------------------------------

  Future<void>
  confirmParcelHasBeenPicked() async {
    if (isLoading) return;

    if (widget.getOrderId == null ||
        widget.getOrderId!.isEmpty) {
      _showMessage(
        "Invalid order.",
      );
      return;
    }

    final String? currentRiderUID =
        riderUID;

    if (currentRiderUID == null ||
        currentRiderUID.isEmpty) {
      _showMessage(
        "Rider account not found.",
      );
      return;
    }

    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      // -------------------------------------------------------
      // GET LATEST RIDER LOCATION
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
          isLoading = false;
        });

        _showMessage(
          "Unable to get your current location.",
        );

        return;
      }

      final double currentLat =
          position!.latitude;

      final double currentLng =
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
          isLoading = false;
        });

        _showMessage(
          "Order not found.",
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
          assignedRider != currentRiderUID) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        _showMessage(
          "This order is assigned to another rider.",
        );

        return;
      }

      // -------------------------------------------------------
      // PREVENT COMPLETING DELIVERED ORDER
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
          isLoading = false;
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
          "status": "Out for Delivery",

          "riderUID":
          currentRiderUID,

          "riderName":
          riderName,

          // Current rider position.
          "riderLat":
          currentLat,

          "riderLng":
          currentLng,

          "riderAddress":
          completeAddress,

          "riderLocation": {
            "lat": currentLat,
            "lng": currentLng,
          },

          "riderLocationUpdatedAt":
          FieldValue.serverTimestamp(),

          "riderLocationActive":
          true,

          "riderStage":
          "Out for Delivery",

          "address":
          completeAddress,

          "lat":
          currentLat,

          "lng":
          currentLng,

          "pickedUpAt":
          FieldValue.serverTimestamp(),

          "statusUpdatedAt":
          FieldValue.serverTimestamp(),
        },
      );

      // -------------------------------------------------------
      // UPDATE USER ORDER COPY
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
              "status":
              "Out for Delivery",

              "riderUID":
              currentRiderUID,

              "riderName":
              riderName,

              "riderLat":
              currentLat,

              "riderLng":
              currentLng,

              "riderAddress":
              completeAddress,

              "riderLocation": {
                "lat": currentLat,
                "lng": currentLng,
              },

              "riderLocationActive":
              true,

              "riderStage":
              "Out for Delivery",

              "statusUpdatedAt":
              FieldValue.serverTimestamp(),
            },
          );
        } catch (_) {
          // Main order remains the source of truth.
        }
      }

      // -------------------------------------------------------
      // UPDATE RIDER DOCUMENT
      // -------------------------------------------------------

      await FirebaseFirestore.instance
          .collection("riders")
          .doc(currentRiderUID)
          .set(
        {
          "lat": currentLat,
          "lng": currentLng,

          "location": {
            "lat": currentLat,
            "lng": currentLng,
          },

          "locationUpdatedAt":
          FieldValue.serverTimestamp(),

          "updatedAt":
          FieldValue.serverTimestamp(),

          "activeOrderId":
          widget.getOrderId,

          "activeOrderStatus":
          "Out for Delivery",

        },
        SetOptions(merge: true),
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      // -------------------------------------------------------
      // MOVE TO DELIVERY SCREEN
      // -------------------------------------------------------

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ParcelDeliveringScreen(
                purchaserId:
                purchaserId.isNotEmpty
                    ? purchaserId
                    : widget.purchaserId,

                purchaserAddress:
                widget.purchaserAddress,

                purchaserLat:
                widget.purchaserLat,

                purchaserLng:
                widget.purchaserLng,

                sellerId:
                widget.sellerId,

                getOrderId:
                widget.getOrderId,
              ),
        ),
      );
    } on FirebaseException catch (error) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showMessage(
        error.message ??
            "Unable to confirm pickup.",
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showMessage(
        "Unable to confirm pickup. Please try again.",
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

    getSellerData();

    // -------------------------------------------------------
    // INITIAL RIDER LOCATION
    // -------------------------------------------------------

    updateLiveRiderLocation();

    // -------------------------------------------------------
    // UPDATE LOCATION EVERY 15 SECONDS
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pick Up Order",
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

            const SizedBox(height: 25),

            Image.asset(
              "assets/images/confirm1.png",
              width: 350,
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
              decoration: BoxDecoration(
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
            // SELLER LOCATION
            // ------------------------------------------------

            InkWell(
              onTap: () {
                if (position == null ||
                    sellerLat == null ||
                    sellerLng == null) {
                  _showMessage(
                    "Location is not available yet.",
                  );
                  return;
                }

                MapUtils
                    .launchMapFromSourceToDestination(
                  position!.latitude,
                  position!.longitude,
                  sellerLat,
                  sellerLng,
                );
              },

              child: Container(
                margin:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                padding:
                const EdgeInsets.all(15),

                decoration: BoxDecoration(
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
                        "Show Restaurant Location",
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

            const SizedBox(height: 25),

            // ------------------------------------------------
            // PICKUP CONFIRM BUTTON
            // ------------------------------------------------

            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 30,
              ),

              child: SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(
                  onPressed:
                  isLoading
                      ? null
                      : confirmParcelHasBeenPicked,

                  icon: isLoading
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
                    isLoading
                        ? "Confirming..."
                        : "Order Picked - Confirm",
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