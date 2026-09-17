import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../mainScreens/order_details_screen.dart';
import '../models/items.dart';

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
    final int count = itemCount ?? 0;

    if (count == 0 ||
        data == null ||
        data!.isEmpty ||
        orderId == null) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailsScreen(
              orderId: orderId,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFE3F2FD),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFFBBDEFB),
          ),
        ),
        child: Column(
          children: List.generate(
            count > data!.length ? data!.length : count,
                (index) {
              final Items model = Items.fromJson(
                data![index].data() as Map<String, dynamic>,
              );

              final String quantity =
              seperateQuantitiesList != null &&
                  index < seperateQuantitiesList!.length
                  ? seperateQuantitiesList![index]
                  : "1";

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 8,
                ),
                child: placedOrderDesignWidget(
                  model,
                  context,
                  quantity,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget placedOrderDesignWidget(
    Items model,
    BuildContext context,
    String separateQuantityList,
    ) {
  final String imagePath =
      model.thumbnailUrl?.trim() ?? "";

  Widget productImage;

  if (imagePath.startsWith("assets/")) {
    productImage = Image.asset(
      imagePath,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) {
        return Container(
          width: 100,
          height: 100,
          color: Colors.grey.shade200,
          child: const Icon(
            Icons.fastfood,
            size: 45,
            color: Colors.grey,
          ),
        );
      },
    );
  } else if (imagePath.startsWith("http://") ||
      imagePath.startsWith("https://")) {
    productImage = Image.network(
      imagePath,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) {
        return Container(
          width: 100,
          height: 100,
          color: Colors.grey.shade200,
          child: const Icon(
            Icons.fastfood,
            size: 45,
            color: Colors.grey,
          ),
        );
      },
    );
  } else {
    productImage = Container(
      width: 100,
      height: 100,
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.fastfood,
        size: 45,
        color: Colors.grey,
      ),
    );
  }

  return Container(
    width: double.infinity,
    constraints: const BoxConstraints(
      minHeight: 110,
    ),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: productImage,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.title?.isNotEmpty == true
                    ? model.title!
                    : "Food Item",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "₹${model.price ?? 0}",
                style: const TextStyle(
                  color: Color(0xFF1565C0),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Text(
                    "Quantity: ",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "x$separateQuantityList",
                    style: const TextStyle(
                      color: Color(0xFF1565C0),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
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