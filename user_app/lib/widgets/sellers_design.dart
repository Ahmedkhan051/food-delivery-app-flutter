import 'package:flutter/material.dart';
import 'package:user_app/mainScreens/menus_screen.dart';
import 'package:user_app/models/sellers.dart';

class SellersDesignWidget extends StatelessWidget {
  final Sellers? model;
  final BuildContext? context;

  const SellersDesignWidget({
    super.key,
    this.model,
    this.context,
  });

  static const Color deepBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFFE3F2FD);

  // ---------------------------------------------------------
  // NORMALIZE TEXT
  // ---------------------------------------------------------

  String normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(' ', '');
  }

  // ---------------------------------------------------------
  // GET RESTAURANT IMAGE
  // ---------------------------------------------------------

  String getRestaurantImage({
    required String name,
    required String email,
  }) {
    final String restaurantName = normalize(name);
    final String restaurantEmail = normalize(email);

    // =======================================================
    // EXISTING RESTAURANTS
    // =======================================================

    // -------------------------------------------------------
    // ABDUL
    // -------------------------------------------------------

    if (restaurantName == "abdul" ||
        restaurantEmail == "max45535@gmail.com") {
      return "assets/images/abdul_restaurent.png";
    }

    // -------------------------------------------------------
    // ALI
    // -------------------------------------------------------

    if (restaurantName == "ali" ||
        restaurantEmail == "ali@gmail.com") {
      return "assets/images/ali_restaurent.png";
    }

    // -------------------------------------------------------
    // SAURAV
    // -------------------------------------------------------

    if (restaurantName == "saurav" ||
        restaurantName == "sourav" ||
        restaurantEmail == "sauravbaraskar202@gmail.com") {
      return "assets/images/saurav_restaurent.png";
    }

    // -------------------------------------------------------
    // TT
    // -------------------------------------------------------

    if (restaurantName == "tt" ||
        restaurantEmail == "tt@mail.ru") {
      return "assets/images/tt_restaurent.png";
    }

    // -------------------------------------------------------
    // EE
    // -------------------------------------------------------

    if (restaurantName == "ee" ||
        restaurantEmail == "ee123@gmail.com") {
      return "assets/images/ee_restaurent.png";
    }

    // -------------------------------------------------------
    // SEL
    // -------------------------------------------------------

    if (restaurantName == "sel" ||
        restaurantEmail == "sel123@gmail.com") {
      return "assets/images/sel_restaurent.png";
    }

    // -------------------------------------------------------
    // SHADY
    // -------------------------------------------------------

    if (restaurantName == "shady" ||
        restaurantEmail == "shadystore@hotmail.com") {
      return "assets/images/shady_restaurent.png";
    }

    // -------------------------------------------------------
    // SELL
    // -------------------------------------------------------

    if (restaurantName == "sell" ||
        restaurantEmail == "sell@gmail.com") {
      return "assets/images/sell_restaurent.png";
    }

    // -------------------------------------------------------
    // AAAA
    // -------------------------------------------------------

    if (restaurantName == "aaaa" ||
        restaurantEmail == "xyz@gmail.com") {
      return "assets/images/aaaa_restaurent.png";
    }

    // -------------------------------------------------------
    // BURGER KING
    // -------------------------------------------------------

    if (restaurantName == "burgerking" ||
        restaurantEmail == "burgerking@gmail.com") {
      return "assets/images/Burger King_restaurent.png";
    }

    // -------------------------------------------------------
    // HARENDRA SELLER
    // -------------------------------------------------------

    if (restaurantName == "harendraseller" ||
        restaurantEmail == "harendraseller@gmail.com") {
      return "assets/images/Harendra Seller_restaurent.png";
    }

    // -------------------------------------------------------
    // DAOL
    // -------------------------------------------------------

    if (restaurantName == "daol" ||
        restaurantEmail == "daol@gmail.com") {
      return "assets/images/daol_restaurent.png";
    }

    // -------------------------------------------------------
    // ALWASEEM
    // -------------------------------------------------------

    if (restaurantName == "alwaseem" ||
        restaurantEmail == "alwaseem@gmail.com") {
      return "assets/images/alwaseem_restaurent.png";
    }

    // -------------------------------------------------------
    // TEST
    // -------------------------------------------------------

    if (restaurantName == "test" ||
        restaurantEmail == "test@gmail.com") {
      return "assets/images/test_restaurent.png";
    }

    // -------------------------------------------------------
    // OSMAN
    // -------------------------------------------------------

    if (restaurantName == "osman" ||
        restaurantEmail == "osman@gmail.com") {
      return "assets/images/osman_restaurent.png";
    }

    // =======================================================
    // NEW RESTAURANTS
    // =======================================================

    // -------------------------------------------------------
    // PIZZA HUT
    // -------------------------------------------------------

    if (restaurantName == "pizzahut" ||
        restaurantEmail == "pizzahut@gmail.com") {
      return "assets/images/piza4.jpeg";
    }

    // -------------------------------------------------------
    // MCDONALD'S
    // -------------------------------------------------------

    if (restaurantName == "mcdonald's" ||
        restaurantEmail == "mcdonalds@gmail.com") {
      return "assets/images/restaurent1.jpeg";
    }

    // -------------------------------------------------------
    // BURGER KING
    // Already handled above, kept here as a clear fallback.
    // -------------------------------------------------------

    if (restaurantEmail == "burgerking@gmail.com") {
      return "assets/images/Burger King_restaurent.png";
    }

    // -------------------------------------------------------
    // DOMINO'S PIZZA
    // -------------------------------------------------------

    if (restaurantName == "domino'spizza" ||
        restaurantEmail == "dominos@gmail.com") {
      return "assets/images/pizz.png";
    }

    // -------------------------------------------------------
    // KFC
    // -------------------------------------------------------

    if (restaurantName == "kfc" ||
        restaurantEmail == "kfc@gmail.com") {
      return "assets/images/non-veg.jpeg";
    }

    // -------------------------------------------------------
    // SUBWAY
    // -------------------------------------------------------

    if (restaurantName == "subway" ||
        restaurantEmail == "subway@gmail.com") {
      return "assets/images/restaurent2.jpeg";
    }

    // -------------------------------------------------------
    // FRESH FRUIT CORNER
    // -------------------------------------------------------

    if (restaurantName == "freshfruitcorner" ||
        restaurantEmail == "freshfruit@gmail.com") {
      return "assets/images/fruits.png";
    }

    // -------------------------------------------------------
    // DRINKS & SHAKES
    // -------------------------------------------------------

    if (restaurantName == "drinks&shakes" ||
        restaurantName == "drinksandshakes" ||
        restaurantEmail == "drinksandshakes@gmail.com") {
      return "assets/images/softdrink.png";
    }

    // -------------------------------------------------------
    // SWEET & SNACKS
    // -------------------------------------------------------

    if (restaurantName == "sweet&snacks" ||
        restaurantName == "sweetandsnacks" ||
        restaurantEmail == "sweetandsnacks@gmail.com") {
      return "assets/images/laddoo.jpeg";
    }

    // -------------------------------------------------------
    // BAKERY & FAST FOOD
    // -------------------------------------------------------

    if (restaurantName == "bakery&fastfood" ||
        restaurantName == "bakeryandfastfood" ||
        restaurantEmail == "bakeryfastfood@gmail.com") {
      return "assets/images/cake.jpeg";
    }

    // -------------------------------------------------------
    // NO CUSTOM IMAGE
    // -------------------------------------------------------

    return "";
  }

  // ---------------------------------------------------------
  // RESTAURANT NAME
  // ---------------------------------------------------------

  String get restaurantName {
    if (model == null) {
      return "FoodHub";
    }

    return model!.sellerName?.trim().isNotEmpty == true
        ? model!.sellerName!.trim()
        : "FoodHub";
  }

  // ---------------------------------------------------------
  // RESTAURANT EMAIL
  // ---------------------------------------------------------

  String get restaurantEmail {
    if (model == null) {
      return "";
    }

    return model!.sellerEmail?.trim() ?? "";
  }

  // ---------------------------------------------------------
  // OPEN RESTAURANT MENU
  // ---------------------------------------------------------

  void openMenu(BuildContext screenContext) {
    if (model == null) {
      return;
    }

    Navigator.push(
      screenContext,
      MaterialPageRoute(
        builder: (context) => MenusScreen(
          model: model,
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext screenContext) {
    if (model == null) {
      return const SizedBox.shrink();
    }

    final String imagePath = getRestaurantImage(
      name: restaurantName,
      email: restaurantEmail,
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(
              25,
              0,
              0,
              0,
            ),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ---------------------------------------------------
          // RESTAURANT IMAGE
          // ---------------------------------------------------

          SizedBox(
            width: double.infinity,
            height: 260,
            child: imagePath.isNotEmpty
                ? Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (
                  context,
                  error,
                  stackTrace,
                  ) {
                return _defaultRestaurantImage();
              },
            )
                : _defaultRestaurantImage(),
          ),

          // ---------------------------------------------------
          // RESTAURANT INFORMATION
          // ---------------------------------------------------

          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              14,
              16,
              16,
            ),
            child: Column(
              children: [
                Text(
                  restaurantName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: deepBlue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (restaurantEmail.isNotEmpty) ...[
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    restaurantEmail,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],

                const SizedBox(
                  height: 14,
                ),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      openMenu(screenContext);
                    },
                    icon: const Icon(
                      Icons.restaurant_menu,
                    ),
                    label: const Text(
                      "View Menu",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightBlue,
                      foregroundColor: deepBlue,
                      elevation: 0,
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
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // DEFAULT RESTAURANT IMAGE
  // ---------------------------------------------------------

  Widget _defaultRestaurantImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF90CAF9),
            Color(0xFF42A5F5),
          ],
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant,
            color: Colors.white,
            size: 75,
          ),

          SizedBox(
            height: 15,
          ),

          Text(
            "FoodHub",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(
            height: 4,
          ),

          Text(
            "Restaurant",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}