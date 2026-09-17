import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:user_app/mainScreens/address_screen.dart';

class CartScreen extends StatefulWidget {
  final String? sellerUID;

  const CartScreen({
    super.key,
    this.sellerUID,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color deepBlue = Color(0xFF1565C0);
  static const Color mediumBlue = Color(0xFF42A5F5);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color pageBackground = Color(0xFFF8FBFF);

  // ============================================================
  // STORAGE KEYS
  // ============================================================

  static const String cartDetailsKey = 'foodHubCartDetails';
  static const String userCartKey = 'userCart';

  // ============================================================
  // CART DATA
  // ============================================================

  List<Map<String, dynamic>> cartItems = [];

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  // ============================================================
  // LOAD CART
  // ============================================================

  Future<void> loadCart() async {
    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final List<String> savedItems =
          prefs.getStringList(cartDetailsKey) ?? <String>[];

      final List<Map<String, dynamic>> loadedItems =
      <Map<String, dynamic>>[];

      for (final String item in savedItems) {
        try {
          final dynamic decoded = jsonDecode(item);

          if (decoded is Map) {
            loadedItems.add(
              Map<String, dynamic>.from(decoded),
            );
          }
        } catch (error) {
          debugPrint(
            'Cart item decode error: $error',
          );
        }
      }

      if (!mounted) {
        return;
      }

      setState(() {
        cartItems = loadedItems;
      });
    } catch (error) {
      debugPrint(
        'Unable to load cart: $error',
      );
    }
  }

  // ============================================================
  // CLEAR CART
  // ============================================================

  Future<void> clearCart() async {
    if (cartItems.isEmpty) {
      return;
    }

    final bool? shouldClear = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Clear Cart',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to remove all items from your cart?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    if (shouldClear != true) {
      return;
    }

    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      await prefs.remove(cartDetailsKey);

      await prefs.setStringList(
        userCartKey,
        <String>['garbageValue'],
      );

      if (!mounted) {
        return;
      }

      setState(() {
        cartItems.clear();
      });

      Fluttertoast.showToast(
        msg: 'Cart has been cleared.',
      );
    } catch (error) {
      debugPrint(
        'Unable to clear cart: $error',
      );

      Fluttertoast.showToast(
        msg: 'Unable to clear cart.',
      );
    }
  }

  // ============================================================
  // PRICE HELPERS
  // ============================================================

  double _getPrice(Map<String, dynamic> item) {
    return double.tryParse(
      item['price']?.toString() ?? '0',
    ) ??
        0;
  }

  int _getQuantity(Map<String, dynamic> item) {
    final int quantity =
        int.tryParse(
          item['quantity']?.toString() ?? '1',
        ) ??
            1;

    return quantity < 1 ? 1 : quantity;
  }

  // ============================================================
  // TOTAL AMOUNT
  // ============================================================

  double get totalAmount {
    double total = 0;

    for (final Map<String, dynamic> item in cartItems) {
      final double price = _getPrice(item);
      final int quantity = _getQuantity(item);

      total += price * quantity;
    }

    return total;
  }

  // ============================================================
  // TOTAL ITEMS
  // ============================================================

  int get totalItems {
    int total = 0;

    for (final Map<String, dynamic> item in cartItems) {
      total += _getQuantity(item);
    }

    return total;
  }

  // ============================================================
  // SELLER / RESTAURANT INFORMATION
  // ============================================================

  Set<String> get cartSellerUIDs {
    final Set<String> sellerUIDs = <String>{};

    for (final Map<String, dynamic> item in cartItems) {
      final String sellerUID =
          item['sellerUID']?.toString().trim() ?? '';

      if (sellerUID.isNotEmpty) {
        sellerUIDs.add(sellerUID);
      }
    }

    return sellerUIDs;
  }

  bool get hasMissingSellerUID {
    for (final Map<String, dynamic> item in cartItems) {
      final String sellerUID =
          item['sellerUID']?.toString().trim() ?? '';

      if (sellerUID.isEmpty) {
        return true;
      }
    }

    return false;
  }

  // ============================================================
  // GET ITEM ID
  // ============================================================

  String _getItemId(Map<String, dynamic> item) {
    final String localCartId =
        item['localCartId']?.toString().trim() ?? '';

    if (localCartId.isNotEmpty) {
      return localCartId;
    }

    return item['itemId']?.toString().trim() ?? '';
  }

  // ============================================================
  // REMOVE SINGLE ITEM
  // ============================================================

  Future<void> removeItem(int index) async {
    if (index < 0 || index >= cartItems.length) {
      return;
    }

    final Map<String, dynamic> removedItem =
    cartItems[index];

    final String removedId =
    _getItemId(removedItem);

    if (removedId.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Unable to identify this item.',
      );
      return;
    }

    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      // ----------------------------------------------------------
      // Remove from memory first
      // ----------------------------------------------------------

      setState(() {
        cartItems.removeAt(index);
      });

      // ----------------------------------------------------------
      // Remove from detailed cart storage
      // ----------------------------------------------------------

      final List<String> savedItems =
          prefs.getStringList(cartDetailsKey) ??
              <String>[];

      savedItems.removeWhere(
            (String entry) {
          try {
            final dynamic decoded =
            jsonDecode(entry);

            if (decoded is! Map) {
              return false;
            }

            final Map<String, dynamic> item =
            Map<String, dynamic>.from(decoded);

            final String id =
            _getItemId(item);

            return id == removedId;
          } catch (error) {
            debugPrint(
              'Cart item removal decode error: $error',
            );

            return false;
          }
        },
      );

      await prefs.setStringList(
        cartDetailsKey,
        savedItems,
      );

      // ----------------------------------------------------------
      // Rebuild userCart
      // ----------------------------------------------------------

      await _rebuildUserCart(prefs);

      Fluttertoast.showToast(
        msg: 'Item removed from cart.',
      );
    } catch (error) {
      debugPrint(
        'Unable to remove item: $error',
      );

      Fluttertoast.showToast(
        msg: 'Unable to remove item.',
      );

      // Reload the cart in case local storage was not updated.
      await loadCart();
    }
  }

  // ============================================================
  // REBUILD userCart
  // ============================================================

  Future<void> _rebuildUserCart(
      SharedPreferences prefs,
      ) async {
    final List<String> rebuiltUserCart =
    <String>[];

    for (final Map<String, dynamic> item in cartItems) {
      final String id = _getItemId(item);
      final int quantity = _getQuantity(item);

      if (id.isNotEmpty) {
        rebuiltUserCart.add(
          '$id:$quantity',
        );
      }
    }

    if (rebuiltUserCart.isEmpty) {
      rebuiltUserCart.add(
        'garbageValue',
      );
    }

    await prefs.setStringList(
      userCartKey,
      rebuiltUserCart,
    );
  }

  // ============================================================
  // CHECKOUT
  // ============================================================

  Future<void> openCheckout() async {
    if (cartItems.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Your cart is empty.',
      );
      return;
    }

    // ----------------------------------------------------------
    // Find all restaurants represented in the cart
    // ----------------------------------------------------------

    final Set<String> sellerUIDs =
        cartSellerUIDs;

    // ----------------------------------------------------------
    // Multiple restaurants
    // ----------------------------------------------------------

    if (sellerUIDs.length > 1) {
      Fluttertoast.showToast(
        msg:
        'Please checkout items from one restaurant at a time.',
      );
      return;
    }

    // ----------------------------------------------------------
    // Mixed old/new cart data
    // ----------------------------------------------------------

    if (sellerUIDs.isNotEmpty &&
        hasMissingSellerUID) {
      Fluttertoast.showToast(
        msg:
        'Restaurant information is missing for one or more items.',
      );
      return;
    }

    // ----------------------------------------------------------
    // Determine seller UID
    //
    // New cart items:
    //   sellerUID stored inside each item.
    //
    // Old cart items:
    //   use widget.sellerUID as fallback.
    // ----------------------------------------------------------

    final String sellerUID =
    sellerUIDs.isNotEmpty
        ? sellerUIDs.first
        : (widget.sellerUID?.trim() ?? '');

    if (sellerUID.isEmpty) {
      Fluttertoast.showToast(
        msg:
        'Restaurant information is not available. Please add the food again.',
      );
      return;
    }

    // ----------------------------------------------------------
    // Open Address Screen
    // ----------------------------------------------------------

    if (!mounted) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AddressScreen(
            totolAmmount: totalAmount,
            sellerUID: sellerUID,
          );
        },
      ),
    );
  }

  // ============================================================
  // FOOD IMAGE MAPPING
  // ============================================================

  String getFoodImage(String title) {
    final String food =
    title.trim().toLowerCase();

    // ----------------------------------------------------------
    // PIZZA
    // ----------------------------------------------------------

    if (food.contains('pizza')) {
      if (food.contains('margerite') ||
          food.contains('margherita')) {
        return 'assets/images/pizza1.jpeg';
      }

      if (food.contains('cheese')) {
        return 'assets/images/pizza2.jpeg';
      }

      if (food.contains('veg')) {
        return 'assets/images/pizza5.jpeg';
      }

      if (food.contains('pepper')) {
        return 'assets/images/pizza6.jpeg';
      }

      if (food.contains('farm')) {
        return 'assets/images/pizza7.jpeg';
      }

      if (food.contains('corn')) {
        return 'assets/images/pizza8.jpeg';
      }

      if (food.contains('special')) {
        return 'assets/images/pizza9.jpeg';
      }

      if (food.contains('deluxe')) {
        return 'assets/images/pizza10.jpeg';
      }

      return 'assets/images/piza4.jpeg';
    }

    // ----------------------------------------------------------
    // BURGER
    // ----------------------------------------------------------

    if (food.contains('burger')) {
      if (food.contains('chicken')) {
        return 'assets/images/burger1.jpeg';
      }

      if (food.contains('veg')) {
        return 'assets/images/burger2.jpeg';
      }

      if (food.contains('cheese')) {
        return 'assets/images/burger6.jpeg';
      }

      if (food.contains('special')) {
        return 'assets/images/burger4.jpeg';
      }

      return 'assets/images/burger.png';
    }

    // ----------------------------------------------------------
    // CAKE
    // ----------------------------------------------------------

    if (food.contains('cake')) {
      if (food.contains('chocolate')) {
        return 'assets/images/cake1.jpeg';
      }

      if (food.contains('vanilla')) {
        return 'assets/images/cake2.jpeg';
      }

      if (food.contains('red')) {
        return 'assets/images/cake3.jpeg';
      }

      if (food.contains('black')) {
        return 'assets/images/cake4.jpeg';
      }

      if (food.contains('strawberry')) {
        return 'assets/images/cake5.jpeg';
      }

      if (food.contains('fruit')) {
        return 'assets/images/cake6.jpeg';
      }

      return 'assets/images/cake.jpeg';
    }

    // ----------------------------------------------------------
    // CHOCOLATE
    // ----------------------------------------------------------

    if (food.contains('chocolate') ||
        food.contains('chokolate')) {
      return 'assets/images/chocolate.jpeg';
    }

    // ----------------------------------------------------------
    // NON-VEG
    // ----------------------------------------------------------

    if (food.contains('non-veg') ||
        food.contains('non veg') ||
        food.contains('nonveg') ||
        food.contains('chicken') ||
        food.contains('mutton') ||
        food.contains('fish') ||
        food.contains('meat')) {
      if (food.contains('chicken')) {
        return 'assets/images/nonveg1.jpeg';
      }

      if (food.contains('fish')) {
        return 'assets/images/nonveg3.jpeg';
      }

      if (food.contains('mutton')) {
        return 'assets/images/nonveg4.jpeg';
      }

      return 'assets/images/non-veg.jpeg';
    }

    // ----------------------------------------------------------
    // VEG
    // ----------------------------------------------------------

    if (food.contains('veg') ||
        food.contains('vegetable') ||
        food.contains('paneer')) {
      if (food.contains('paneer')) {
        return 'assets/images/veg2.jpeg';
      }

      if (food.contains('masala')) {
        return 'assets/images/veg4.jpeg';
      }

      return 'assets/images/veg1.jpeg';
    }

    // ----------------------------------------------------------
    // PASTRY
    // ----------------------------------------------------------

    if (food.contains('pastry') ||
        food.contains('pastries')) {
      if (food.contains('chocolate')) {
        return 'assets/images/pastries1.jpeg';
      }

      if (food.contains('special')) {
        return 'assets/images/pastries2.jpeg';
      }

      return 'assets/images/pastries.jpeg';
    }

    // ----------------------------------------------------------
    // SAMOSA
    // ----------------------------------------------------------

    if (food.contains('samosa')) {
      return 'assets/images/samosa.jpeg';
    }

    // ----------------------------------------------------------
    // MOMOS
    // ----------------------------------------------------------

    if (food.contains('momo')) {
      return 'assets/images/momos.jpeg';
    }

    // ----------------------------------------------------------
    // SHAKE
    // ----------------------------------------------------------

    if (food.contains('shake') ||
        food.contains('milkshake')) {
      return 'assets/images/shake.jpeg';
    }

    // ----------------------------------------------------------
    // GULAB JAMUN
    // ----------------------------------------------------------

    if (food.contains('gulab') ||
        food.contains('jamun')) {
      return 'assets/images/gulabjamun.jpeg';
    }

    // ----------------------------------------------------------
    // JALEBI
    // ----------------------------------------------------------

    if (food.contains('jalebi')) {
      return 'assets/images/jalebi.jpeg';
    }

    // ----------------------------------------------------------
    // KAJU BARFI
    // ----------------------------------------------------------

    if (food.contains('kaju') ||
        food.contains('barfi')) {
      return 'assets/images/kajubarfi.jpeg';
    }

    // ----------------------------------------------------------
    // LADDOO
    // ----------------------------------------------------------

    if (food.contains('laddu') ||
        food.contains('laddoo')) {
      return 'assets/images/laddoo.jpeg';
    }

    // ----------------------------------------------------------
    // SOFT DRINK
    // ----------------------------------------------------------

    if (food.contains('softdrink') ||
        food.contains('soft drink') ||
        food.contains('cold drink') ||
        food.contains('drink')) {
      return 'assets/images/softdrink.jpeg';
    }

    // ----------------------------------------------------------
    // FRUIT
    // ----------------------------------------------------------

    if (food.contains('fruit')) {
      return 'assets/images/fruit.png';
    }

    // ----------------------------------------------------------
    // DINING
    // ----------------------------------------------------------

    if (food.contains('dining')) {
      return 'assets/images/diningfood.jpeg';
    }

    // ----------------------------------------------------------
    // DISCOUNT
    // ----------------------------------------------------------

    if (food.contains('discount')) {
      return 'assets/images/discountfood.jpeg';
    }

    // ----------------------------------------------------------
    // DELIVERY
    // ----------------------------------------------------------

    if (food.contains('delivery')) {
      return 'assets/images/deliveryfood.jpeg';
    }

    // ----------------------------------------------------------
    // DEFAULT
    // ----------------------------------------------------------

    return 'assets/images/homefood.jpeg';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: mediumBlue,
        elevation: 3,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
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
          'My Cart',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),

        actions: <Widget>[
          if (cartItems.isNotEmpty)
            IconButton(
              onPressed: clearCart,
              tooltip: 'Clear cart',
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.white,
              ),
            ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: cartItems.isEmpty
          ? _emptyCart()
          : Column(
        children: <Widget>[
          // ------------------------------------------------
          // TOTAL CARD
          // ------------------------------------------------

          _totalCard(),

          // ------------------------------------------------
          // ITEM COUNT
          // ------------------------------------------------

          _itemCount(),

          // ------------------------------------------------
          // CART ITEMS
          // ------------------------------------------------

          Expanded(
            child: ListView.builder(
              physics:
              const BouncingScrollPhysics(),
              padding:
              const EdgeInsets.fromLTRB(
                12,
                8,
                12,
                100,
              ),
              itemCount: cartItems.length,
              itemBuilder:
                  (
                  BuildContext context,
                  int index,
                  ) {
                return _cartItemCard(
                  cartItems[index],
                  index,
                );
              },
            ),
          ),
        ],
      ),

      // ========================================================
      // BOTTOM BUTTONS
      // ========================================================

      bottomNavigationBar: cartItems.isEmpty
          ? null
          : _bottomButtons(),
    );
  }

  // ============================================================
  // TOTAL CARD
  // ============================================================

  Widget _totalCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        12,
        12,
        12,
        8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: Text(
              'Total',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: deepBlue,
              ),
            ),
          ),
          Text(
            '₹${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: deepBlue,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ITEM COUNT
  // ============================================================

  Widget _itemCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '$totalItems item(s) in cart',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY CART
  // ============================================================

  Widget _emptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Color(0xFF90CAF9),
            ),

            const SizedBox(height: 18),

            const Text(
              'Your cart is empty',
              style: TextStyle(
                color: deepBlue,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Add some delicious food to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),

            OutlinedButton.icon(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
              label: const Text(
                'BACK TO FOOD',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CART ITEM CARD
  // ============================================================

  Widget _cartItemCard(
      Map<String, dynamic> item,
      int index,
      ) {
    final String title =
    item['title']?.toString().trim().isNotEmpty ==
        true
        ? item['title'].toString()
        : 'Food Item';

    final double price = _getPrice(item);
    final int quantity = _getQuantity(item);

    final double itemTotal =
        price * quantity;

    final String imagePath =
    getFoodImage(title);

    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.08,
            ),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: <Widget>[
            // ----------------------------------------------------
            // FOOD IMAGE
            // ----------------------------------------------------

            ClipRRect(
              borderRadius:
              BorderRadius.circular(12),
              child: SizedBox(
                width: 95,
                height: 95,
                child: Image.asset(
                  imagePath,
                  width: 95,
                  height: 95,
                  fit: BoxFit.cover,

                  errorBuilder: (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                      ) {
                    return Container(
                      color: lightBlue,
                      child: const Icon(
                        Icons.fastfood,
                        size: 45,
                        color: deepBlue,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ----------------------------------------------------
            // FOOD DETAILS
            // ----------------------------------------------------

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 2,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                      color: deepBlue,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    '₹${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.bold,
                      color: mediumBlue,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Quantity: $quantity',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Total: ₹${itemTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // ----------------------------------------------------
            // DELETE BUTTON
            // ----------------------------------------------------

            IconButton(
              onPressed: () {
                removeItem(index);
              },
              tooltip: 'Remove item',
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM BUTTONS
  // ============================================================

  Widget _bottomButtons() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 8,
              color: Colors.black.withValues(
                alpha: 0.12,
              ),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            // ----------------------------------------------------
            // CLEAR CART
            // ----------------------------------------------------

            Expanded(
              child: OutlinedButton.icon(
                onPressed: clearCart,
                icon: const Icon(
                  Icons.delete_outline,
                ),
                label: const Text(
                  'Clear Cart',
                ),
                style:
                OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(
                    color: Colors.red,
                  ),
                  minimumSize:
                  const Size(0, 52),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // ----------------------------------------------------
            // CHECKOUT
            // ----------------------------------------------------

            Expanded(
              child: ElevatedButton.icon(
                onPressed: openCheckout,
                icon: const Icon(
                  Icons.arrow_forward,
                ),
                label: const Text(
                  'Checkout',
                  style: TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                style:
                ElevatedButton.styleFrom(
                  backgroundColor: deepBlue,
                  foregroundColor:
                  Colors.white,
                  minimumSize:
                  const Size(0, 52),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}