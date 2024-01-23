// Importing necessary packages and dependencies for testing Flutter code
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_toast_catalog/src/data/item.dart';
import 'package:flutter_toast_catalog/src/widgets/item_card.dart';

// Main test function to test the ItemCard widget
void main() {

  testWidgets('All elements of ItemCard Widget are displayed correctly', (WidgetTester tester) async {
    // Creating a test item for the ItemCard widget
    final Item testItem = Item(
      name: 'Test Item',
      lastSold: DateTime.now(),
      price: 10.0,
      currency: 'EUR',
      id: 1,
    );

    // Building the widget tree with the ItemCard widget
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

    // Verifying the presence of the item name text widget
    var itemName = find.byKey(const Key('item_name_text'));
    expect(itemName, findsOneWidget);

    // Extracting and verifying properties of the item name text widget
    final itemNameWidget = tester.widget<Text>(itemName);
    expect(itemNameWidget.data, "Test Item");
    expect(itemNameWidget.style!.fontWeight, FontWeight.bold);

    // Verifying the presence of the item last sold text widget
    var itemLastSold = find.byKey(const Key('item_last_sold_text'));
    expect(itemLastSold, findsOneWidget);

    // Extracting and verifying properties of the item last sold text widget
    final itemLastSoldWidget = tester.widget<Text>(itemLastSold);
    var formattedLastSold = testItem.formattedLastSold();
    expect(itemLastSoldWidget.data, "Last Sold: $formattedLastSold");

    // Verifying the presence of the item price text widget
    var itemPrice = find.byKey(const Key('item_price_text'));
    expect(itemPrice, findsOneWidget);

    // Extracting and verifying properties of the item price text widget
    final itemPriceWidget = tester.widget<Text>(itemPrice);
    expect(itemPriceWidget.data, "Price: 10.0 €");
  });

  // Test title: Test different currency
  testWidgets('If the currency is not "EUR", append the currency to the price', (WidgetTester tester) async {
    // Creating a test item with a different currency for the ItemCard widget
    final Item testItem = Item(
      name: 'Test Item',
      lastSold: DateTime.now(),
      price: 10.0,
      currency: 'PLN',
      id: 1,
    );

    // Building the widget tree with the ItemCard widget
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

    // Verifying the presence of the item price text widget
    var itemPrice = find.byKey(const Key('item_price_text'));
    expect(itemPrice, findsOneWidget);

    // Extracting and verifying properties of the item price text widget
    final itemPriceWidget = tester.widget<Text>(itemPrice);
    expect(itemPriceWidget.data, "Price: 10.0 PLN");
  });
}
