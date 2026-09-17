import 'package:flutter/material.dart';
import 'package:user_app/global/global.dart';

class CartItemCounter extends ChangeNotifier {
  int cartListItemCounter =
      (sharedPreferences?.getStringList("userCart") ?? ['garbageValue'])
          .length -
          1;

  int get count => cartListItemCounter;

  Future<void> displayCartListItemsNumber() async {
    final List<String> cartList =
        sharedPreferences?.getStringList("userCart") ?? ['garbageValue'];

    cartListItemCounter = cartList.length - 1;

    await Future.delayed(const Duration(microseconds: 100));

    notifyListeners();
  }
}