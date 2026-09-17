import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/mainScreens/itemsScreen.dart';
import 'package:seller_app/model/menus.dart';

class InfoDesignWidget extends StatefulWidget {
  final Menus? model;
  final BuildContext? context;

  const InfoDesignWidget({
    super.key,
    this.model,
    this.context,
  });

  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  static const Color darkBlue = Color(0xFF1565C0);
  static const Color mediumBlue = Color(0xFF42A5F5);
  static const Color lightBlue = Color(0xFFE3F2FD);

  Future<void> deleteMenu(String menuId) async {
    final String? sellerUID =
        sharedPreferences?.getString("uid") ??
            firebaseAuth.currentUser?.uid;

    if (sellerUID == null ||
        sellerUID.isEmpty ||
        menuId.isEmpty) {
      Fluttertoast.showToast(
        msg: "Unable to delete menu.",
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("sellers")
          .doc(sellerUID)
          .collection("menus")
          .doc(menuId)
          .delete();

      if (!mounted) return;

      Fluttertoast.showToast(
        msg: "Menu deleted successfully",
      );
    } catch (error) {
      if (!mounted) return;

      Fluttertoast.showToast(
        msg: "Failed to delete menu",
      );
    }
  }

  // ---------------------------------------------------------
  // BUILD MENU IMAGE
  // ---------------------------------------------------------

  Widget buildMenuImage(
      String imagePath,
      String menuTitle,
      ) {
    final String cleanedPath = imagePath.trim();

    // -------------------------------------------------------
    // LOCAL ASSET
    // -------------------------------------------------------

    if (cleanedPath.startsWith("assets/")) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          cleanedPath,
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (
              context,
              error,
              stackTrace,
              ) {
            // Try a title-based fallback instead of immediately
            // showing the FoodHub placeholder.
            final String fallbackImage =
            getMenuImage(menuTitle);

            if (fallbackImage != cleanedPath) {
              return Image.asset(
                fallbackImage,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (
                    context,
                    error,
                    stackTrace,
                    ) {
                  return buildImagePlaceholder();
                },
              );
            }

            return buildImagePlaceholder();
          },
        ),
      );
    }

    // -------------------------------------------------------
    // NETWORK IMAGE
    // -------------------------------------------------------

    if (cleanedPath.startsWith("http://") ||
        cleanedPath.startsWith("https://")) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          cleanedPath,
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (
              context,
              error,
              stackTrace,
              ) {
            return Image.asset(
              getMenuImage(menuTitle),
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (
                  context,
                  error,
                  stackTrace,
                  ) {
                return buildImagePlaceholder();
              },
            );
          },
        ),
      );
    }

    // -------------------------------------------------------
    // EMPTY / UNKNOWN PATH
    // -------------------------------------------------------

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        getMenuImage(menuTitle),
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return buildImagePlaceholder();
        },
      ),
    );
  }

  // ---------------------------------------------------------
  // GET FALLBACK MENU IMAGE
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

    // Cake / Bakery
    if (menu.contains("cake") ||
        menu.contains("bakery")) {
      return "assets/images/cake.jpeg";
    }

    // Chocolate
    if (menu.contains("chocolate")) {
      return "assets/images/chokolate.jpeg";
    }

    // Non-vegetarian / Chicken
    if (menu.contains("non-veg") ||
        menu.contains("non veg") ||
        menu.contains("nonveg") ||
        menu.contains("chicken")) {
      return "assets/images/non-veg.jpeg";
    }

    // Vegetarian
    if (menu == "vegetarian" ||
        menu.contains("vegetarian") ||
        menu.contains("veg")) {
      return "assets/images/veg1.jpeg";
    }

    // Soft drinks
    if (menu.contains("soft drink") ||
        menu.contains("softdrink") ||
        menu.contains("cold drink")) {
      return "assets/images/softdrink.jpeg";
    }

    // Drinks
    if (menu.contains("drink")) {
      return "assets/images/softdrink1.jpeg";
    }

    // Shakes
    if (menu.contains("shake")) {
      return "assets/images/shake.jpeg";
    }

    // Pastries
    if (menu.contains("pastr")) {
      return "assets/images/pastries.jpeg";
    }

    // Momos
    if (menu.contains("momo")) {
      return "assets/images/momos.jpeg";
    }

    // Samosa / Snacks
    if (menu.contains("samosa") ||
        menu.contains("snack")) {
      return "assets/images/samosa.jpeg";
    }

    // Gulab Jamun
    if (menu.contains("gulab") ||
        menu.contains("jamun")) {
      return "assets/images/gulabjamun.jpeg";
    }

    // Jalebi
    if (menu.contains("jalebi")) {
      return "assets/images/jalebi.webp";
    }

    // Kaju Barfi
    if (menu.contains("kaju") ||
        menu.contains("barfi")) {
      return "assets/images/kajubarfi.jpeg";
    }

    // Laddoo
    if (menu.contains("laddu") ||
        menu.contains("laddoo")) {
      return "assets/images/laddoo.jpeg";
    }

    // Sweets
    if (menu.contains("sweet") ||
        menu.contains("dessert")) {
      return "assets/images/gulabjamun.jpeg";
    }

    // Fruits
    if (menu.contains("fruit")) {
      return "assets/images/fruits.png";
    }

    // Subs / Sandwiches
    if (menu.contains("sub") ||
        menu.contains("sandwich")) {
      return "assets/images/burger.png";
    }

    // Dining
    if (menu.contains("dining")) {
      return "assets/images/diningfood.jpeg";
    }

    // Discount / Offers
    if (menu.contains("discount") ||
        menu.contains("offer")) {
      return "assets/images/discountfood.jpeg";
    }

    // Delivery
    if (menu.contains("delivery")) {
      return "assets/images/deliveryfood.jpeg";
    }

    // General fallback
    return "assets/images/homefood.jpeg";
  }

  // ---------------------------------------------------------
  // PLACEHOLDER
  // ---------------------------------------------------------

  Widget buildImagePlaceholder() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF90CAF9),
            Color(0xFF42A5F5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.restaurant_menu,
          color: Colors.white,
          size: 65,
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final Menus? menu = widget.model;

    if (menu == null) {
      return const SizedBox.shrink();
    }

    final String menuId =
        menu.menuId?.toString().trim() ?? "";

    final String menuTitle =
    menu.menuTitle?.toString().trim().isNotEmpty == true
        ? menu.menuTitle!.toString().trim()
        : "Unnamed Menu";

    final String thumbnailUrl =
        menu.thumbnailUrl?.toString().trim() ?? "";

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemsScreen(
              model: menu,
            ),
          ),
        );
      },
      splashColor:
      mediumBlue.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color:
                Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),

              // Menu image
              buildMenuImage(
                thumbnailUrl,
                menuTitle,
              ),

              const SizedBox(height: 10),

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        menuTitle,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow:
                        TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: darkBlue,
                          fontSize: 20,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),

                    if (menuId.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          deleteMenu(menuId);
                        },
                        icon: const Icon(
                          Icons.delete_sweep,
                          color: darkBlue,
                        ),
                        tooltip: "Delete menu",
                      ),
                  ],
                ),
              ),

              const Divider(
                height: 4,
                thickness: 2,
                color: Colors.grey,
              ),

              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}