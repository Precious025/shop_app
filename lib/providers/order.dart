import 'dart:convert';
import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String? id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  final List<OrderItem> _orders = [];

  String? token;
  String? userId;

  void update(String? token, String? userId) {
    this.token == token;
    this.userId == userId;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-learn-project-2d181-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
    final response = await http.get(
      Uri.parse(url),
    );
    final List<OrderItem> loadedProduct = [];
    final extractedData = json.decode(response.body)! as Map<String?, dynamic>;
    // ignore: unnecessary_null_comparison
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedProduct.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity'],
                ),
              )
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ),
      );
    });
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final url =
        'https://flutter-learn-project-2d181-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
            'dateTime': timeStamp.toIso8601String(),
          }));
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timeStamp,
        ),
      );
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }
}
