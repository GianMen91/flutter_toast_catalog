import 'package:flutter/foundation.dart';

class Item {
  final int id;
  final String name;
  final double price;
  final String currency;
  final DateTime lastSold;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.lastSold,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: _parseDouble(json['price']),
      currency: json['currency'] ?? '',
      lastSold: _parseDateTime(json['last_sold']),
    );
  }

  Item.empty()
      : id = 0,
        name = '',
        price = 0.0,
        currency = '',
        lastSold = DateTime.now(); // Provide a default value

  static double _parseDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      try {
        return double.parse(value);
      } on Exception catch (e) {
        if (kDebugMode) {
          print("Error parsing double from string: $e");
        }
      }
    }
    return 0.0; // Default value if parsing fails
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is String) {
      try {
        // Parse your date string here, assuming lastSold is a date or timestamp
        return DateTime.parse(value);
      } on Exception catch (e) {
        if (kDebugMode) {
          print("Error parsing DateTime from string: $e");
        }
      }
    }
    return DateTime.now(); // Default value if parsing fails or not provided
  }
}
