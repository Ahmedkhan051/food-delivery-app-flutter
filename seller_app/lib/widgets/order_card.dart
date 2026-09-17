import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/model/items.dart';
import 'package:seller_app/widgets/order_details_screen.dart';

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

  String getFoodImage(String title) {
    final String food = title.trim().toLowerCase();

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

      return "assets/images/burger.png";
    }

    // PIZZA
    if (food.contains("pizza")) {
      if (food.contains("veg")) {
        return "assets/images/pizza2.jpeg";
      }

      if (food.contains("cheese")) {
        return "assets/images/pizza5.jpeg";
      }

      return "assets/images/pizza1.jpeg";
    }

    // CAKE
    if (food.contains("cake")) {
      if (food.contains("chocolate")) {
        return "assets/images/cake1.jpeg";
      }

      return "assets/images/cake.jpeg";
    }

    // CHOCOLATE
    if (food.contains("chocolate")) {
      return "assets/images/chokolate.jpeg";
    }

    // NON-VEG
    if (food.contains("non-veg") ||
        food.contains("non veg") ||
        food.contains("nonveg") ||
        food.contains("chicken")) {
      return "assets/images/non-veg.jpeg";
    }

    // VEG
    if (food == "vegetarian" ||
        food.startsWith("veg") ||
        food.contains(" veg") ||
        food.contains("paneer")) {
      if (food.contains("paneer")) {
        return "assets/images/veg2.jpeg";
      }

      return "assets/images/veg1.jpeg";
    }

    // PASTRIES
    if (food.contains("pastry") ||
        food.contains("pastries")) {
      if (food.contains("chocolate")) {
        return "assets/images/pastries1.jpeg";
      }

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
    if (food.contains("shake") ||
        food.contains("milkshake")) {
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
    if (food.contains("soft drink") ||
        food.contains("softdrink") ||
        food.contains("cold drink") ||
        food.contains("drink")) {
      return "assets/images/softdrink.jpeg";
    }

    // FRUITS
    if (food.contains("fruit")) {
      return "assets/images/fruit.png";
    }

    // DEFAULT
    return "assets/images/homefood.jpeg";
  }

  Widget buildItemImage(
      BuildContext context,
      String imagePath,
      String title,
      ) {
    // ---------------------------------------------
    // LOCAL FOODHUB ASSET
    // ---------------------------------------------
    if (imagePath.startsWith("assets/")) {
      return Image.asset(
        imagePath,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return buildFallbackImage(title);
        },
      );
    }

    // ---------------------------------------------
    // OLD FIREBASE / NETWORK IMAGE
    // ---------------------------------------------
    if (imagePath.startsWith("http://") ||
        imagePath.startsWith("https://")) {
      return Image.network(
        imagePath,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return buildFallbackImage(title);
        },
      );
    }

    // ---------------------------------------------
    // FALLBACK BASED ON FOOD TITLE
    // ---------------------------------------------
    return buildFallbackImage(title);
  }

  Widget buildFallbackImage(String title) {
    return Image.asset(
      getFoodImage(title),
      width: 120,
      height: 120,
      fit: BoxFit.cover,
      errorBuilder: (
          context,
          error,
          stackTrace,
          ) {
        return Container(
          width: 120,
          height: 120,
          color: Colors.grey[200],
          child: const Icon(
            Icons.fastfood_outlined,
            color: Color(0xFF42A5F5),
            size: 40,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int count = itemCount ?? 0;
    final List<DocumentSnapshot> orderData =
        data ?? [];
    final List<String> quantities =
        seperateQuantitiesList ?? [];

    final int safeCount = count
        .clamp(0, orderData.length)
        .clamp(0, quantities.length);

    if (safeCount == 0) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () {
        if (orderId == null ||
            orderId!.isEmpty) {
          return;
        }

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
      borderRadius:
      BorderRadius.circular(12),
      splashColor:
      const Color(0xFF42A5F5)
          .withValues(alpha: 0.15),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFE3F2FD),
              Colors.white,
            ],
            begin:
            Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius:
          BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: 0.06),
              blurRadius: 6,
              offset:
              const Offset(0, 2),
            ),
          ],
        ),
        padding:
        const EdgeInsets.all(10),
        margin:
        const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: safeCount,
          physics:
          const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (
              context,
              index,
              ) {
            final dynamic rawData =
            orderData[index].data();

            if (rawData
            is! Map<String, dynamic>) {
              return const SizedBox.shrink();
            }

            final Items model =
            Items.fromJson(rawData);

            return placedOrderDesignWidget(
              model,
              context,
              quantities[index],
            );
          },
        ),
      ),
    );
  }
}

