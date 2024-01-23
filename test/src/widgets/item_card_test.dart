import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_toast_catalog/src/data/item.dart';
import 'package:flutter_toast_catalog/src/widgets/item_card.dart';

void main() {
  testWidgets('ItemCard Widget Test', (WidgetTester tester) async {
    // Create a sample item for testing
    final Item testItem = Item(
      name: 'Test Item',
      lastSold: DateTime.now(),
      price: 10.0,
      currency: 'EUR',
      id: 1,
    );

    // Build our app and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ItemCard(
            itemIndex: 1,
            item: testItem,
          ),
        ),
      ),
    );

    // Verify that the item name is displayed
    var itemName = find.byKey(const Key('item_name_text'));
    expect(itemName, findsOneWidget);

    final itemNameWidget = tester.widget<Text>(itemName);
    expect(itemNameWidget.data, "Test Item");

    // Verify TextStyle attributes
    expect(itemNameWidget.style!.fontWeight, FontWeight.bold);

    // Verify that the lastSold date is displayed
    var itemLastSold = find.byKey(const Key('item_last_sold_text'));
    expect(itemLastSold, findsOneWidget);

    final itemLastSoldWidget = tester.widget<Text>(itemLastSold);
    var formattedLastSold= testItem.formattedLastSold();
    expect(itemLastSoldWidget.data, "Last Sold: $formattedLastSold");

    // Verify that the item price is displayed
    var itemPrice = find.byKey(const Key('item_price_text'));
    expect(itemPrice, findsOneWidget);

    final itemPriceWidget = tester.widget<Text>(itemPrice);
    expect(itemPriceWidget.data, "Price: 10.0 €");
  });

  testWidgets('Test different currency', (WidgetTester tester) async {
    // Create a sample item for testing
    final Item testItem = Item(
      name: 'Test Item',
      lastSold: DateTime.now(),
      price: 10.0,
      currency: 'PLN',
      id: 1,
    );

    // Build our app and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ItemCard(
            itemIndex: 1,
            item: testItem,
          ),
        ),
      ),
    );

    // Verify that the item price is displayed
    var itemPrice = find.byKey(const Key('item_price_text'));
    expect(itemPrice, findsOneWidget);

    final itemPriceWidget = tester.widget<Text>(itemPrice);
    expect(itemPriceWidget.data, "Price: 10.0 PLN");
  });


}
