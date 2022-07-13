import 'dart:ffi';

import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;

  final int quentity;
  final double price;
  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quentity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quentity;
    });
    return total;
  }

  void addItem(String productId, String productTitle, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              quentity: value.quentity + 1,
              price: value.price));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: productTitle,
              quentity: 1,
              price: price));
    }
    notifyListeners();
  }

  void removeItem(String productID) {
    _items.remove(productID);
    notifyListeners();
  }

  void removeSingleItem(String productID) {
    if (!_items.containsKey(productID)) return;
    if (_items[productID].quentity > 1) {
      _items.update(
          productID,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              quentity: value.quentity - 1,
              price: value.price));
    } else {
      _items.remove(productID);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
