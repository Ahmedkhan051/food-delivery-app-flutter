import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:user_app/models/items.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Items? model;

  const ItemDetailsScreen({
    super.key,
    this.model,
  });

  @override
  State<ItemDetailsScreen> createState() =>
      _ItemDetailsScreenState();
}

class _ItemDetailsScreenState
    extends State<ItemDetailsScreen> {
  static const Color deepBlue =
  Color(0xFF1565C0);

  static const Color mediumBlue =
  Color(0xFF42A5F5);

  static const Color lightBlue =
  Color(0xFFE3F2FD);

  int quantity = 1;
  bool adding = false;

  // ---------------------------------------------------------
  // GET LOCAL FOOD IMAGE
  // ---------------------------------------------------------

  String getFoodImage(String title) {
    final String food =
    title.trim().toLowerCase();

    // -------------------------------------------------------
    // PIZZA
    // -------------------------------------------------------

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

    // -------------------------------------------------------
    // BURGER
    // -------------------------------------------------------

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

    // -------------------------------------------------------
    // CAKE
    // -------------------------------------------------------

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

    // -------------------------------------------------------
    // CHOCOLATE
    // -------------------------------------------------------

    if (food.contains("chocolate") ||
        food.contains("chokolate")) {
      return "assets/images/chocolate.jpeg";
    }

    // -------------------------------------------------------
    // NON-VEG
    // -------------------------------------------------------

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

      if (food.contains("special")) {
        return "assets/images/nonveg5.jpeg";
      }

      return "assets/images/non-veg.jpeg";
    }

    // -------------------------------------------------------
    // VEG
    // -------------------------------------------------------

    if (food.contains("veg") ||
        food.contains("vegetable") ||
        food.contains("paneer")) {
      if (food.contains("paneer")) {
        return "assets/images/veg2.jpeg";
      }

      if (food.contains("special")) {
        return "assets/images/veg3.jpeg";
      }

      if (food.contains("masala")) {
        return "assets/images/veg4.jpeg";
      }

      return "assets/images/veg1.jpeg";
    }

    // -------------------------------------------------------
    // PASTRIES
    // -------------------------------------------------------

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

    // -------------------------------------------------------
    // SAMOSA
    // -------------------------------------------------------

    if (food.contains("samosa")) {
      return "assets/images/samosa.jpeg";
    }

    // -------------------------------------------------------
    // MOMOS
    // -------------------------------------------------------

    if (food.contains("momo")) {
      return "assets/images/momos.jpeg";
    }

    // -------------------------------------------------------
    // SHAKE
    // -------------------------------------------------------

    if (food.contains("shake") ||
        food.contains("milkshake")) {
      return "assets/images/shake.jpeg";
    }

    // -------------------------------------------------------
    // GULAB JAMUN
    // -------------------------------------------------------

    if (food.contains("gulab") ||
        food.contains("jamun")) {
      return "assets/images/gulabjamun.jpeg";
    }

    // -------------------------------------------------------
    // JALEBI
    // -------------------------------------------------------

    if (food.contains("jalebi")) {
      return "assets/images/jalebi.jpeg";
    }

    // -------------------------------------------------------
    // KAJU BARFI
    // -------------------------------------------------------

    if (food.contains("kaju") ||
        food.contains("barfi")) {
      return "assets/images/kajubarfi.jpeg";
    }

    // -------------------------------------------------------
    // LADDOO
    // -------------------------------------------------------

    if (food.contains("laddu") ||
        food.contains("laddoo")) {
      return "assets/images/laddoo.jpeg";
    }

    // -------------------------------------------------------
    // SOFT DRINK
    // -------------------------------------------------------

    if (food.contains("softdrink") ||
        food.contains("soft drink") ||
        food.contains("cold drink") ||
        food.contains("drink")) {
      return "assets/images/softdrink.jpeg";
    }

    // -------------------------------------------------------
    // FRUIT
    // -------------------------------------------------------

    if (food.contains("fruit")) {
      return "assets/images/fruit.png";
    }

    // -------------------------------------------------------
    // DINING
    // -------------------------------------------------------

    if (food.contains("dining")) {
      return "assets/images/diningfood.jpeg";
    }

    // -------------------------------------------------------
    // DISCOUNT
    // -------------------------------------------------------

    if (food.contains("discount")) {
      return "assets/images/discountfood.jpeg";
    }

    // -------------------------------------------------------
    // DELIVERY
    // -------------------------------------------------------

    if (food.contains("delivery")) {
      return "assets/images/deliveryfood.jpeg";
    }

    // -------------------------------------------------------
    // DEFAULT
    // -------------------------------------------------------

    return "assets/images/homefood.jpeg";
  }

  // ---------------------------------------------------------
  // CREATE UNIQUE CART ID
  // ---------------------------------------------------------

  String get localCartId {
    final Items? item =
        widget.model;

    if (item == null) {
      return "";
    }

    final String sellerId =
        item.sellerUID?.toString() ?? "";

    final String itemId =
        item.itemId?.toString() ?? "";

    return "$sellerId|$itemId";
  }

  // ---------------------------------------------------------
  // ADD TO CART
  // ---------------------------------------------------------

  Future<void> addToCart() async {
    final Items? model =
        widget.model;

    if (model == null) {
      Fluttertoast.showToast(
        msg: "Food item not found.",
      );
      return;
    }

    if (localCartId.isEmpty) {
      Fluttertoast.showToast(
        msg: "Food item ID is missing.",
      );
      return;
    }

    if (adding) {
      return;
    }

    setState(() {
      adding = true;
    });

    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final List<String> savedItems =
          prefs.getStringList(
            "foodHubCartDetails",
          ) ??
              [];

      int existingIndex = -1;

      // -----------------------------------------------------
      // FIND EXISTING PRODUCT
      // -----------------------------------------------------

      for (int i = 0;
      i < savedItems.length;
      i++) {
        try {
          final dynamic decoded =
          jsonDecode(
            savedItems[i],
          );

          if (decoded is! Map) {
            continue;
          }

          final Map<String, dynamic>
          oldItem =
          Map<String, dynamic>.from(
            decoded,
          );

          final String oldCartId =
              oldItem["localCartId"]
                  ?.toString() ??
                  "";

          if (oldCartId ==
              localCartId) {
            existingIndex = i;
            break;
          }
        } catch (error) {
          debugPrint(
            "Invalid cart item: $error",
          );
        }
      }

      // -----------------------------------------------------
      // SAME ITEM
      // -----------------------------------------------------

      if (existingIndex >= 0) {
        final Map<String, dynamic>
        existingItem =
        Map<String, dynamic>.from(
          jsonDecode(
            savedItems[existingIndex],
          ),
        );

        final int oldQuantity =
            int.tryParse(
              existingItem["quantity"]
                  ?.toString() ??
                  "1",
            ) ??
                1;

        existingItem["quantity"] =
            oldQuantity + quantity;

        savedItems[existingIndex] =
            jsonEncode(existingItem);

        await prefs.setStringList(
          "foodHubCartDetails",
          savedItems,
        );

        await _syncUserCart(
          prefs,
          savedItems,
        );

        if (!mounted) {
          return;
        }

        setState(() {
          adding = false;
        });

        Fluttertoast.showToast(
          msg:
          "${existingItem["title"]} quantity increased.",
        );

        return;
      }

      // -----------------------------------------------------
      // NEW ITEM
      // -----------------------------------------------------

      final Map<String, dynamic> newItem = {
        "localCartId":
        localCartId,

        "itemId":
        model.itemId?.toString() ??
            "",

        "title":
        model.title?.toString() ??
            "Food Item",

        "price":
        model.price ?? 0,

        "thumbnailUrl":
        model.thumbnailUrl
            ?.toString() ??
            "",

        "longDescription":
        model.longDescription
            ?.toString() ??
            "",

        "sellerUID":
        model.sellerUID
            ?.toString() ??
            "",

        "quantity":
        quantity,
      };

      savedItems.add(
        jsonEncode(newItem),
      );

      await prefs.setStringList(
        "foodHubCartDetails",
        savedItems,
      );

      await _syncUserCart(
        prefs,
        savedItems,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        adding = false;
      });

      Fluttertoast.showToast(
        msg: "Added to cart.",
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        adding = false;
      });

      debugPrint(
        "Add to cart error: $error",
      );

      Fluttertoast.showToast(
        msg: "Could not add item to cart.",
      );
    }
  }

  // ---------------------------------------------------------
  // SYNC USER CART
  // ---------------------------------------------------------

  Future<void> _syncUserCart(
      SharedPreferences prefs,
      List<String> savedItems,
      ) async {
    final List<String> userCart = [];

    for (final String entry
    in savedItems) {
      try {
        final Map<String, dynamic>
        item =
        Map<String, dynamic>.from(
          jsonDecode(entry),
        );

        final String id =
            item["localCartId"]
                ?.toString() ??
                "";

        final int itemQuantity =
            int.tryParse(
              item["quantity"]
                  ?.toString() ??
                  "1",
            ) ??
                1;

        if (id.isNotEmpty &&
            itemQuantity > 0) {
          userCart.add(
            "$id:$itemQuantity",
          );
        }
      } catch (_) {}
    }

    if (userCart.isEmpty) {
      userCart.add(
        "garbageValue",
      );
    }

    await prefs.setStringList(
      "userCart",
      userCart,
    );
  }

  // ---------------------------------------------------------
  // INCREASE
  // ---------------------------------------------------------

  void increaseQuantity() {
    if (quantity < 99) {
      setState(() {
        quantity++;
      });
    }
  }

  // ---------------------------------------------------------
  // DECREASE
  // ---------------------------------------------------------

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------

  @override
  Widget build(
      BuildContext context,
      ) {
    final Items? model =
        widget.model;

    if (model == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor:
          mediumBlue,
          foregroundColor:
          Colors.white,
          title: const Text(
            "Food Details",
          ),
        ),
        body:
        const Center(
          child: Text(
            "Food item not available.",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      );
    }

    final String title =
        model.title?.toString() ??
            "Food Item";

    final String description =
        model.longDescription
            ?.toString() ??
            "Delicious food from FoodHub.";

    final String price =
        model.price?.toString() ??
            "0";

    final String localImagePath =
    getFoodImage(title);

    return Scaffold(
      backgroundColor:
      const Color(
        0xFFF8FBFF,
      ),

      appBar: AppBar(
        backgroundColor:
        mediumBlue,
        elevation: 3,

        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(
              context,
            )) {
              Navigator.pop(
                context,
              );
            }
          },

          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),

        title: const Text(
          "FoodHub",

          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight:
            FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        physics:
        const BouncingScrollPhysics(),

        padding:
        const EdgeInsets.only(
          bottom: 30,
        ),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            // -------------------------------------------------
            // LOCAL FOOD IMAGE
            // -------------------------------------------------

            Container(
              width: double.infinity,
              height: 260,

              margin:
              const EdgeInsets.all(12),

              decoration:
              BoxDecoration(
                color: lightBlue,

                borderRadius:
                BorderRadius.circular(
                  18,
                ),
              ),

              clipBehavior:
              Clip.antiAlias,

              child: Image.asset(
                localImagePath,

                width: double.infinity,
                height: 260,

                fit: BoxFit.cover,

                errorBuilder: (
                    context,
                    error,
                    stackTrace,
                    ) {
                  return const Center(
                    child: Icon(
                      Icons.fastfood,
                      size: 90,
                      color: deepBlue,
                    ),
                  );
                },
              ),
            ),

            // -------------------------------------------------
            // TITLE
            // -------------------------------------------------

            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Text(
                title,

                style:
                const TextStyle(
                  fontSize: 26,
                  fontWeight:
                  FontWeight.bold,
                  color: deepBlue,
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            // -------------------------------------------------
            // PRICE
            // -------------------------------------------------

            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Text(
                "₹$price",

                style:
                const TextStyle(
                  fontSize: 24,
                  fontWeight:
                  FontWeight.bold,
                  color: mediumBlue,
                ),
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            // -------------------------------------------------
            // DESCRIPTION
            // -------------------------------------------------

            Container(
              width: double.infinity,

              margin:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              padding:
              const EdgeInsets.all(16),

              decoration:
              BoxDecoration(
                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                  15,
                ),
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  const Text(
                    "About this food",

                    style:
                    TextStyle(
                      fontSize: 19,
                      fontWeight:
                      FontWeight.bold,
                      color: deepBlue,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    description,

                    style:
                    const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            // -------------------------------------------------
            // QUANTITY
            // -------------------------------------------------

            Container(
              margin:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),

              decoration:
              BoxDecoration(
                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                  15,
                ),
              ),

              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Quantity",

                      style:
                      TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                        color: deepBlue,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed:
                    decreaseQuantity,

                    icon:
                    const Icon(
                      Icons
                          .remove_circle_outline,
                      color: deepBlue,
                      size: 30,
                    ),
                  ),

                  Container(
                    width: 48,
                    height: 42,

                    alignment:
                    Alignment.center,

                    decoration:
                    BoxDecoration(
                      color: lightBlue,

                      borderRadius:
                      BorderRadius
                          .circular(
                        10,
                      ),
                    ),

                    child: Text(
                      "$quantity",

                      style:
                      const TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                        color: deepBlue,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed:
                    increaseQuantity,

                    icon:
                    const Icon(
                      Icons
                          .add_circle_outline,
                      color: deepBlue,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            // -------------------------------------------------
            // ADD TO CART
            // -------------------------------------------------

            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: SizedBox(
                width: double.infinity,
                height: 55,

                child:
                ElevatedButton.icon(
                  onPressed:
                  adding
                      ? null
                      : addToCart,

                  icon: adding
                      ? const SizedBox(
                    width: 22,
                    height: 22,

                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(
                    Icons.shopping_cart,
                  ),

                  label: Text(
                    adding
                        ? "Adding..."
                        : "ADD TO CART",

                    style:
                    const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  style:
                  ElevatedButton
                      .styleFrom(
                    backgroundColor:
                    deepBlue,
                    foregroundColor:
                    Colors.white,
                    disabledBackgroundColor:
                    Colors.grey,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            // -------------------------------------------------
            // BACK TO ITEMS
            // -------------------------------------------------

            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: SizedBox(
                width: double.infinity,
                height: 50,

                child:
                OutlinedButton.icon(
                  onPressed: () {
                    if (Navigator.canPop(
                      context,
                    )) {
                      Navigator.pop(
                        context,
                      );
                    }
                  },

                  icon: const Icon(
                    Icons.arrow_back,
                  ),

                  label: const Text(
                    "BACK TO ITEMS",

                    style:
                    TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  style:
                  OutlinedButton
                      .styleFrom(
                    foregroundColor:
                    deepBlue,

                    side:
                    const BorderSide(
                      color: deepBlue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}