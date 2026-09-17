import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:user_app/mainScreens/item_detail_screen.dart';
import 'package:user_app/mainScreens/menus_screen.dart';
import 'package:user_app/models/items.dart';
import 'package:user_app/models/sellers.dart';
import 'package:user_app/widgets/my_drower.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/sellers_design.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color darkBlue =
  Color(0xFF1565C0);

  static const Color mediumBlue =
  Color(0xFF42A5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mediumBlue,
        elevation: 3,

        flexibleSpace: Container(
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
        ),

        title: const Text(
          "FoodHub",
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        automaticallyImplyLeading: true,

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      drawer: MyDrawer(),

      body: ListView(
        physics:
        const BouncingScrollPhysics(),

        padding: const EdgeInsets.only(
          top: 10,
          bottom: 20,
        ),

        children: [
          // --------------------------------------------------
          // WELCOME SECTION
          // --------------------------------------------------

          Container(
            margin:
            const EdgeInsets.symmetric(
              horizontal: 10,
            ),

            padding:
            const EdgeInsets.all(20),

            decoration:
            BoxDecoration(
              color:
              const Color(0xFFE3F2FD),

              borderRadius:
              BorderRadius.circular(
                18,
              ),
            ),

            child:
            const Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  "Welcome to FoodHub 👋",

                  style:
                  TextStyle(
                    fontSize: 24,
                    fontWeight:
                    FontWeight.bold,
                    color:
                    darkBlue,
                  ),
                ),

                SizedBox(
                  height: 8,
                ),

                Text(
                  "Order your favourite food from nearby restaurants.",

                  style:
                  TextStyle(
                    fontSize: 16,
                    color:
                    Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          // --------------------------------------------------
          // SEARCH BAR
          // --------------------------------------------------

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const FoodSearchScreen(),
                ),
              );
            },

            child:
            Container(
              margin:
              const EdgeInsets.symmetric(
                horizontal: 10,
              ),

              padding:
              const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 15,
              ),

              decoration:
              BoxDecoration(
                color:
                Colors.white,

                borderRadius:
                BorderRadius.circular(
                  15,
                ),

                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withOpacity(
                      0.08,
                    ),
                    blurRadius: 8,
                    offset:
                    const Offset(0, 3),
                  ),
                ],
              ),

              child:
              const Row(
                children: [
                  Icon(
                    Icons.search,
                    color:
                    mediumBlue,
                    size: 28,
                  ),

                  SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child:
                    Text(
                      "Find your favourite food",

                      style:
                      TextStyle(
                        fontSize: 16,
                        color:
                        Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          // --------------------------------------------------
          // POPULAR RESTAURANTS
          // --------------------------------------------------

          Container(
            width:
            double.infinity,

            margin:
            const EdgeInsets.symmetric(
              horizontal: 10,
            ),

            padding:
            const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 13,
            ),

            decoration:
            BoxDecoration(
              color:
              const Color(0xFFE3F2FD),

              borderRadius:
              BorderRadius.circular(
                15,
              ),
            ),

            child:
            const Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  color:
                  darkBlue,
                  size: 27,
                ),

                SizedBox(
                  width: 10,
                ),

                Text(
                  "Popular Restaurants",

                  style:
                  TextStyle(
                    color:
                    darkBlue,
                    fontSize: 22,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          // --------------------------------------------------
          // RESTAURANT LIST
          // --------------------------------------------------

          StreamBuilder<QuerySnapshot>(
            stream:
            FirebaseFirestore.instance
                .collection("sellers")
                .limit(15)
                .snapshots(),

            builder:
                (context, snapshot) {
              if (snapshot
                  .connectionState ==
                  ConnectionState.waiting) {
                return Padding(
                  padding:
                  const EdgeInsets.only(
                    top: 30,
                    bottom: 30,
                  ),

                  child:
                  Center(
                    child:
                    circularProgress(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Container(
                  margin:
                  const EdgeInsets.all(20),

                  padding:
                  const EdgeInsets.all(20),

                  decoration:
                  BoxDecoration(
                    color:
                    Colors.grey.shade100,

                    borderRadius:
                    BorderRadius.circular(
                      15,
                    ),
                  ),

                  child:
                  const Column(
                    children: [
                      Icon(
                        Icons.wifi_off,
                        size: 50,
                        color: Colors.grey,
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      Text(
                        "Unable to load restaurants.",

                        textAlign:
                        TextAlign.center,

                        style:
                        TextStyle(
                          color:
                          Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (!snapshot.hasData ||
                  snapshot.data!.docs
                      .isEmpty) {
                return Container(
                  margin:
                  const EdgeInsets.all(20),

                  padding:
                  const EdgeInsets.all(20),

                  decoration:
                  BoxDecoration(
                    color:
                    Colors.grey.shade100,

                    borderRadius:
                    BorderRadius.circular(
                      15,
                    ),
                  ),

                  child:
                  const Column(
                    children: [
                      Icon(
                        Icons.restaurant,
                        size: 50,
                        color: Colors.grey,
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      Text(
                        "No restaurants available.",

                        textAlign:
                        TextAlign.center,

                        style:
                        TextStyle(
                          color:
                          Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount:
                snapshot.data!.docs
                    .length,

                shrinkWrap:
                true,

                physics:
                const NeverScrollableScrollPhysics(),

                itemBuilder:
                    (context, index) {
                  final Map<String,
                      dynamic>
                  sellerData =
                  snapshot
                      .data!
                      .docs[index]
                      .data()
                  as Map<String,
                      dynamic>;

                  final Sellers
                  sellerModel =
                  Sellers.fromJson(
                    sellerData,
                  );

                  return Padding(
                    padding:
                    const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 10,
                    ),

                    child:
                    SellersDesignWidget(
                      model:
                      sellerModel,
                      context:
                      context,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// SEARCH SCREEN
// =====================================================================

class FoodSearchScreen
    extends StatefulWidget {
  const FoodSearchScreen({
    super.key,
  });

  @override
  State<FoodSearchScreen>
  createState() =>
      _FoodSearchScreenState();
}

class _FoodSearchScreenState
    extends State<FoodSearchScreen> {
  static const Color darkBlue =
  Color(0xFF1565C0);

  static const Color mediumBlue =
  Color(0xFF42A5F5);

  static const Color lightBlue =
  Color(0xFFE3F2FD);

  final TextEditingController
  searchController =
  TextEditingController();

  String searchText = "";

  @override
  void initState() {
    super.initState();

    searchController.addListener(
          () {
        setState(() {
          searchText =
              searchController.text
                  .trim()
                  .toLowerCase();
        });
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  // =========================================================
  // RESTAURANT IMAGE
  // =========================================================


  String normalizeRestaurantText(
      String value,
      ) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(' ', '');
  }

  String getRestaurantImage({
    required String name,
    required String email,
  }) {
    final String restaurant =
    normalizeRestaurantText(name);

    final String restaurantEmail =
    normalizeRestaurantText(email);

    // =======================================================
    // EXISTING RESTAURANTS
    // =======================================================

    if (restaurant == "abdul" ||
        restaurantEmail == "max45535@gmail.com") {
      return "assets/images/abdul_restaurent.png";
    }

    if (restaurant == "ali" ||
        restaurantEmail == "ali@gmail.com") {
      return "assets/images/ali_restaurent.png";
    }

    if (restaurant == "saurav" ||
        restaurant == "sourav" ||
        restaurantEmail == "sauravbaraskar202@gmail.com") {
      return "assets/images/saurav_restaurent.png";
    }

    if (restaurant == "tt" ||
        restaurantEmail == "tt@mail.ru") {
      return "assets/images/tt_restaurent.png";
    }

    if (restaurant == "ee" ||
        restaurantEmail == "ee123@gmail.com") {
      return "assets/images/ee_restaurent.png";
    }

    if (restaurant == "sel" ||
        restaurantEmail == "sel123@gmail.com") {
      return "assets/images/sel_restaurent.png";
    }

    if (restaurant == "shady" ||
        restaurantEmail == "shadystore@hotmail.com") {
      return "assets/images/shady_restaurent.png";
    }

    if (restaurant == "sell" ||
        restaurantEmail == "sell@gmail.com") {
      return "assets/images/sell_restaurent.png";
    }

    if (restaurant == "aaaa" ||
        restaurantEmail == "xyz@gmail.com") {
      return "assets/images/aaaa_restaurent.png";
    }

    if (restaurant == "burgerking" ||
        restaurantEmail == "burgerking@gmail.com") {
      return "assets/images/Burger King_restaurent.png";
    }

    if (restaurant == "harendraseller" ||
        restaurantEmail == "harendraseller@gmail.com") {
      return "assets/images/Harendra Seller_restaurent.png";
    }

    if (restaurant == "daol" ||
        restaurantEmail == "daol@gmail.com") {
      return "assets/images/daol_restaurent.png";
    }

    if (restaurant == "alwaseem" ||
        restaurantEmail == "alwaseem@gmail.com") {
      return "assets/images/alwaseem_restaurent.png";
    }

    if (restaurant == "test" ||
        restaurantEmail == "test@gmail.com") {
      return "assets/images/test_restaurent.png";
    }

    if (restaurant == "osman" ||
        restaurantEmail == "osman@gmail.com") {
      return "assets/images/osman_restaurent.png";
    }

    // =======================================================
    // NEW RESTAURANTS
    // =======================================================

    if (restaurant == "pizzahut" ||
        restaurantEmail == "pizzahut@gmail.com") {
      return "assets/images/piza4.jpeg";
    }

    if (restaurant == "mcdonald's" ||
        restaurantEmail == "mcdonalds@gmail.com") {
      return "assets/images/restaurent1.jpeg";
    }

    if (restaurant == "domino'spizza" ||
        restaurantEmail == "dominos@gmail.com") {
      return "assets/images/pizz.png";
    }

    if (restaurant == "kfc" ||
        restaurantEmail == "kfc@gmail.com") {
      return "assets/images/non-veg.jpeg";
    }

    if (restaurant == "subway" ||
        restaurantEmail == "subway@gmail.com") {
      return "assets/images/restaurent2.jpeg";
    }

    if (restaurant == "freshfruitcorner" ||
        restaurantEmail == "freshfruit@gmail.com") {
      return "assets/images/fruits.png";
    }

    if (restaurant == "drinks&shakes" ||
        restaurant == "drinksandshakes" ||
        restaurantEmail == "drinksandshakes@gmail.com") {
      return "assets/images/softdrink.png";
    }

    if (restaurant == "sweet&snacks" ||
        restaurant == "sweetandsnacks" ||
        restaurantEmail == "sweetandsnacks@gmail.com") {
      return "assets/images/laddoo.jpeg";
    }

    if (restaurant == "bakery&fastfood" ||
        restaurant == "bakeryandfastfood" ||
        restaurantEmail == "bakeryfastfood@gmail.com") {
      return "assets/images/cake.jpeg";
    }

    return "";
  }

  // =========================================================
  // FOOD IMAGE
  // =========================================================

  String getFoodImage(
      String title,
      ) {
    final String food =
    title.trim().toLowerCase();

    // PIZZA
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

      return "assets/images/piza4.jpeg";
    }

    // BURGER
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

    // CAKE
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

    // CHOCOLATE
    if (food.contains("chocolate") ||
        food.contains("chokolate")) {
      return "assets/images/chocolate.jpeg";
    }

    // NON VEG
    if (food.contains("non-veg") ||
        food.contains("non veg") ||
        food.contains("nonveg") ||
        food.contains("chicken") ||
        food.contains("mutton") ||
        food.contains("fish") ||
        food.contains("meat")) {
      return "assets/images/non-veg.jpeg";
    }

    // VEG
    if (food.contains("veg") ||
        food.contains("vegetable") ||
        food.contains("paneer")) {
      return "assets/images/veg1.jpeg";
    }

    // PASTRIES
    if (food.contains("pastry") ||
        food.contains("pastries")) {
      return "assets/images/pastries.jpeg";
    }

    // SAMOSA
    if (food.contains("samosa")) {
      return "assets/images/samosa.jpeg";
    }

    // MOMOS
    if (food.contains("momo")) {
      return "assets/images/momos.jpeg";
    }

    // SHAKE
    if (food.contains("shake")) {
      return "assets/images/shake.jpeg";
    }

    // GULAB JAMUN
    if (food.contains("gulab") ||
        food.contains("jamun")) {
      return "assets/images/gulabjamun.jpeg";
    }

    // JALEBI
    if (food.contains("jalebi")) {
      return "assets/images/jalebi.jpeg";
    }

    // KAJU BARFI
    if (food.contains("kaju") ||
        food.contains("barfi")) {
      return "assets/images/kajubarfi.jpeg";
    }

    // LADDOO
    if (food.contains("laddu") ||
        food.contains("laddoo")) {
      return "assets/images/laddoo.jpeg";
    }

    // SOFT DRINK
    if (food.contains("softdrink") ||
        food.contains("soft drink") ||
        food.contains("cold drink") ||
        food.contains("drink")) {
      return "assets/images/softdrink.jpeg";
    }

    // FRUIT
    if (food.contains("fruit")) {
      return "assets/images/fruit.png";
    }

    // DINING
    if (food.contains("dining")) {
      return "assets/images/diningfood.jpeg";
    }

    // DISCOUNT
    if (food.contains("discount")) {
      return "assets/images/discountfood.jpeg";
    }

    // DELIVERY
    if (food.contains("delivery")) {
      return "assets/images/deliveryfood.jpeg";
    }

    return "assets/images/homefood.jpeg";
  }

  // =========================================================
  // BUILD SEARCH SCREEN
  // =========================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF8FBFF),

      appBar: AppBar(
        backgroundColor:
        mediumBlue,

        elevation: 3,

        leading:
        IconButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },

          icon:
          const Icon(
            Icons.arrow_back,
            color:
            Colors.white,
          ),
        ),

        title:
        const Text(
          "Search Food",

          style:
          TextStyle(
            color:
            Colors.white,

            fontSize:
            25,

            fontWeight:
            FontWeight.bold,
          ),
        ),

        centerTitle:
        true,
      ),

      body:
      Column(
        children: [
          // -------------------------------------------------
          // SEARCH FIELD
          // -------------------------------------------------

          Padding(
            padding:
            const EdgeInsets.all(
              12,
            ),

            child:
            TextField(
              controller:
              searchController,

              autofocus:
              true,

              decoration:
              InputDecoration(
                hintText:
                "Search food or restaurant",

                prefixIcon:
                const Icon(
                  Icons.search,
                  color:
                  mediumBlue,
                ),

                suffixIcon:
                searchController
                    .text
                    .isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    searchController
                        .clear();
                  },
                  icon:
                  const Icon(
                    Icons.clear,
                  ),
                )
                    : null,

                filled:
                true,

                fillColor:
                Colors.white,

                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    15,
                  ),
                  borderSide:
                  BorderSide.none,
                ),

                enabledBorder:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    15,
                  ),
                  borderSide:
                  const BorderSide(
                    color:
                    Color(0xFFBBDEFB),
                  ),
                ),

                focusedBorder:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    15,
                  ),
                  borderSide:
                  const BorderSide(
                    color:
                    mediumBlue,
                    width:
                    2,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child:
            searchText.isEmpty
                ? _searchHint()
                : _searchResults(),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SEARCH HINT
  // =========================================================

  Widget _searchHint() {
    return const Center(
      child:
      Column(
        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [
          Icon(
            Icons.search,

            size:
            75,

            color:
            Color(0xFF90CAF9),
          ),

          SizedBox(
            height:
            15,
          ),

          Text(
            "Search for food or restaurants",

            textAlign:
            TextAlign.center,

            style:
            TextStyle(
              fontSize:
              17,

              color:
              Colors.grey,

              fontWeight:
              FontWeight.w500,
            ),
          ),

          SizedBox(
            height:
            8,
          ),

          Text(
            "Example: pizza, burger, Abdul",

            textAlign:
            TextAlign.center,

            style:
            TextStyle(
              fontSize:
              14,

              color:
              Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SEARCH RESULTS
  // =========================================================

  Widget _searchResults() {
    return ListView(
      physics:
      const BouncingScrollPhysics(),

      padding:
      const EdgeInsets.only(
        bottom: 20,
      ),

      children: [
        // ===================================================
        // RESTAURANTS
        // ===================================================

        const Padding(
          padding:
          EdgeInsets.fromLTRB(
            8,
            5,
            8,
            8,
          ),

          child:
          Text(
            "Restaurants",

            style:
            TextStyle(
              color:
              darkBlue,

              fontSize:
              20,

              fontWeight:
              FontWeight.bold,
            ),
          ),
        ),

        StreamBuilder<QuerySnapshot>(
          stream:
          FirebaseFirestore
              .instance
              .collection(
            "sellers",
          )
              .limit(50)
              .snapshots(),

          builder:
              (
              context,
              snapshot,
              ) {
            if (snapshot
                .connectionState ==
                ConnectionState.waiting) {
              return Padding(
                padding:
                const EdgeInsets.all(
                  20,
                ),

                child:
                Center(
                  child:
                  circularProgress(),
                ),
              );
            }

            if (snapshot.hasError) {
              return _notFound(
                "Unable to search restaurants.",
              );
            }

            if (!snapshot.hasData) {
              return _notFound(
                "No restaurants found.",
              );
            }

            final List<Sellers>
            results =
            [];

            for (final QueryDocumentSnapshot
            document
            in snapshot
                .data!.docs) {
              try {
                final Map<String,
                    dynamic>
                data =
                document
                    .data()
                as Map<String,
                    dynamic>;

                final Sellers
                seller =
                Sellers.fromJson(
                  data,
                );

                final String name =
                    seller.sellerName
                        ?.toLowerCase()
                        .replaceAll(
                      RegExp(r'[^a-z0-9]'),
                      '',
                    ) ??
                        "";

                final String email =
                    seller.sellerEmail
                        ?.toLowerCase()
                        .replaceAll(
                      RegExp(r'[^a-z0-9]'),
                      '',
                    ) ??
                        "";

                final String normalizedSearch =
                searchText
                    .toLowerCase()
                    .replaceAll(
                  RegExp(r'[^a-z0-9]'),
                  '',
                );

                if (name.contains(
                  normalizedSearch,
                ) ||
                    email.contains(
                      normalizedSearch,
                    )) {
                  results.add(
                    seller,
                  );
                }
              } catch (_) {}
            }

            if (results.isEmpty) {
              return _notFound(
                "No matching restaurants.",
              );
            }

            return Column(
              children:
              results.map(
                    (
                    Sellers seller,
                    ) {
                  return Padding(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 4,
                      vertical: 5,
                    ),

                    child:
                    _restaurantResult(
                      seller,
                    ),
                  );
                },
              ).toList(),
            );
          },
        ),

        const SizedBox(
          height: 15,
        ),

        // ===================================================
        // FOOD
        // ===================================================

        const Padding(
          padding:
          EdgeInsets.fromLTRB(
            8,
            5,
            8,
            8,
          ),

          child:
          Text(
            "Food",

            style:
            TextStyle(
              color:
              darkBlue,

              fontSize:
              20,

              fontWeight:
              FontWeight.bold,
            ),
          ),
        ),

        StreamBuilder<QuerySnapshot>(
          stream:
          FirebaseFirestore
              .instance
              .collectionGroup(
            "items",
          )
              .limit(100)
              .snapshots(),

          builder:
              (
              context,
              snapshot,
              ) {
            if (snapshot
                .connectionState ==
                ConnectionState.waiting) {
              return Padding(
                padding:
                const EdgeInsets.all(
                  20,
                ),

                child:
                Center(
                  child:
                  circularProgress(),
                ),
              );
            }

            if (snapshot.hasError) {
              return _notFound(
                "Unable to search food.",
              );
            }

            if (!snapshot.hasData) {
              return _notFound(
                "No food found.",
              );
            }

            final List<Items>
            results =
            [];

            for (final QueryDocumentSnapshot
            document
            in snapshot
                .data!.docs) {
              try {
                final Map<String,
                    dynamic>
                data =
                document
                    .data()
                as Map<String,
                    dynamic>;

                final String
                title =
                    data["title"]
                        ?.toString()
                        .toLowerCase() ??
                        "";

                final String
                shortInfo =
                    data["shortInfo"]
                        ?.toString()
                        .toLowerCase() ??
                        "";

                final String
                longDescription =
                    data["longDescription"]
                        ?.toString()
                        .toLowerCase() ??
                        "";

                if (title.contains(
                  searchText,
                ) ||
                    shortInfo.contains(
                      searchText,
                    ) ||
                    longDescription
                        .contains(
                      searchText,
                    )) {
                  results.add(
                    Items.fromJson(
                      data,
                    ),
                  );
                }
              } catch (_) {}
            }

            if (results.isEmpty) {
              return _notFound(
                "No matching food items.",
              );
            }

            return Column(
              children:
              results.map(
                    (
                    Items item,
                    ) {
                  return Padding(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 4,
                      vertical: 5,
                    ),

                    child:
                    _foodResult(
                      item,
                    ),
                  );
                },
              ).toList(),
            );
          },
        ),
      ],
    );
  }

  // =========================================================
  // RESTAURANT RESULT
  // =========================================================

  Widget _restaurantResult(
      Sellers seller,
      ) {
    final String name =
        seller.sellerName ??
            "Restaurant";

    final String imagePath =
    getRestaurantImage(
      name: seller.sellerName ?? "",
      email: seller.sellerEmail ?? "",
    );

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                MenusScreen(
                  model:
                  seller,
                ),
          ),
        );
      },

      borderRadius:
      BorderRadius.circular(
        15,
      ),

      child:
      Container(
        padding:
        const EdgeInsets.all(
          10,
        ),

        decoration:
        BoxDecoration(
          color:
          Colors.white,

          borderRadius:
          BorderRadius.circular(
            15,
          ),

          border:
          Border.all(
            color:
            const Color(
              0xFFBBDEFB,
            ),
          ),

          boxShadow: [
            BoxShadow(
              color:
              Colors.black.withOpacity(
                0.06,
              ),

              blurRadius:
              6,

              offset:
              const Offset(
                0,
                2,
              ),
            ),
          ],
        ),

        child:
        Row(
          children: [
            // ------------------------------------------------
            // RESTAURANT IMAGE
            // ------------------------------------------------

            ClipRRect(
              borderRadius:
              BorderRadius.circular(
                12,
              ),

              child:
              SizedBox(
                width:
                85,

                height:
                85,

                child:
                imagePath.isNotEmpty
                    ? Image.asset(
                  imagePath,

                  width:
                  85,

                  height:
                  85,

                  fit:
                  BoxFit.cover,

                  errorBuilder:
                      (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return _restaurantFallback();
                  },
                )
                    : _restaurantFallback(),
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            Expanded(
              child:
              Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [
                  Text(
                    name,

                    maxLines:
                    1,

                    overflow:
                    TextOverflow
                        .ellipsis,

                    style:
                    const TextStyle(
                      color:
                      darkBlue,

                      fontSize:
                      18,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height:
                    5,
                  ),

                  Text(
                    seller.sellerEmail ??
                        "",

                    maxLines:
                    1,

                    overflow:
                    TextOverflow
                        .ellipsis,

                    style:
                    const TextStyle(
                      color:
                      Colors.grey,

                      fontSize:
                      13,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,

              color:
              mediumBlue,

              size:
              18,
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // FOOD RESULT
  // =========================================================

  Widget _foodResult(
      Items item,
      ) {
    final String title =
        item.title ??
            "Food Item";

    final String imagePath =
    getFoodImage(
      title,
    );

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                ItemDetailsScreen(
                  model:
                  item,
                ),
          ),
        );
      },

      borderRadius:
      BorderRadius.circular(
        15,
      ),

      child:
      Container(
        padding:
        const EdgeInsets.all(
          10,
        ),

        decoration:
        BoxDecoration(
          color:
          Colors.white,

          borderRadius:
          BorderRadius.circular(
            15,
          ),

          border:
          Border.all(
            color:
            const Color(
              0xFFBBDEFB,
            ),
          ),

          boxShadow: [
            BoxShadow(
              color:
              Colors.black.withOpacity(
                0.06,
              ),

              blurRadius:
              6,

              offset:
              const Offset(
                0,
                2,
              ),
            ),
          ],
        ),

        child:
        Row(
          children: [
            // ------------------------------------------------
            // FOOD IMAGE
            // ------------------------------------------------

            ClipRRect(
              borderRadius:
              BorderRadius.circular(
                12,
              ),

              child:
              SizedBox(
                width:
                85,

                height:
                85,

                child:
                Image.asset(
                  imagePath,

                  width:
                  85,

                  height:
                  85,

                  fit:
                  BoxFit.cover,

                  errorBuilder:
                      (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return _foodFallback();
                  },
                ),
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            Expanded(
              child:
              Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [
                  Text(
                    title,

                    maxLines:
                    2,

                    overflow:
                    TextOverflow
                        .ellipsis,

                    style:
                    const TextStyle(
                      color:
                      darkBlue,

                      fontSize:
                      17,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height:
                    5,
                  ),

                  Text(
                    "₹${item.price ?? 0}",

                    style:
                    const TextStyle(
                      color:
                      mediumBlue,

                      fontSize:
                      15,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height:
                    4,
                  ),

                  Text(
                    item.shortInfo ??
                        "Delicious food",

                    maxLines:
                    1,

                    overflow:
                    TextOverflow
                        .ellipsis,

                    style:
                    const TextStyle(
                      color:
                      Colors.grey,

                      fontSize:
                      13,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,

              color:
              mediumBlue,

              size:
              18,
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // RESTAURANT FALLBACK
  // =========================================================

  Widget _restaurantFallback() {
    return Container(
      decoration:
      const BoxDecoration(
        gradient:
        LinearGradient(
          colors: [
            Color(0xFF90CAF9),
            Color(0xFF42A5F5),
          ],
        ),
      ),

      child:
      const Icon(
        Icons.restaurant,

        color:
        Colors.white,

        size:
        38,
      ),
    );
  }

  // =========================================================
  // FOOD FALLBACK
  // =========================================================

  Widget _foodFallback() {
    return Container(
      color:
      lightBlue,

      child:
      const Icon(
        Icons.fastfood,

        color:
        darkBlue,

        size:
        40,
      ),
    );
  }

  // =========================================================
  // NOT FOUND
  // =========================================================

  Widget _notFound(
      String message,
      ) {
    return Padding(
      padding:
      const EdgeInsets.all(
        20,
      ),

      child:
      Center(
        child:
        Text(
          message,

          textAlign:
          TextAlign.center,

          style:
          const TextStyle(
            color:
            Colors.grey,

            fontSize:
            15,
          ),
        ),
      ),
    );
  }
}