import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:user_app/mainScreens/items_screen.dart';
import 'package:user_app/models/menus.dart';

class MenusDesignWidget extends StatefulWidget {
  final Menus? model;
  final BuildContext? context;

  // ---------------------------------------------------------
  // SELECTED RESTAURANT UID
  // ---------------------------------------------------------
  final String sellerUID;

  const MenusDesignWidget({
    super.key,
    this.model,
    this.context,
    this.sellerUID = "",
  });

  @override
  State<MenusDesignWidget> createState() =>
      _MenusDesignWidgetState();
}

class _MenusDesignWidgetState
    extends State<MenusDesignWidget> {
  static const Color darkBlue =
  Color(0xFF1565C0);

  static const Color lightBlue =
  Color(0xFFE3F2FD);

  // ---------------------------------------------------------
  // SAVE SELECTED RESTAURANT
  // ---------------------------------------------------------
  Future<void> saveSelectedRestaurant() async {
    final String uid =
    widget.sellerUID.trim();

    if (uid.isEmpty) {
      return;
    }

    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      "selectedRestaurantSellerUID",
      uid,
    );
  }

  // ---------------------------------------------------------
  // GET LOCAL MENU IMAGE
  // ---------------------------------------------------------

  String getMenuImage(String title) {
    final String menu =
    title.trim().toLowerCase();

    // Pizza
    if (menu.contains("pizza")) {
      return "assets/images/pizza1.jpeg";
    }

    // Burger
    if (menu.contains("burger")) {
      return "assets/images/burger.png";
    }

    // Cake
    if (menu.contains("cake")) {
      return "assets/images/cake.jpeg";
    }

    // Non-Veg
    if (menu.contains("non-veg") ||
        menu.contains("non veg") ||
        menu.contains("nonveg")) {
      return "assets/images/non-veg.jpeg";
    }

    // Veg
    if (menu.contains("veg")) {
      return "assets/images/veg1.jpeg";
    }

    // Soft Drinks
    if (menu.contains("soft drink") ||
        menu.contains("softdrink")) {
      return "assets/images/softdrink.jpeg";
    }

    // Drinks
    if (menu.contains("drink")) {
      return "assets/images/softdrink1.jpeg";
    }

    // Pastries
    if (menu.contains("pastr")) {
      return "assets/images/pastries.jpeg";
    }

    // Momos
    if (menu.contains("momo")) {
      return "assets/images/momos.jpeg";
    }

    // Shake
    if (menu.contains("shake")) {
      return "assets/images/shake.jpeg";
    }

    // Gulab Jamun / Dessert / Sweet
    if (menu.contains("gulab") ||
        menu.contains("dessert") ||
        menu.contains("sweet")) {
      return "assets/images/gulabjamun.jpeg";
    }

    // Fruit
    if (menu.contains("fruit")) {
      return "assets/images/fruit.png";
    }

    // Dining
    if (menu.contains("dining")) {
      return "assets/images/diningfood.jpeg";
    }

    // Discount / Offer
    if (menu.contains("discount") ||
        menu.contains("offer")) {
      return "assets/images/discountfood.jpeg";
    }

    // Delivery
    if (menu.contains("delivery")) {
      return "assets/images/deliveryfood.jpeg";
    }

    // Fast Food
    if (menu.contains("fast food") ||
        menu.contains("fastfood")) {
      return "assets/images/homefood1.jpeg";
    }

    // Default image
    return "assets/images/homefood.jpeg";
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final String menuTitle =
    widget.model?.menuTitle
        ?.trim()
        .isNotEmpty ==
        true
        ? widget.model!.menuTitle!
        : "Food Menu";

    final String menuInfo =
    widget.model?.menuInfo
        ?.trim()
        .isNotEmpty ==
        true
        ? widget.model!.menuInfo!
        : "Delicious food";

    final String menuImage =
    getMenuImage(menuTitle);

    return InkWell(
      onTap: () async {
        // ---------------------------------------------------
        // SAVE THE EXACT RESTAURANT SELECTED
        // ---------------------------------------------------
        await saveSelectedRestaurant();

        if (!mounted) {
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ItemsScreen(
                  model: widget.model,
                ),
          ),
        );
      },

      splashColor:
      const Color(0xFFBBDEFB),

      borderRadius:
      BorderRadius.circular(16),

      child: Padding(
        padding:
        const EdgeInsets.all(8),

        child: Container(
          width: double.infinity,

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
            BorderRadius.circular(16),

            border: Border.all(
              color:
              const Color(0xFFBBDEFB),
              width: 1,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(0.08),
                blurRadius: 8,
                offset:
                const Offset(0, 3),
              ),
            ],
          ),

          child: Column(
            children: [
              // --------------------------------------------
              // LOCAL MENU IMAGE
              // --------------------------------------------

              Container(
                height: 220,
                width: double.infinity,

                decoration:
                const BoxDecoration(
                  color: lightBlue,

                  borderRadius:
                  BorderRadius.vertical(
                    top:
                    Radius.circular(16),
                  ),
                ),

                child: ClipRRect(
                  borderRadius:
                  const BorderRadius
                      .vertical(
                    top:
                    Radius.circular(16),
                  ),

                  child: Image.asset(
                    menuImage,

                    height: 220,
                    width: double.infinity,

                    fit: BoxFit.cover,

                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return _buildImagePlaceholder();
                    },
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // --------------------------------------------
              // MENU TITLE
              // --------------------------------------------

              Text(
                menuTitle,

                textAlign:
                TextAlign.center,

                maxLines: 2,

                overflow:
                TextOverflow.ellipsis,

                style: const TextStyle(
                  color: darkBlue,
                  fontSize: 20,
                  fontFamily: "Train",
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 4,
              ),

              // --------------------------------------------
              // MENU INFORMATION
              // --------------------------------------------

              Padding(
                padding:
                const EdgeInsets
                    .symmetric(
                  horizontal: 12,
                ),

                child: Text(
                  menuInfo,

                  textAlign:
                  TextAlign.center,

                  maxLines: 2,

                  overflow:
                  TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: "Train",
                  ),
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              // --------------------------------------------
              // VIEW FOOD BUTTON
              // --------------------------------------------

              Container(
                width: double.infinity,

                padding:
                const EdgeInsets
                    .symmetric(
                  vertical: 9,
                ),

                margin:
                const EdgeInsets
                    .symmetric(
                  horizontal: 10,
                ),

                decoration:
                BoxDecoration(
                  color: lightBlue,

                  borderRadius:
                  BorderRadius.circular(
                    10,
                  ),
                ),

                child: const Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      color: darkBlue,
                      size: 19,
                    ),

                    SizedBox(
                      width: 7,
                    ),

                    Text(
                      "View Food",
                      style: TextStyle(
                        color: darkBlue,
                        fontSize: 14,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    SizedBox(
                      width: 5,
                    ),

                    Icon(
                      Icons.arrow_forward_ios,
                      color: darkBlue,
                      size: 13,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // FALLBACK IMAGE
  // ---------------------------------------------------------

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 220,

      decoration:
      const BoxDecoration(
        gradient:
        LinearGradient(
          colors: [
            Color(0xFF90CAF9),
            Color(0xFF42A5F5),
          ],

          begin:
          Alignment.topLeft,

          end:
          Alignment.bottomRight,
        ),
      ),

      child: const Center(
        child: Icon(
          Icons.restaurant_menu,
          color: Colors.white,
          size: 70,
        ),
      ),
    );
  }
}