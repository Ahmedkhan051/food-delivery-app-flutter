import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:user_app/global/global.dart';
import 'package:user_app/mainScreens/home_screen.dart';

class PlacedOrderScreen extends StatefulWidget {
  final String? addressID;
  final double? totolAmmount;
  final String? sellerUID;

  final String paymentMethod;
  final bool paymentCompleted;

  const PlacedOrderScreen({
    super.key,
    this.addressID,
    this.totolAmmount,
    this.sellerUID,
    this.paymentMethod = "Cash on Delivery",
    this.paymentCompleted = false,
  });

  @override
  State<PlacedOrderScreen> createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color deepBlue = Color(0xFF1565C0);
  static const Color mediumBlue = Color(0xFF42A5F5);
  static const Color backgroundColor = Color(0xFFF8FBFF);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color successGreen = Color(0xFF2E7D32);

  // ============================================================
  // STATE
  // ============================================================

  bool placingOrder = false;
  bool orderPlaced = false;

  String orderId = "";

  List<Map<String, dynamic>> cartItems = [];

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void initState() {
    super.initState();
    loadLocalCart();
  }

  // ============================================================
  // LOAD LOCAL CART
  // ============================================================

  Future<void> loadLocalCart() async {
    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final List<String> savedCart =
          prefs.getStringList("foodHubCartDetails") ?? [];

      final List<Map<String, dynamic>> loadedItems = [];

      for (final String entry in savedCart) {
        try {
          final dynamic decoded = jsonDecode(entry);

          if (decoded is Map) {
            loadedItems.add(
              Map<String, dynamic>.from(decoded),
            );
          }
        } catch (error) {
          debugPrint("Cart decoding error: $error");
        }
      }

      if (!mounted) {
        return;
      }

      setState(() {
        cartItems = loadedItems;
      });
    } catch (error) {
      debugPrint("Unable to load local cart: $error");

      if (!mounted) {
        return;
      }

      setState(() {
        cartItems = [];
      });
    }
  }

  // ============================================================
  // PRODUCT IDS
  // ============================================================

  List<String> get productIds {
    final List<String> ids = [];

    for (final Map<String, dynamic> item in cartItems) {
      final String id = item["itemId"]?.toString().trim() ?? "";

      if (id.isNotEmpty) {
        ids.add(id);
      }
    }

    return ids;
  }

  // ============================================================
  // SELLER UID LIST
  // ============================================================

  Set<String> get cartSellerUIDs {
    final Set<String> sellerUIDs = <String>{};

    for (final Map<String, dynamic> item in cartItems) {
      final String sellerUID =
          item["sellerUID"]?.toString().trim() ?? "";

      if (sellerUID.isNotEmpty) {
        sellerUIDs.add(sellerUID);
      }
    }

    return sellerUIDs;
  }

  // ============================================================
  // CHECK FOR MISSING SELLER UID
  // ============================================================

  bool cartContainsMissingSellerUID() {
    for (final Map<String, dynamic> item in cartItems) {
      final String sellerUID =
          item["sellerUID"]?.toString().trim() ?? "";

      if (sellerUID.isEmpty) {
        return true;
      }
    }

    return false;
  }

  // ============================================================
  // CALCULATE TOTAL
  // ============================================================

  double get calculatedTotal {
    double total = 0.0;

    for (final Map<String, dynamic> item in cartItems) {
      final double price =
          double.tryParse(
            item["price"]?.toString() ?? "0",
          ) ??
              0.0;

      final int quantity =
          int.tryParse(
            item["quantity"]?.toString() ?? "1",
          ) ??
              1;

      total += price * quantity;
    }

    return total;
  }

  // ============================================================
  // CLEAR CART AFTER SUCCESSFUL ORDER
  // ============================================================

  Future<void> clearCartAfterOrder() async {
    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      await prefs.remove("foodHubCartDetails");
      await prefs.remove("userCart");
      await prefs.remove("cartItems");

      if (sharedPreferences != null) {
        await sharedPreferences!.remove("userCart");
      }
    } catch (error) {
      debugPrint("Cart clearing error: $error");
    }
  }

  // ============================================================
  // SHOW TOAST
  // ============================================================

  void showMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  // ============================================================
  // PLACE ORDER
  // ============================================================

  Future<void> placeOrder() async {
    // Prevent double-click / duplicate order.
    if (placingOrder) {
      return;
    }

    // ----------------------------------------------------------
    // CART VALIDATION
    // ----------------------------------------------------------

    if (cartItems.isEmpty) {
      showMessage("Your cart is empty.");
      return;
    }

    // ----------------------------------------------------------
    // PAYMENT VALIDATION
    // ----------------------------------------------------------

    final bool isCashOnDelivery =
        widget.paymentMethod == "Cash on Delivery";

    if (!isCashOnDelivery && !widget.paymentCompleted) {
      showMessage("Please complete payment first.");
      return;
    }

    // ----------------------------------------------------------
    // USER VALIDATION
    // ----------------------------------------------------------

    final String userUID =
        sharedPreferences?.getString("uid")?.trim() ?? "";

    if (userUID.isEmpty) {
      showMessage(
        "User session not found. Please log in again.",
      );
      return;
    }

    // ----------------------------------------------------------
    // CHECKOUT SELLER VALIDATION
    // ----------------------------------------------------------

    final String checkoutSellerUID =
        widget.sellerUID?.trim() ?? "";

    if (checkoutSellerUID.isEmpty) {
      showMessage(
        "Restaurant information is missing. "
            "Please return to the menu and add the food again.",
      );
      return;
    }

    // ----------------------------------------------------------
    // CART SELLER VALIDATION
    // ----------------------------------------------------------

    // Every item must contain sellerUID.
    if (cartContainsMissingSellerUID()) {
      showMessage(
        "Restaurant information is missing for one or more "
            "cart items. Please return to the restaurant menu "
            "and add the food again.",
      );
      return;
    }

    final Set<String> sellerUIDs = cartSellerUIDs;

    // Cart must belong to exactly one restaurant.
    if (sellerUIDs.length > 1) {
      showMessage(
        "Your cart contains items from multiple restaurants. "
            "Please checkout one restaurant at a time.",
      );
      return;
    }

    // Make sure cart restaurant and checkout restaurant match.
    if (!sellerUIDs.contains(checkoutSellerUID)) {
      showMessage(
        "The selected restaurant does not match the cart items. "
            "Please return to the restaurant menu and try again.",
      );
      return;
    }

    // ----------------------------------------------------------
    // VALIDATE TOTAL
    // ----------------------------------------------------------

    final double totalAmount = calculatedTotal;

    if (totalAmount <= 0) {
      showMessage(
        "Invalid order amount. Please return to the cart and try again.",
      );
      return;
    }

    // ----------------------------------------------------------
    // START ORDER PROCESS
    // ----------------------------------------------------------

    if (!mounted) {
      return;
    }

    setState(() {
      placingOrder = true;
    });

    try {
      // --------------------------------------------------------
      // CREATE UNIQUE ORDER ID
      // --------------------------------------------------------

      final String newOrderId =
      DateTime.now().millisecondsSinceEpoch.toString();

      // --------------------------------------------------------
      // SAVE ORDER ID LOCALLY IN STATE
      // --------------------------------------------------------

      orderId = newOrderId;

      // --------------------------------------------------------
      // CREATE ORDER DATA
      // --------------------------------------------------------

      final Map<String, dynamic> orderData = {
        // ======================================================
        // BASIC ORDER INFORMATION
        // ======================================================

        "orderId": newOrderId,

        "addressId": widget.addressID?.trim() ?? "",

        // Keep existing Firestore field name for compatibility.
        "totolAmmount": totalAmount,

        "orderedBy": userUID,

        "productIds": productIds,

        // ======================================================
        // PAYMENT INFORMATION
        // ======================================================

        "paymentDetails": widget.paymentMethod,

        "paymentCompleted":
        isCashOnDelivery ? false : widget.paymentCompleted,

        // ======================================================
        // ORDER TIMING
        // ======================================================

        "orderTime": FieldValue.serverTimestamp(),

        "statusUpdatedAt": FieldValue.serverTimestamp(),

        // ======================================================
        // ORDER SUCCESS
        // ======================================================

        "isSuccess": true,

        // ======================================================
        // RESTAURANT / SELLER
        // ======================================================

        "sellerUID": checkoutSellerUID,

        // ======================================================
        // RIDER INFORMATION
        // ======================================================

        "riderUID": "",
        "riderName": "",

        // ======================================================
        // ORDER STATUS
        // ======================================================

        "status": "Placed",

        // ======================================================
        // RIDER DELIVERY STAGE
        // ======================================================

        "riderStage": "Waiting for Rider",

        // ======================================================
        // RIDER LIVE LOCATION
        // ======================================================

        "riderLat": null,
        "riderLng": null,

        "riderAddress": "",
        "riderLocation": "",

        "riderLocationUpdatedAt": null,

        "riderLocationActive": false,

        // ======================================================
        // RIDER ASSIGNMENT
        // ======================================================

        "riderAssignedAt": null,

        // ======================================================
        // PICKUP / DELIVERY TIMES
        // ======================================================

        "pickedUpAt": null,
        "deliveredAt": null,

        // ======================================================
        // RIDER DELIVERY EARNING
        // ======================================================

        "riderDeliveryAmount": 0.0,
      };

      // --------------------------------------------------------
      // WRITE ORDER TO FIRESTORE
      // --------------------------------------------------------

      bool firestoreSuccess = false;

      try {
        await FirebaseFirestore.instance
            .collection("orders")
            .doc(newOrderId)
            .set(orderData);

        firestoreSuccess = true;
      } on FirebaseException catch (error) {
        debugPrint(
          "Firestore order error: "
              "${error.code} - ${error.message}",
        );
      } catch (error) {
        debugPrint(
          "Firestore order error: $error",
        );
      }

      // --------------------------------------------------------
      // FIRESTORE FAILED
      // --------------------------------------------------------

      if (!firestoreSuccess) {
        if (!mounted) {
          return;
        }

        setState(() {
          placingOrder = false;
          orderId = "";
        });

        showMessage(
          "Unable to place the order. "
              "Please check your internet connection and try again.",
        );

        return;
      }

      // --------------------------------------------------------
      // FIRESTORE SUCCESS
      // --------------------------------------------------------
      //
      // IMPORTANT:
      // Cart is cleared ONLY after the order has successfully
      // been written to Firestore.
      // --------------------------------------------------------

      await clearCartAfterOrder();

      if (!mounted) {
        return;
      }

      setState(() {
        placingOrder = false;
        orderPlaced = true;
      });

      showMessage(
        "Order placed successfully.",
      );
    } catch (error) {
      debugPrint(
        "Place order error: $error",
      );

      if (!mounted) {
        return;
      }

      setState(() {
        placingOrder = false;
      });

      showMessage(
        "Unable to place the order. Please try again.",
      );
    }
  }

  // ============================================================
  // GET FOOD IMAGE
  // ============================================================

  String getFoodImage(String title) {
    final String food = title.trim().toLowerCase();

    // ----------------------------------------------------------
    // PIZZA
    // ----------------------------------------------------------

    if (food.contains("pizza")) {
      if (food.contains("margerite") ||
          food.contains("margherita")) {
        return "assets/images/pizza1.jpeg";
      }

      if (food.contains("cheese")) {
        return "assets/images/pizza2.jpeg";
      }

      if (food.contains("veg")) {
        return "assets/images/pizza5.jpeg";
      }

      if (food.contains("pepper")) {
        return "assets/images/pizza6.jpeg";
      }

      if (food.contains("farm")) {
        return "assets/images/pizza7.jpeg";
      }

      if (food.contains("corn")) {
        return "assets/images/pizza8.jpeg";
      }

      if (food.contains("special")) {
        return "assets/images/pizza9.jpeg";
      }

      if (food.contains("deluxe")) {
        return "assets/images/pizza10.jpeg";
      }

      return "assets/images/piza4.jpeg";
    }

    // ----------------------------------------------------------
    // BURGER
    // ----------------------------------------------------------

    if (food.contains("burger")) {
      if (food.contains("chicken")) {
        return "assets/images/burger1.jpeg";
      }

      if (food.contains("veg")) {
        return "assets/images/burger2.jpeg";
      }

      if (food.contains("cheese")) {
        return "assets/images/burger6.jpeg";
      }

      if (food.contains("special")) {
        return "assets/images/burger4.jpeg";
      }

      return "assets/images/burger.png";
    }

    // ----------------------------------------------------------
    // CAKE
    // ----------------------------------------------------------

    if (food.contains("cake")) {
      if (food.contains("chocolate")) {
        return "assets/images/cake1.jpeg";
      }

      if (food.contains("vanilla")) {
        return "assets/images/cake2.jpeg";
      }

      if (food.contains("red")) {
        return "assets/images/cake3.jpeg";
      }

      if (food.contains("black")) {
        return "assets/images/cake4.jpeg";
      }

      if (food.contains("strawberry")) {
        return "assets/images/cake5.jpeg";
      }

      if (food.contains("fruit")) {
        return "assets/images/cake6.jpeg";
      }

      return "assets/images/cake.jpeg";
    }

    // ----------------------------------------------------------
    // CHOCOLATE
    // ----------------------------------------------------------

    if (food.contains("chocolate") ||
        food.contains("chokolate")) {
      return "assets/images/chocolate.jpeg";
    }

    // ----------------------------------------------------------
    // NON-VEG
    // ----------------------------------------------------------

    if (food.contains("non-veg") ||
        food.contains("non veg") ||
        food.contains("nonveg") ||
        food.contains("chicken") ||
        food.contains("mutton") ||
        food.contains("fish") ||
        food.contains("meat")) {
      if (food.contains("chicken")) {
        return "assets/images/nonveg1.jpeg";
      }

      if (food.contains("fish")) {
        return "assets/images/nonveg3.jpeg";
      }

      if (food.contains("mutton")) {
        return "assets/images/nonveg4.jpeg";
      }

      return "assets/images/non-veg.jpeg";
    }

    // ----------------------------------------------------------
    // VEG
    // ----------------------------------------------------------

    if (food.contains("veg") ||
        food.contains("vegetable") ||
        food.contains("paneer")) {
      if (food.contains("paneer")) {
        return "assets/images/veg2.jpeg";
      }

      if (food.contains("masala")) {
        return "assets/images/veg4.jpeg";
      }

      return "assets/images/veg1.jpeg";
    }

    // ----------------------------------------------------------
    // PASTRY
    // ----------------------------------------------------------

    if (food.contains("pastry") ||
        food.contains("pastries")) {
      if (food.contains("chocolate")) {
        return "assets/images/pastries1.jpeg";
      }

      if (food.contains("special")) {
        return "assets/images/pastries2.jpeg";
      }

      return "assets/images/pastries.jpeg";
    }

    // ----------------------------------------------------------
    // SAMOSA
    // ----------------------------------------------------------

    if (food.contains("samosa")) {
      return "assets/images/samosa.jpeg";
    }

    // ----------------------------------------------------------
    // MOMOS
    // ----------------------------------------------------------

    if (food.contains("momo")) {
      return "assets/images/momos.jpeg";
    }

    // ----------------------------------------------------------
    // SHAKE
    // ----------------------------------------------------------

    if (food.contains("shake") ||
        food.contains("milkshake")) {
      return "assets/images/shake.jpeg";
    }

    // ----------------------------------------------------------
    // GULAB JAMUN
    // ----------------------------------------------------------

    if (food.contains("gulab") ||
        food.contains("jamun")) {
      return "assets/images/gulabjamun.jpeg";
    }

    // ----------------------------------------------------------
    // JALEBI
    // ----------------------------------------------------------

    if (food.contains("jalebi")) {
      return "assets/images/jalebi.jpeg";
    }

    // ----------------------------------------------------------
    // KAJU BARFI
    // ----------------------------------------------------------

    if (food.contains("kaju") ||
        food.contains("barfi")) {
      return "assets/images/kajubarfi.jpeg";
    }

    // ----------------------------------------------------------
    // LADDOO
    // ----------------------------------------------------------

    if (food.contains("laddu") ||
        food.contains("laddoo")) {
      return "assets/images/laddoo.jpeg";
    }

    // ----------------------------------------------------------
    // SOFT DRINK
    // ----------------------------------------------------------

    if (food.contains("softdrink") ||
        food.contains("soft drink") ||
        food.contains("cold drink") ||
        food.contains("drink")) {
      return "assets/images/softdrink.jpeg";
    }

    // ----------------------------------------------------------
    // FRUIT
    // ----------------------------------------------------------

    if (food.contains("fruit")) {
      return "assets/images/fruit.png";
    }

    // ----------------------------------------------------------
    // DINING
    // ----------------------------------------------------------

    if (food.contains("dining")) {
      return "assets/images/diningfood.jpeg";
    }

    // ----------------------------------------------------------
    // DISCOUNT
    // ----------------------------------------------------------

    if (food.contains("discount")) {
      return "assets/images/discountfood.jpeg";
    }

    // ----------------------------------------------------------
    // DELIVERY
    // ----------------------------------------------------------

    if (food.contains("delivery")) {
      return "assets/images/deliveryfood.jpeg";
    }

    // ----------------------------------------------------------
    // DEFAULT
    // ----------------------------------------------------------

    return "assets/images/homefood.jpeg";
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (orderPlaced) {
      return _successScreen();
    }

    return Scaffold(
      backgroundColor: backgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: mediumBlue,
        elevation: 3,

        leading: IconButton(
          onPressed: () {
            if (placingOrder) {
              return;
            }

            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),

        title: const Text(
          "Confirm Order",
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: cartItems.isEmpty
          ? const Center(
        child: Text(
          "No items available.",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      )
          : Column(
        children: [
          // ==================================================
          // ORDER CONTENT
          // ==================================================

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.all(16),

              children: [
                // ==========================================
                // PAYMENT METHOD
                // ==========================================

                _paymentMethodCard(),

                const SizedBox(height: 18),

                // ==========================================
                // ORDER SUMMARY TITLE
                // ==========================================

                const Text(
                  "Order Summary",
                  style: TextStyle(
                    color: deepBlue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // ==========================================
                // ORDER ITEMS
                // ==========================================

                ...cartItems.map(
                  _orderItemCard,
                ),

                const SizedBox(height: 12),

                // ==========================================
                // TOTAL AMOUNT
                // ==========================================

                _totalAmountCard(),
              ],
            ),
          ),

          // ==================================================
          // CONFIRM BUTTON
          // ==================================================

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                12,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed:
                  placingOrder ? null : placeOrder,

                  icon: placingOrder
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(
                    Icons.check_circle,
                  ),

                  label: Text(
                    placingOrder
                        ? "PLACING ORDER..."
                        : "CONFIRM & PLACE ORDER",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepBlue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    disabledForegroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PAYMENT METHOD CARD
  // ============================================================

  Widget _paymentMethodCard() {
    final bool isCashOnDelivery =
        widget.paymentMethod == "Cash on Delivery";

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(
        children: [
          // ------------------------------------------------------
          // PAYMENT ICON
          // ------------------------------------------------------

          Icon(
            isCashOnDelivery
                ? Icons.payments_outlined
                : Icons.check_circle,
            color: deepBlue,
            size: 30,
          ),

          const SizedBox(width: 12),

          // ------------------------------------------------------
          // PAYMENT DETAILS
          // ------------------------------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  "Payment Method",
                  style: TextStyle(
                    color: deepBlue,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  widget.paymentMethod,
                  style: const TextStyle(
                    color: deepBlue,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ------------------------------------------------------
          // PAYMENT VERIFIED ICON
          // ------------------------------------------------------

          if (!isCashOnDelivery)
            const Icon(
              Icons.verified,
              color: successGreen,
              size: 28,
            ),
        ],
      ),
    );
  }

  // ============================================================
  // TOTAL AMOUNT CARD
  // ============================================================

  Widget _totalAmountCard() {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Total Amount",
              style: TextStyle(
                color: deepBlue,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Text(
            "₹${calculatedTotal.toStringAsFixed(2)}",
            style: const TextStyle(
              color: deepBlue,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ORDER ITEM CARD
  // ============================================================

  Widget _orderItemCard(
      Map<String, dynamic> item,
      ) {
    final String title =
    item["title"]?.toString().trim().isNotEmpty == true
        ? item["title"].toString().trim()
        : "Food Item";

    final double price =
        double.tryParse(
          item["price"]?.toString() ?? "0",
        ) ??
            0.0;

    final int quantity =
        int.tryParse(
          item["quantity"]?.toString() ?? "1",
        ) ??
            1;

    final double itemTotal = price * quantity;

    final String imagePath = getFoodImage(title);

    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [
          // ======================================================
          // FOOD IMAGE
          // ======================================================

          ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: SizedBox(
              width: 78,
              height: 78,

              child: Image.asset(
                imagePath,

                width: 78,
                height: 78,

                fit: BoxFit.cover,

                errorBuilder: (
                    context,
                    error,
                    stackTrace,
                    ) {
                  return Container(
                    color: lightBlue,

                    child: const Icon(
                      Icons.fastfood,
                      color: deepBlue,
                      size: 35,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ======================================================
          // FOOD DETAILS
          // ======================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,

                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: deepBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "₹${price.toStringAsFixed(2)} × $quantity",

                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "₹${itemTotal.toStringAsFixed(2)}",

                  style: const TextStyle(
                    color: mediumBlue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUCCESS SCREEN
  // ============================================================

  Widget _successScreen() {
    final bool isCashOnDelivery =
        widget.paymentMethod == "Cash on Delivery";

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),

            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [
                // ==================================================
                // SUCCESS ICON
                // ==================================================

                Container(
                  width: 100,
                  height: 100,

                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.check_circle,
                    color: successGreen,
                    size: 75,
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // TITLE
                // ==================================================

                const Text(
                  "Order Placed!",
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: deepBlue,
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // DESCRIPTION
                // ==================================================

                Text(
                  isCashOnDelivery
                      ? "Your order has been placed successfully."
                      : "Payment received and your order has been "
                      "placed successfully.",

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 12),

                // ==================================================
                // PAYMENT
                // ==================================================

                Text(
                  "Payment: ${widget.paymentMethod}",

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: deepBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                // ==================================================
                // ORDER ID
                // ==================================================

                SelectableText(
                  "Order ID: $orderId",

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 30),

                // ==================================================
                // HOME BUTTON
                // ==================================================

                SizedBox(
                  width: double.infinity,
                  height: 54,

                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,

                        MaterialPageRoute(
                          builder: (context) =>
                          const HomeScreen(),
                        ),

                            (route) => false,
                      );
                    },

                    icon: const Icon(
                      Icons.home,
                    ),

                    label: const Text(
                      "GO TO HOME",

                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: deepBlue,
                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}