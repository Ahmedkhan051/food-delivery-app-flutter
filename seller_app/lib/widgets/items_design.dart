import 'package:flutter/material.dart';
import 'package:seller_app/mainScreens/item_detail_screen.dart';
import 'package:seller_app/model/items.dart';

class ItemDesignWidget extends StatefulWidget {
  final Items? model;
  final BuildContext? context;

  const ItemDesignWidget({
    super.key,
    this.model,
    this.context,
  });

  @override
  State<ItemDesignWidget> createState() =>
      _ItemDesignWidgetState();
}

class _ItemDesignWidgetState extends State<ItemDesignWidget> {
  static const Color darkBlue = Color(0xFF1565C0);
  static const Color mediumBlue = Color(0xFF42A5F5);
  static const Color lightBlue = Color(0xFFE3F2FD);

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
        food.contains(" veg") ||
        food.startsWith("veg") ||
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

    // FRUIT
    if (food.contains("fruit")) {
      return "assets/images/fruit.png";
    }

    // DEFAULT
    return "assets/images/homefood.jpeg";
  }

  Widget buildImage(
      String imagePath,
      String title,
      ) {
    if (imagePath.isNotEmpty &&
        imagePath.startsWith("assets/")) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
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
            return buildPlaceholder();
          },
        ),
      );
    }

    if (imagePath.startsWith("http://") ||
        imagePath.startsWith("https://")) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imagePath,
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (
              context,
              error,
              stackTrace,
              ) {
            return buildFallbackAsset(title);
          },
        ),
      );
    }

    return buildFallbackAsset(title);
  }

  Widget buildFallbackAsset(String title) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        getFoodImage(title),
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return buildPlaceholder();
        },
      ),
    );
  }

  Widget buildPlaceholder() {
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
          Icons.fastfood_outlined,
          color: Colors.white,
          size: 65,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Items? item = widget.model;

    if (item == null) {
      return const SizedBox.shrink();
    }

    final String title =
    item.title?.toString().trim().isNotEmpty == true
        ? item.title!.toString().trim()
        : "Unnamed Item";

    final String shortInfo =
    item.shortInfo?.toString().trim().isNotEmpty == true
        ? item.shortInfo!.toString().trim()
        : "No description available";

    final String thumbnailUrl =
        item.thumbnailUrl?.toString() ?? "";

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailsScreen(
              model: item,
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
              const Divider(
                height: 4,
                thickness: 3,
                color: Color(0xFFE0E0E0),
              ),

              const SizedBox(height: 8),

              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: darkBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              buildImage(
                thumbnailUrl,
                title,
              ),

              const SizedBox(height: 8),

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Text(
                  shortInfo,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Divider(
                height: 4,
                thickness: 2,
                color: Color(0xFFE0E0E0),
              ),

              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}