Widget placedOrderDesignWidget(
    Items model,
    BuildContext context,
    String separateQuantity,
    ) {
  const Color darkBlue =
  Color(0xFF1565C0);
  const Color mediumBlue =
  Color(0xFF42A5F5);

  final String title =
  model.title
      ?.toString()
      .trim()
      .isNotEmpty ==
      true
      ? model.title!.toString().trim()
      : "Unnamed Item";

  final String thumbnailUrl =
      model.thumbnailUrl?.toString() ?? "";

  Widget buildImage() {
    if (thumbnailUrl.startsWith("assets/")) {
      return Image.asset(
        thumbnailUrl,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return buildTitleFallback(
            title,
          );
        },
      );
    }

    if (thumbnailUrl.startsWith(
      "http://",
    ) ||
        thumbnailUrl.startsWith(
          "https://",
        )) {
      return Image.network(
        thumbnailUrl,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return buildTitleFallback(
            title,
          );
        },
      );
    }

    return buildTitleFallback(title);
  }

  return Container(
    width:
    MediaQuery.of(context).size.width,
    height: 120,
    margin:
    const EdgeInsets.only(
      bottom: 4,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius:
      BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius:
          const BorderRadius.only(
            topLeft:
            Radius.circular(8),
            bottomLeft:
            Radius.circular(8),
          ),
          child: buildImage(),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,
                      style:
                      const TextStyle(
                        color:
                        Colors.black87,
                        fontSize: 16,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  const Text(
                    "₹",
                    style:
                    TextStyle(
                      fontSize: 16,
                      color:
                      darkBlue,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  Text(
                    model.price
                        ?.toString() ??
                        "0",
                    style:
                    const TextStyle(
                      color:
                      darkBlue,
                      fontSize: 17,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),

              const SizedBox(
                height: 12,
              ),

              Row(
                children: [
                  const Text(
                    "x",
                    style:
                    TextStyle(
                      color:
                      Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    separateQuantity,
                    style:
                    const TextStyle(
                      color:
                      darkBlue,
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildTitleFallback(
    String title,
    ) {
  final String food =
  title.trim().toLowerCase();

  String imagePath =
      "assets/images/homefood.jpeg";

  if (food.contains("burger")) {
    imagePath =
    "assets/images/burger1.jpeg";
  } else if (food.contains("pizza")) {
    imagePath =
    "assets/images/pizza1.jpeg";
  } else if (food.contains("cake")) {
    imagePath =
    "assets/images/cake.jpeg";
  } else if (food.contains("fruit")) {
    imagePath =
    "assets/images/fruit.png";
  } else if (food.contains("momo")) {
    imagePath =
    "assets/images/momos.jpeg";
  } else if (food.contains("samosa")) {
    imagePath =
    "assets/images/samosa.jpeg";
  } else if (food.contains("shake")) {
    imagePath =
    "assets/images/shake.jpeg";
  }

  return Image.asset(
    imagePath,
    width: 120,
    height: 120,
    fit: BoxFit.cover,
    errorBuilder: (
        context,
        error,
        stackTrace,
        ) {
      return Container(
        width: 120,
        height: 120,
        color: Colors.grey[200],
        child: const Icon(
          Icons.fastfood_outlined,
          color: Color(0xFF42A5F5),
          size: 40,
        ),
      );
    },
  );
}