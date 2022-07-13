import 'package:ShopApp/providers/cart.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({this.id, this.amount, this.products, this.dateTime});
}

class Order with ChangeNotifier {
  List<OrderItem> _order = [];
  final String authToken;
  final String userId;
  Order(this.authToken, this.userId, this._order);
  List<OrderItem> get orders {
    return [..._order];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://myshoppro-1c37a-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(new OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['datetime']),
            products: (orderData['products'] as List<dynamic>)
                .map((e) => CartItem(
                    id: e['id'],
                    title: e['title'],
                    quentity: e['quentity'],
                    price: e['price']))
                .toList()));
      });

      _order = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://myshoppro-1c37a-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'datetime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cartitem) => {
                    'id': cartitem.id,
                    'title': cartitem.title,
                    'quentity': cartitem.quentity,
                    'price': cartitem.price
                  })
              .toList()
        }));
    _order.insert(
        0,
        new OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            dateTime: timeStamp,
            products: cartProducts));
    notifyListeners();
  }
}
