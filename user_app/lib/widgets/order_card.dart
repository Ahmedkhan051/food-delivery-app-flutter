import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/mainScreens/order_details_screen.dart';
import 'package:user_app/models/items.dart';

class OrderCard extends StatelessWidget {
  final int? itemCount;
  final List<DocumentSnapshot>? data;
  final String? orderId;
  final List<String>? seperateQuantitiesList;

  const OrderCard({
    super.key,
    this.itemCount,
    this.data,
    this.orderId,
    this.seperateQuantitiesList,
  });

  @override
  Widget build(BuildContext context) {
    final List<DocumentSnapshot> documents = data ?? [];
    final List<String> quantities =
        seperateQuantitiesList ?? [];

    final int count =
        itemCount ?? documents.length;

    if (documents.isEmpty || count == 0) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: orderId == null || orderId!.isEmpty
          ? null
          : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrderDetailsScreen(
                  orderId: orderId,
                ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(15),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 7,
        ),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.receipt_long,
                    color: Color(0xFF1565C0),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "FoodHub Order",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        Color(0xFF1565C0),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.grey,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              const Divider(height: 1),

              const SizedBox(height: 6),

              ListView.builder(
                itemCount: documents.length,
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                itemBuilder:
                    (context, index) {
                  final Items model =
                  Items.fromJson(
                    documents[index].data()
                    as Map<String, dynamic>,
                  );

                  final String quantity =
                  index < quantities.length
                      ? quantities[index]
                      : "1";

                  return PlacedOrderDesignWidget(
                    model: model,
                    quantity: quantity,
                  );
                },
              ),

              const SizedBox(height: 5),

              const Align(
                alignment:
                Alignment.centerRight,
                child: Text(
                  "Tap to view order details",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlacedOrderDesignWidget
    extends StatelessWidget {
  final Items model;
  final String quantity;

  const PlacedOrderDesignWidget({
    super.key,
    required this.model,
    required this.quantity,
  });

  // ---------------------------------------------------------
  // LOCAL FOOD IMAGE MAPPING
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

  @override
  Widget build(BuildContext context) {
    final String title =
    model.title?.trim().isNotEmpty == true
        ? model.title!.trim()
        : "Food Item";

    final int price =
        model.price ?? 0;

    final String imagePath =
    getFoodImage(title);

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius:
        BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // ---------------------------------------------------
          // LOCAL FOOD IMAGE
          // ---------------------------------------------------

          ClipRRect(
            borderRadius:
            BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              width: 85,
              height: 85,
              fit: BoxFit.cover,
              errorBuilder: (
                  context,
                  error,
                  stackTrace,
                  ) {
                return _buildPlaceholder();
              },
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "₹$price",
                  style: const TextStyle(
                    color:
                    Color(0xFF1565C0),
                    fontSize: 15,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  "Quantity: $quantity",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
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
  // IMAGE FALLBACK
  // ---------------------------------------------------------

  Widget _buildPlaceholder() {
    return Container(
      width: 85,
      height: 85,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF90CAF9),
            Color(0xFF42A5F5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
        BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.fastfood,
        color: Colors.white,
        size: 38,
      ),
    );
  }
}