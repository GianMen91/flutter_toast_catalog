// Importing necessary packages and dependencies for testing Flutter code
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_toast_catalog/src/item_manager.dart';
import 'package:flutter_toast_catalog/src/screens/item_screen.dart';

// Main test function to test the ItemManager widget
void main() {

  group('ItemManager Tests', () {

    testWidgets('ItemManager Loading Test', (WidgetTester tester) async {
      // Building the widget tree with the ItemManager widget
      await tester.pumpWidget(
        const MaterialApp(
          home: ItemManager(
            sortingOption: SortingOption.name,
            searchedValue: '',
          ),
        ),
      );

      // Simulating loading items
      await tester.pump();

      // Ensuring loading indicator disappears after items are loaded
      expect(find.byKey(const Key('loadingIndicatorCenter')), findsOneWidget);
    });
  });
}
