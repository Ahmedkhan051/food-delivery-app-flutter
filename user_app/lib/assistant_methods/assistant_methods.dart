import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/global/global.dart';

separateOrderItemIds(orderId) {
  List<String> separateItemIdsList = [];
  List<String> defaultItemList = [];

  int i = 0;

  defaultItemList = List<String>.from(orderId);

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();

    var pos = item.lastIndexOf(":");

    String getItemId = (pos != -1)
        ? item.substring(0, pos)
        : item;

    separateItemIdsList.add(getItemId);
  }

  return separateItemIdsList;
}

separateItemIds() {
  List<String> separateItemIdsList = [];
  List<String> defaultItemList = [];

  if (sharedPreferences == null) {
    return separateItemIdsList;
  }

  defaultItemList =
      sharedPreferences!.getStringList("userCart") ?? ['garbageValue'];

  for (int i = 0; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();

    var pos = item.lastIndexOf(":");

    String getItemId = (pos != -1)
        ? item.substring(0, pos)
        : item;

    separateItemIdsList.add(getItemId);
  }

  return separateItemIdsList;
}

Future<void> addItemToCart(
    String? foodItemId,
    BuildContext context,
    int itemCounter) async {
  if (foodItemId == null || foodItemId.isEmpty) {
    Fluttertoast.showToast(
      msg: "Food item not found.",
    );
    return;
  }

  if (sharedPreferences == null) {
    Fluttertoast.showToast(
      msg: "Please restart FoodHub and try again.",
    );
    return;
  }

  List<String> tempList =
      sharedPreferences!.getStringList("userCart") ?? ['garbageValue'];

  tempList.add("$foodItemId:$itemCounter");

  // Save cart locally first.
  await sharedPreferences!.setStringList(
    "userCart",
    tempList,
  );

  // Update Firebase only when a Firebase user exists.
  if (firebaseAuth.currentUser != null) {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        "userCart": tempList,
      });
    } catch (error) {
      // Local cart is already saved, so the app can continue.
    }
  }

  Fluttertoast.showToast(
    msg: "Item Added Successfully.",
  );

  Provider.of<CartItemCounter>(
    context,
    listen: false,
  ).displayCartListItemsNumber();
}

separateOrderItemQuantities(orderId) {
  List<String> separateItemQuantityList = [];
  List<String> defaultItemList = [];

  defaultItemList = List<String>.from(orderId);

  for (int i = 1; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();

    List<String> listItemCharacters = item.split(":").toList();

    if (listItemCharacters.length > 1) {
      var quanNumber = int.tryParse(
        listItemCharacters[1].toString(),
      );

      if (quanNumber != null) {
        separateItemQuantityList.add(
          quanNumber.toString(),
        );
      }
    }
  }

  return separateItemQuantityList;
}

separateItemQuantities() {
  List<int> separateItemQuantityList = [];
  List<String> defaultItemList = [];

  if (sharedPreferences == null) {
    return separateItemQuantityList;
  }

  defaultItemList =
      sharedPreferences!.getStringList("userCart") ?? ['garbageValue'];

  for (int i = 1; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();

    List<String> listItemCharacters = item.split(":").toList();

    if (listItemCharacters.length > 1) {
      var quanNumber = int.tryParse(
        listItemCharacters[1].toString(),
      );

      if (quanNumber != null) {
        separateItemQuantityList.add(quanNumber);
      }
    }
  }

  return separateItemQuantityList;
}

Future<void> clearCartNow(BuildContext context) async {
  if (sharedPreferences == null) {
    return;
  }

  const List<String> emptyCart = ['garbageValue'];

  // Always clear the local cart.
  await sharedPreferences!.setStringList(
    "userCart",
    emptyCart,
  );

  // Update Firebase only when a Firebase user actually exists.
  if (firebaseAuth.currentUser != null) {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        "userCart": emptyCart,
      });
    } catch (error) {
      // Ignore Firebase errors for demo/local users.
    }
  }

  // Update the cart counter.
  Provider.of<CartItemCounter>(
    context,
    listen: false,
  ).displayCartListItemsNumber();
}