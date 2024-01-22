import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

// Represents an item with specific properties
class Item {
  final int id; // Unique identifier for the item
  final String name; // Name of the item
  final double price; // Price of the item
  final String currency; // Currency in which the item's price is expressed
  final DateTime lastSold; // Date and time when the item was last sold

  // Constructor to initialize an Item instance with required properties
  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.lastSold,
  });

  // Factory method to create an Item instance from a JSON map
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: _parseDouble(json['price']),
      currency: json['currency'] ?? '',
      lastSold: _parseDateTime(json['last_sold']),
    );
  }

  // Constructor to create an empty Item instance with default values
  Item.empty()
      : id = 0,
        name = '',
        price = 0.0,
        currency = '',
        lastSold = DateTime.now();

  // Private method to parse a dynamic value into a double, handling exceptions
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
    return 0.0;
  }

  // Private method to parse a dynamic value into a DateTime, handling exceptions
  static DateTime _parseDateTime(dynamic value) {
    if (value is String) {
      try {
        return DateTime.parse(value);
      } on Exception catch (e) {
        if (kDebugMode) {
          print("Error parsing DateTime from string: $e");
        }
      }
    }
    return DateTime.now();
  }

  // Method to format the lastSold date as a string in a specific format
  String formattedLastSold() {
    return DateFormat('dd MMMM yyyy').format(lastSold);
  }
}
