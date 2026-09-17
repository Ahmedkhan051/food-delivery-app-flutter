import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/global/global.dart';

/// Extract item IDs from an order's productIds list.
///
/// Supports both:
///   "itemId"
///   "itemId:2"
///
/// When no quantity is included, the item ID is returned as-is.
List<String> separateOrderItemIds(dynamic orderId) {
  if (orderId is! List) {
    return <String>[];
  }

  final List<String> separateItemIdsList = [];

  for (final dynamic rawItem in orderId) {
    final String item = rawItem.toString().trim();

    if (item.isEmpty) {
      continue;
    }

    final int position = item.lastIndexOf(":");

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

/// Extract item IDs from the local user cart.
///
/// The cart uses "garbageValue" at index 0, so that value is skipped.
///
/// Supports:
///   "itemId:2"
///   "itemId"
List<String> separateItemIds() {
  final List<String> cartItems =
      sharedPreferences?.getStringList("userCart") ?? [];

  final List<String> separateItemIdsList = [];

  for (final String item in cartItems) {
    if (item == "garbageValue") {
      continue;
    }

    final String cleanedItem = item.trim();

    if (cleanedItem.isEmpty) {
      continue;
    }

    final int position =
    cleanedItem.lastIndexOf(":");

    final String itemId =
    position != -1
        ? cleanedItem
        .substring(0, position)
        .trim()
        : cleanedItem;

    if (itemId.isNotEmpty) {
      separateItemIdsList.add(itemId);
    }
  }

  return separateItemIdsList;
}

/// Extract quantities from an order's productIds.
///
/// IMPORTANT:
/// Order productIds start at index 0.
///
/// Supports:
///   "itemId:2" → 2
///   "itemId"   → 1
///
/// This fixes orders created by the current User App,
/// where a product ID can be stored without ":quantity".
List<String> separateOrderItemQuantities(
    dynamic orderId,
    ) {
  if (orderId is! List) {
    return <String>[];
  }

  final List<String> separateItemQuantityList = [];

  for (final dynamic rawItem in orderId) {
    final String item = rawItem.toString().trim();

    if (item.isEmpty) {
      continue;
    }

    final int position =
    item.lastIndexOf(":");

    // No ":quantity" means one item.
    if (position == -1) {
      separateItemQuantityList.add("1");
      continue;
    }

    final String quantityText =
    item.substring(position + 1).trim();

    final int? quantity =
    int.tryParse(quantityText);

    if (quantity != null && quantity > 0) {
      separateItemQuantityList.add(
        quantity.toString(),
      );
    } else {
      // Invalid/missing quantity:
      // safely treat it as one item.
      separateItemQuantityList.add("1");
    }
  }

  return separateItemQuantityList;
}

/// Extract quantities from the local user cart.
///
/// The cart uses "garbageValue" at index 0,
/// therefore this method intentionally starts at index 1.
List<int> separateItemQuantities() {
  final List<String> defaultItemList =
      sharedPreferences?.getStringList("userCart") ?? [];

  final List<int> separateItemQuantityList = [];

  for (int i = 1;
  i < defaultItemList.length;
  i++) {
    final String item =
    defaultItemList[i].trim();

    if (item.isEmpty) {
      continue;
    }

    final List<String> listItemCharacters =
    item.split(":");

    if (listItemCharacters.length > 1) {
      final int? quantity =
      int.tryParse(
        listItemCharacters[1].trim(),
      );

      if (quantity != null &&
          quantity > 0) {
        separateItemQuantityList.add(
          quantity,
        );
      } else {
        separateItemQuantityList.add(1);
      }
    } else {
      // Item without an explicit quantity.
      separateItemQuantityList.add(1);
    }
  }

  return separateItemQuantityList;
}

/// Clears the local cart and attempts to
/// clear the user's Firestore cart as well.
Future<void> clearCartNow(
    BuildContext context,
    ) async {
  final List<String> emptyList = [
    'garbageValue',
  ];

  // Clear local cart first.
  await sharedPreferences?.setStringList(
    "userCart",
    emptyList,
  );

  final String? userUID =
      firebaseAuth.currentUser?.uid;

  if (userUID == null || userUID.isEmpty) {
    return;
  }

  try {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userUID)
        .update({
      "userCart": emptyList,
    });

    await sharedPreferences?.setStringList(
      "userCart",
      emptyList,
    );
  } catch (error) {
    // Local cart remains cleared even if
    // Firestore update fails.
  }
}