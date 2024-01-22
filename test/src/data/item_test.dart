import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_toast_catalog/src/data/item.dart';

void main() {
  group('Item Class Tests', () {
    test('Item.fromJson should create an Item instance from JSON', () {
      const response =
          '[{"name":"Avocado Toast","price":"5.99","id":1,"currency":"EUR","last_sold":"2020-11-28T15:14:22Z"}]';

      final List<dynamic> responseData = json.decode(response);
      final List<Item> item =
          responseData.map((item) => Item.fromJson(item)).toList();

      expect(item[0].id, 1);
      expect(item[0].name, 'Avocado Toast');
      expect(item[0].price, 5.99);
      expect(item[0].currency, 'EUR');
      expect(item[0].lastSold, DateTime.parse('2020-11-28T15:14:22Z'));
    });

    test('Item.empty should create an empty Item instance', () {
      final emptyItem = Item.empty();

      expect(emptyItem.id, 0);
      expect(emptyItem.name, '');
      expect(emptyItem.price, 0.0);
      expect(emptyItem.currency, '');
      expect(emptyItem.lastSold, isA<DateTime>());
    });

    test('Item.formattedLastSold should format lastSold date', () {
      final item = Item(
        id: 1,
        name: 'Sample Item',
        price: 10.99,
        currency: 'USD',
        lastSold: DateTime.parse('2022-01-01'),
      );

      expect(item.formattedLastSold(), '01 January 2022');
    });
  });
}
