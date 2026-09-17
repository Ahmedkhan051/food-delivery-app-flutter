import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:user_app/mainScreens/item_detail_screen.dart';
import 'package:user_app/models/items.dart';

class ItemsDesignWidget extends StatefulWidget {
  final Items? model;
  final BuildContext? context;

  // The restaurant that owns this item.
  final String sellerUID;

  const ItemsDesignWidget({
    super.key,
    this.model,
    this.context,
    this.sellerUID = "",
  });

  @override
  State<ItemsDesignWidget> createState() => _ItemsDesignWidgetState();
}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  static const Color darkBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFFE3F2FD);

  // =========================================================
  // SAVE SELECTED RESTAURANT
  // =========================================================

  Future<void> saveSelectedRestaurant() async {
    final String uid = widget.sellerUID.trim();

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

  // =========================================================
  // GET LOCAL FOOD IMAGE
  // =========================================================

  String getFoodImage(String title) {
    final String food = title.trim().toLowerCase();

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

      if (food.contains("pepperoni")) {
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
      if (food.contains("cheese")) {
        return "assets/images/burger1.jpeg";
      }

      if (food.contains("chicken")) {
        return "assets/images/burger2.jpeg";
      }

      if (food.contains("double")) {
        return "assets/images/burger3.jpeg";
      }

      if (food.contains("king")) {
        return "assets/images/burger4.jpeg";
      }

      if (food.contains("classic")) {
        return "assets/images/burger5.png";
      }

      if (food.contains("special")) {
        return "assets/images/burger6.jpeg";
      }

      if (food.contains("crispy")) {
        return "assets/images/burger7.jpeg";
      }

      if (food.contains("spicy")) {
        return "assets/images/burger8.jpeg";
      }

      if (food.contains("mega")) {
        return "assets/images/burger9.jpeg";
      }

      if (food.contains("ultimate")) {
        return "assets/images/burger10.jpeg";
      }

      if (food.contains("grilled")) {
        return "assets/images/burger11.jpeg";
      }

      if (food.contains("premium")) {
        return "assets/images/burger12.jpeg";
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

      if (food.contains("cream")) {
        return "assets/images/cake7.jpeg";
      }

      if (food.contains("birthday")) {
        return "assets/images/cake8.jpeg";
      }

      if (food.contains("special")) {
        return "assets/images/cake9.jpeg";
      }

      if (food.contains("pineapple")) {
        return "assets/images/cake10.jpeg";
      }

      if (food.contains("butter")) {
        return "assets/images/cake11.jpeg";
      }

      if (food.contains("designer")) {
        return "assets/images/cake12.jpeg";
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

      if (food.contains("grill")) {
        return "assets/images/nonveg6.jpeg";
      }

      if (food.contains("tikka")) {
        return "assets/images/nonveg7.jpeg";
      }

      if (food.contains("kebab")) {
        return "assets/images/nonveg8.jpeg";
      }

      if (food.contains("biryani")) {
        return "assets/images/nonveg9.jpeg";
      }

      if (food.contains("roast")) {
        return "assets/images/nonveg10.jpeg";
      }

      if (food.contains("special")) {
        return "assets/images/nonveg11.jpeg";
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

      if (food.contains("tikka")) {
        return "assets/images/veg5.jpeg";
      }

      if (food.contains("fried")) {
        return "assets/images/veg6.jpeg";
      }

      if (food.contains("mix")) {
        return "assets/images/veg7.jpeg";
      }

      if (food.contains("special")) {
        return "assets/images/veg8.jpeg";
      }

      if (food.contains("curry")) {
        return "assets/images/veg9.jpeg";
      }

      if (food.contains("thali")) {
        return "assets/images/veg10.jpeg";
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

    if (food.contains("momo") ||
        food.contains("momos")) {
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

    if (food.contains("laddoo") ||
        food.contains("laddu")) {
      return "assets/images/laddoo.jpeg";
    }

    // -------------------------------------------------------
    // SOFT DRINK
    // -------------------------------------------------------

    if (food.contains("softdrink") ||
        food.contains("soft drink") ||
        food.contains("cold drink") ||
        food.contains("cola") ||
        food.contains("soda")) {
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
    // GENERAL FOOD
    // -------------------------------------------------------

    if (food.contains("food") ||
        food.contains("meal") ||
        food.contains("dish")) {
      return "assets/images/food1.jpeg";
    }

    // -------------------------------------------------------
    // DEFAULT
    // -------------------------------------------------------

    return "assets/images/homefood.jpeg";
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final String title =
    widget.model?.title?.trim().isNotEmpty == true
        ? widget.model!.title!.trim()
        : "Food Item";

    final String shortInfo =
    widget.model?.shortInfo?.trim().isNotEmpty == true
        ? widget.model!.shortInfo!.trim()
        : "Delicious food";

    final String imagePath = getFoodImage(title);

    return InkWell(
      onTap: () async {
        // -----------------------------------------------------
        // KEEP THE EXACT RESTAURANT SELECTED
        // -----------------------------------------------------

        await saveSelectedRestaurant();

        if (!mounted) {
          return;
        }

        if (widget.model == null) {
          return;
        }

        // -----------------------------------------------------
        // FORCE THE ITEM TO KEEP THE EXACT RESTAURANT UID
        // -----------------------------------------------------

        widget.model!.sellerUID = widget.sellerUID.trim();

        // -----------------------------------------------------
        // OPEN FOOD DETAILS
        // -----------------------------------------------------

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailsScreen(
              model: widget.model,
            ),
          ),
        );
      },
      splashColor: const Color(0xFFBBDEFB),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFBBDEFB),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // ------------------------------------------------
              // FOOD IMAGE
              // ------------------------------------------------

              Container(
                height: 220,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    imagePath,
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

              const SizedBox(height: 10),

              // ------------------------------------------------
              // FOOD TITLE
              // ------------------------------------------------

              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: darkBlue,
                  fontSize: 20,
                  fontFamily: "Train",
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              // ------------------------------------------------
              // FOOD DESCRIPTION
              // ------------------------------------------------

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Text(
                  shortInfo,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: "Train",
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ------------------------------------------------
              // VIEW DETAILS
              // ------------------------------------------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 9,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant,
                      color: darkBlue,
                      size: 19,
                    ),
                    SizedBox(width: 7),
                    Text(
                      "View Details",
                      style: TextStyle(
                        color: darkBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: darkBlue,
                      size: 13,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // FALLBACK IMAGE
  // =========================================================

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 220,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fastfood,
              color: Colors.white,
              size: 70,
            ),
            SizedBox(height: 8),
            Text(
              "FoodHub",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Food Item",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}