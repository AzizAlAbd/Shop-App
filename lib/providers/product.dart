import 'package:ShopApp/Models/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});
  Future<void> toggleFavorite(String token, String userId) async {
    final url =
        'https://myshoppro-1c37a-default-rtdb.firebaseio.com/userFavorites/$userId/${this.id}.json?auth=$token';
    isFavorite = !isFavorite;
    notifyListeners();

    final response = await http.put(url, body: json.encode(isFavorite));
    if (response.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException('Could not change favority');
    }
  }
}
