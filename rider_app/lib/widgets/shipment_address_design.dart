import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:rider_app/assistant_methods/get_current_location.dart';
import 'package:rider_app/global/global.dart';
import 'package:rider_app/mainScreens/parcel_picking_screen.dart';
import 'package:rider_app/models/address.dart';

class ShipmentAddressDesign extends StatelessWidget {
  final Address? model;
  final String? orderStatus;
  final String? sellerId;
  final String? orderByUser;
  final String? orderId;

  const ShipmentAddressDesign({
    super.key,
    this.model,
    this.orderStatus,
    this.orderId,
    this.sellerId,
    this.orderByUser,
  });

  // =========================================================
  // GET CURRENT RIDER UID
  // =========================================================

  String? get riderUID {
    final firebaseUID = firebaseAuth.currentUser?.uid;

    if (firebaseUID != null && firebaseUID.trim().isNotEmpty) {
      return firebaseUID.trim();
    }

    final savedUID = sharedPreferences?.getString("uid");

    if (savedUID != null && savedUID.trim().isNotEmpty) {
      return savedUID.trim();
    }

    return null;
  }

  // =========================================================
  // GET CURRENT RIDER NAME
  // =========================================================

  String get riderName {
    final savedName = sharedPreferences?.getString("name");

    if (savedName != null && savedName.trim().isNotEmpty) {
      return savedName.trim();
    }

    final firebaseName = firebaseAuth.currentUser?.displayName;

    if (firebaseName != null && firebaseName.trim().isNotEmpty) {
      return firebaseName.trim();
    }

    return "Rider";
  }

  // =========================================================
  // CONFIRM / ASSIGN SHIPMENT
  // =========================================================

