// Importing necessary packages and dependencies for testing Dart code
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_toast_catalog/src/data/item.dart';

// Main test function to test the Item class
void main() {

  group('Item Class Tests', () {
    // Test to ensure Item.fromJson creates an Item instance from JSON
    test('Item.fromJson should create an Item instance from JSON', () {
      // Sample JSON response representing an item
      const response =
          '[{"name":"Avocado Toast","price":"5.99","id":1,"currency":"EUR","last_sold":"2020-11-28T15:14:22Z"}]';

      // Decoding the JSON response and mapping it to create an Item instance
      final List<dynamic> responseData = json.decode(response);
      final List<Item> item =
          responseData.map((item) => Item.fromJson(item)).toList();

      // Assertions to verify the correctness of the created Item instance
      expect(item[0].id, 1);
      expect(item[0].name, 'Avocado Toast');
      expect(item[0].price, 5.99);
      expect(item[0].currency, 'EUR');
      expect(item[0].lastSold, DateTime.parse('2020-11-28T15:14:22Z'));
    });

    // Test to ensure Item.empty creates an empty Item instance
    test('Item.empty should create an empty Item instance', () {
      // Creating an empty Item instance
      final emptyItem = Item.empty();

      // Assertions to verify the correctness of the empty Item instance
      expect(emptyItem.id, 0);
      expect(emptyItem.name, '');
      expect(emptyItem.price, 0.0);
      expect(emptyItem.currency, '');
      expect(emptyItem.lastSold, isA<DateTime>());
    });

    // Test to ensure Item.formattedLastSold formats the lastSold date correctly
    test('Item.formattedLastSold should format lastSold date', () {
      // Creating an Item instance with a specific lastSold date
      final item = Item(
        id: 1,
        name: 'Sample Item',
        price: 10.99,
        currency: 'USD',
        lastSold: DateTime.parse('2022-01-01'),
      );

      // Assertion to verify the correct formatting of lastSold date
      expect(item.formattedLastSold(), '01 January 2022');
    });
  });
}
