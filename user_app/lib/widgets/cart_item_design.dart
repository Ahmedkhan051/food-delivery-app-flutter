import 'package:flutter/material.dart';

import '../models/items.dart';

class CartItemDesign extends StatelessWidget {
  final Items? model;
  final int? quanNumber;

  const CartItemDesign({
    super.key,
    this.model,
    this.quanNumber,
  });

  // ---------------------------------------------------------
  // GET LOCAL FOOD IMAGE
  // ---------------------------------------------------------

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
    // DEFAULT FOOD IMAGE
    // -------------------------------------------------------

    return "assets/images/homefood.jpeg";
  }

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return const SizedBox.shrink();
    }

    final int quantity = quanNumber ?? 1;

    final double price =
    (model!.price ?? 0).toDouble();

    final double itemTotal =
        price * quantity;

    final String title =
    model!.title?.trim().isNotEmpty == true
        ? model!.title!.trim()
        : "Food Item";

    final String imagePath =
    getFoodImage(title);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      child: Card(
        elevation: 2,

        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(12),
        ),

        child: Padding(
          padding: const EdgeInsets.all(10),

          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.center,

            children: [
              // ------------------------------------------------
              // FOOD IMAGE
              // ------------------------------------------------

              ClipRRect(
                borderRadius:
                BorderRadius.circular(10),

                child: Image.asset(
                  imagePath,

                  width: 100,
                  height: 110,

                  fit: BoxFit.cover,

                  errorBuilder: (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return Container(
                      width: 100,
                      height: 110,

                      color:
                      Colors.blue.shade50,

                      child: const Icon(
                        Icons.fastfood,
                        size: 45,
                        color: Colors.blue,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              // ------------------------------------------------
              // FOOD INFORMATION
              // ------------------------------------------------

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

                      style:
                      const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Row(
                      children: [
                        const Text(
                          "Quantity: ",

                          style:
                          TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),

                        Text(
                          quantity.toString(),

                          style:
                          const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    Text(
                      "Price: ₹${price.toStringAsFixed(2)}",

                      style:
                      const TextStyle(
                        color:
                        Color(0xFF1565C0),
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    Text(
                      "Item Total: ₹${itemTotal.toStringAsFixed(2)}",

                      style:
                      const TextStyle(
                        color:
                        Color(0xFF1565C0),
                        fontSize: 16,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}