  Future<void> confirmParcelShipment(
      BuildContext context,
      String getOrderId,
      String sellerUID,
      String purchaserUID,
      ) async {
    // ---------------------------------------------------------
    // GET CURRENT RIDER
    // ---------------------------------------------------------

    final String? currentRiderUID = riderUID;

    if (currentRiderUID == null || currentRiderUID.isEmpty) {
      if (!context.mounted) return;

      _showMessage(
        context,
        "Rider account not found. Please login again.",
      );

      return;
    }

    // ---------------------------------------------------------
    // CHECK RIDER LOCATION
    // ---------------------------------------------------------

    if (position == null) {
      if (!context.mounted) return;

      _showMessage(
        context,
        "Please get your current location first.",
      );

      return;
    }

    try {
      // =======================================================
      // ORDER REFERENCE
      // =======================================================

      final DocumentReference<Map<String, dynamic>> orderReference =
      FirebaseFirestore.instance
          .collection("orders")
          .doc(getOrderId);

      // =======================================================
      // GET LATEST ORDER FROM FIRESTORE
      // =======================================================

      final DocumentSnapshot<Map<String, dynamic>> orderSnapshot =
      await orderReference.get();

      if (!context.mounted) return;

      if (!orderSnapshot.exists) {
        _showMessage(
          context,
          "Order not found.",
        );

        return;
      }

      final Map<String, dynamic> orderData =
          orderSnapshot.data() ?? <String, dynamic>{};

      // =======================================================
      // CHECK WHETHER ORDER IS ALREADY ASSIGNED
      // =======================================================

      final String assignedRider =
          orderData["riderUID"]?.toString().trim() ?? "";

      if (assignedRider.isNotEmpty &&
          assignedRider != currentRiderUID) {
        _showMessage(
          context,
          "This order is assigned to another rider.",
        );

        return;
      }

      // =======================================================
      // GET CURRENT ORDER STATUS
      // =======================================================

      final String currentStatus =
          orderData["status"]?.toString().trim() ?? "";

      final String normalizedStatus =
      currentStatus.toLowerCase();

      // =======================================================
      // PREVENT ACCEPTING DELIVERED ORDER
      // =======================================================

      if (normalizedStatus == "delivered") {
        _showMessage(
          context,
          "This order has already been delivered.",
        );

        return;
      }

      // =======================================================
      // GET RIDER CURRENT LOCATION
      // =======================================================

      final double currentLat = position!.latitude;
      final double currentLng = position!.longitude;

      // =======================================================
      // ASSIGN ORDER TO RIDER
      //
      // IMPORTANT:
      // Do NOT change restaurant order status here.
      //
      // Example:
      // Packed -> remains Packed
      // Preparing -> remains Preparing
      // Confirmed -> remains Confirmed
      // =======================================================

      await orderReference.update({
        "riderUID": currentRiderUID,
        "riderName": riderName,

        // Keep existing restaurant status.
        "status": currentStatus,

        // Rider current location.
        "riderLat": currentLat,
        "riderLng": currentLng,

        "riderAddress": completeAddress,

        "riderLocation": {
          "lat": currentLat,
          "lng": currentLng,
        },

        // Location tracking is active.
        "riderLocationActive": true,

        // Rider workflow stage.
        "riderStage": "Assigned",

        // Timestamps.
        "riderAssignedAt": FieldValue.serverTimestamp(),
        "riderLocationUpdatedAt": FieldValue.serverTimestamp(),
        "statusUpdatedAt": FieldValue.serverTimestamp(),
      });

      // =======================================================
      // UPDATE USER'S ORDER COPY
      // =======================================================

      if (purchaserUID.trim().isNotEmpty) {
        try {
          final DocumentReference<Map<String, dynamic>> userOrderReference =
          FirebaseFirestore.instance
              .collection("users")
              .doc(purchaserUID)
              .collection("orders")
              .doc(getOrderId);

          await userOrderReference.update({
            "riderUID": currentRiderUID,
            "riderName": riderName,

            // Keep the same restaurant status.
            "status": currentStatus,

            // Rider current location.
            "riderLat": currentLat,
            "riderLng": currentLng,

            "riderAddress": completeAddress,

            "riderLocation": {
              "lat": currentLat,
              "lng": currentLng,
            },

            "riderLocationActive": true,

            "riderStage": "Assigned",

            "statusUpdatedAt": FieldValue.serverTimestamp(),
          });
        } catch (_) {
          // ---------------------------------------------------
          // IMPORTANT:
          // Main orders document has already been updated.
          // Therefore, failure of the user's order copy
          // should not cancel the rider assignment.
          // ---------------------------------------------------
        }
      }

      // =======================================================
      // MAKE SURE WIDGET IS STILL MOUNTED
      // =======================================================

      if (!context.mounted) return;

      // =======================================================
      // OPEN PARCEL PICKING SCREEN
      // =======================================================

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ParcelPickingScreen(
            purchaserId: purchaserUID,

            purchaserAddress: model?.fullAddress ?? "",

            purchaserLat: model?.lat ?? "",

            purchaserLng: model?.lng ?? "",

            sellerId: sellerUID,

            getOrderId: getOrderId,
          ),
        ),
      );
    } on FirebaseException catch (error) {
      if (!context.mounted) return;

      _showMessage(
        context,
        error.message ?? "Unable to assign this order.",
      );
    } catch (error) {
      if (!context.mounted) return;

      _showMessage(
        context,
        "Unable to confirm this order. Please try again.",
      );
    }
  }

  // =========================================================
  // SHOW SNACKBAR MESSAGE
  // =========================================================

  void _showMessage(
      BuildContext context,
      String message,
      ) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    // ---------------------------------------------------------
    // NO ADDRESS
    // ---------------------------------------------------------

    if (model == null) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "Shipping address is not available.",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // ---------------------------------------------------------
    // NORMALIZE STATUS
    // ---------------------------------------------------------

    final String normalizedOrderStatus =
        orderStatus?.trim().toLowerCase() ?? "";

    // ---------------------------------------------------------
    // DELIVERED CHECK
    // ---------------------------------------------------------

    final bool isDelivered =
        normalizedOrderStatus == "delivered";

    // ---------------------------------------------------------
    // ACCEPTABLE RESTAURANT STATUSES
    //
    // Rider can accept the order when restaurant has:
    // Confirmed
    // Preparing
    // Packed
    // ---------------------------------------------------------

    final bool canAcceptOrder =
        normalizedOrderStatus == "confirmed" ||
            normalizedOrderStatus == "preparing" ||
            normalizedOrderStatus == "packed";

    // ---------------------------------------------------------
    // CHECK REQUIRED ORDER DETAILS
    // ---------------------------------------------------------

    final bool hasOrderDetails =
        orderId != null &&
            orderId!.trim().isNotEmpty &&
            sellerId != null &&
            sellerId!.trim().isNotEmpty &&
            orderByUser != null &&
            orderByUser!.trim().isNotEmpty;

    // =========================================================
    // MAIN CONTAINER
    // =========================================================

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===================================================
          // TITLE
          // ===================================================

          const Text(
            "Shipping Details",
            style: TextStyle(
              color: Color(0xFF1565C0),
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          // ===================================================
          // CUSTOMER NAME
          // ===================================================

          _addressRow(
            Icons.person_outline,
            "Name",
            model!.name ?? "Not available",
          ),

          const SizedBox(height: 10),

          // ===================================================
          // PHONE
          // ===================================================

          _addressRow(
            Icons.phone_outlined,
            "Phone",
            model!.phoneNumber ?? "Not available",
          ),

          const SizedBox(height: 15),

          const Divider(),

          const SizedBox(height: 10),

          // ===================================================
          // CUSTOMER ADDRESS
          // ===================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Color(0xFF1565C0),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  model!.fullAddress ?? "Address not available",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ===================================================
          // DELIVERED MESSAGE
          // ===================================================

          if (isDelivered)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      "This order has been delivered.",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )

          // ===================================================
          // ACCEPT ORDER BUTTON
          // ===================================================

          else if (hasOrderDetails && canAcceptOrder)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () async {
                  // ------------------------------------------------
                  // GET FRESH RIDER LOCATION
                  // ------------------------------------------------

                  final UserLocation location = UserLocation();

                  final bool success =
                  await location.getCurrentLocation();

                  if (!context.mounted) {
                    return;
                  }

                  // ------------------------------------------------
                  // CHECK LOCATION RESULT
                  // ------------------------------------------------

                  if (!success || position == null) {
                    _showMessage(
                      context,
                      "Unable to get your current location.",
                    );

                    return;
                  }

                  // ------------------------------------------------
                  // CONFIRM ORDER ASSIGNMENT
                  // ------------------------------------------------

                  await confirmParcelShipment(
                    context,
                    orderId!,
                    sellerId!,
                    orderByUser!,
                  );
                },

                icon: const Icon(
                  Icons.local_shipping,
                ),

                label: const Text(
                  "Confirm - Deliver This Parcel",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,

                  elevation: 2,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 10),

          // ===================================================
          // GO BACK BUTTON
          // ===================================================

          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },

              icon: const Icon(
                Icons.arrow_back,
              ),

              label: const Text(
                "Go Back",
              ),

              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1565C0),

                side: const BorderSide(
                  color: Color(0xFF1565C0),
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // ADDRESS ROW
  // =========================================================

  Widget _addressRow(
      IconData icon,
      String label,
      String value,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFF1565C0),
        ),

        const SizedBox(width: 10),

        SizedBox(
          width: 100,
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
    );
  }
}