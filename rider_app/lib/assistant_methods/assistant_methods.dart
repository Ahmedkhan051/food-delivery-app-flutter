import 'package:cloud_firestore/cloud_firestore.dart';

import '../global/global.dart';

// =============================================================
// SEPARATE ORDER ITEM IDS
// =============================================================
//
// Expected order item format:
//
// itemId:quantity
//
// Example:
// 123ABC:2
//
// Only the item ID portion is returned.
//
// Invalid/empty values are ignored.
//

List<String> separateOrderItemIds(
    dynamic orderId,
    ) {
  final List<String> separateItemIdsList = [];

  if (orderId is! List) {
    return separateItemIdsList;
  }

  for (final dynamic value in orderId) {
    final String item = value.toString().trim();

    if (item.isEmpty ||
        item == "garbageValue") {
      continue;
    }

    final int position =
    item.lastIndexOf(":");

    final String itemId =
    position != -1
        ? item.substring(0, position).trim()
        : item;

    if (itemId.isNotEmpty) {
      separateItemIdsList.add(itemId);
    }
  }

  return separateItemIdsList;
}

// =============================================================
// SEPARATE CART ITEM IDS
// =============================================================

List<String> separateItemIds() {
  final List<String> separateItemIdsList = [];

  final List<String>? cart =
  sharedPreferences?.getStringList(
    "userCart",
  );

  if (cart == null || cart.isEmpty) {
    return separateItemIdsList;
  }

  for (final String value in cart) {
    final String item = value.trim();

    if (item.isEmpty ||
        item == "garbageValue") {
      continue;
    }

    final int position =
    item.lastIndexOf(":");

    final String itemId =
    position != -1
        ? item.substring(0, position).trim()
        : item;

    if (itemId.isNotEmpty) {
      separateItemIdsList.add(itemId);
    }
  }

  return separateItemIdsList;
}

// =============================================================
// SEPARATE ORDER ITEM QUANTITIES
// =============================================================
//
// This parser follows exactly the same valid-item list as
// separateOrderItemIds(), so IDs and quantities stay aligned.
//
// Example:
//
// 123ABC:2  -> 2
// 456DEF:1  -> 1
//
// Invalid entries are ignored.
//

List<String> separateOrderItemQuantities(
    dynamic orderId,
    ) {
  final List<String> quantities = [];

  if (orderId is! List) {
    return quantities;
  }

  for (final dynamic value in orderId) {
    final String item = value.toString().trim();

    if (item.isEmpty ||
        item == "garbageValue") {
      continue;
    }

    final int position =
    item.lastIndexOf(":");

    if (position == -1) {
      continue;
    }

    final String quantity =
    item.substring(position + 1).trim();

    final int? quantityNumber =
    int.tryParse(quantity);

    if (quantityNumber == null) {
      continue;
    }

    quantities.add(
      quantityNumber.toString(),
    );
  }

  return quantities;
}

// =============================================================
// SEPARATE CART ITEM QUANTITIES
// =============================================================

List<int> separateItemQuantities() {
  final List<int> quantities = [];

  final List<String>? cart =
  sharedPreferences?.getStringList(
    "userCart",
  );

  if (cart == null || cart.isEmpty) {
    return quantities;
  }

  for (final String value in cart) {
    final String item = value.trim();

    if (item.isEmpty ||
        item == "garbageValue") {
      continue;
    }

    final int position =
    item.lastIndexOf(":");

    if (position == -1) {
      continue;
    }

    final String quantity =
    item.substring(position + 1).trim();

    final int? quantityNumber =
    int.tryParse(quantity);

    if (quantityNumber != null) {
      quantities.add(quantityNumber);
    }
  }

  return quantities;
}

// =============================================================
// CLEAR CART
// =============================================================

Future<void> clearCartNow(
    dynamic context,
    ) async {
  final List<String> emptyList = [
    "garbageValue",
  ];

  await sharedPreferences?.setStringList(
    "userCart",
    emptyList,
  );

  final String? uid =
      firebaseAuth.currentUser?.uid;

  if (uid == null || uid.isEmpty) {
    return;
  }

  try {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
      "userCart": emptyList,
    });
  } catch (_) {
    // Keep local cart cleared even if the
    // Firestore update cannot be completed.
  }
}