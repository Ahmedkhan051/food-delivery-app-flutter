import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/model/items.dart';
import 'package:seller_app/splashScreen/splash_screen.dart';
import 'package:seller_app/widgets/simple_Appbar.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Items? model;

  const ItemDetailsScreen({
    super.key,
    this.model,
  });

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  static const Color darkBlue = Color(0xFF1565C0);
  static const Color mediumBlue = Color(0xFF42A5F5);
  static const Color lightBlue = Color(0xFF90CAF9);

  Future<void> deleteItem(String itemId) async {
    final String? sellerUID =
    sharedPreferences?.getString("uid");

    final String? menuId = widget.model?.menuId;

    if (sellerUID == null ||
        sellerUID.isEmpty ||
        menuId == null ||
        menuId.isEmpty ||
        itemId.isEmpty) {
      Fluttertoast.showToast(
        msg: "Unable to delete item.",
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("sellers")
          .doc(sellerUID)
          .collection("menus")
          .doc(menuId)
          .collection("items")
          .doc(itemId)
          .delete();

      await FirebaseFirestore.instance
          .collection("items")
          .doc(itemId)
          .delete();

      Fluttertoast.showToast(
        msg: "Item deleted successfully",
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MySplashScreen(),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      Fluttertoast.showToast(
        msg: "Unable to delete item",
      );
    }
  }

  Widget buildItemImage(String imagePath) {
    if (imagePath.trim().isEmpty) {
      return buildFallbackImage();
    }

    final String cleanedPath = imagePath.trim();

    // Local Flutter asset.
    if (cleanedPath.startsWith("assets/")) {
      return Image.asset(
        cleanedPath,
        width: double.infinity,
        height: 260,
        fit: BoxFit.cover,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return buildFallbackImage();
        },
      );
    }

    // Firebase Storage / other network URL.
    if (cleanedPath.startsWith("http://") ||
        cleanedPath.startsWith("https://")) {
      return Image.network(
        cleanedPath,
        width: double.infinity,
        height: 260,
        fit: BoxFit.cover,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return buildFallbackImage();
        },
      );
    }

    return buildFallbackImage();
  }

  Widget buildFallbackImage() {
    return Container(
      width: double.infinity,
      height: 260,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 70,
          color: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Items? model = widget.model;

    if (model == null) {
      return Scaffold(
        appBar: SimpleAppBar(
          title: sharedPreferences?.getString("name"),
        ),
        body: const Center(
          child: Text(
            "Item information is not available.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    final String imageUrl =
        model.thumbnailUrl?.toString().trim() ?? "";

    final String itemTitle =
    model.title?.toString().trim().isNotEmpty == true
        ? model.title!.toString().trim()
        : "Untitled Item";

    final String description =
    model.longDescription?.toString().trim().isNotEmpty == true
        ? model.longDescription!.toString().trim()
        : "No description available.";

    final String price =
        model.price?.toString() ?? "0";

    final String itemId =
        model.itemId?.toString().trim() ?? "";

    return Scaffold(
      appBar: SimpleAppBar(
        title: sharedPreferences?.getString("name"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildItemImage(imageUrl),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                itemTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: darkBlue,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: Text(
                description,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                "₹ $price",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 27,
                  color: darkBlue,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: itemId.isEmpty
                      ? null
                      : () {
                    deleteItem(itemId);
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Delete This Item",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBlue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}