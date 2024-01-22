import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_toast_catalog/src/item_manager.dart';
import 'package:flutter_toast_catalog/src/screens/item_screen.dart';

void main() {
  group('ItemManager Tests', () {
    testWidgets('ItemManager Loading Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ItemManager(
            sortingOption: SortingOption.name,
            searchedValue: '',
          ),
        ),
      );

      // Simulate loading items
      await tester.pump();

      // Ensure loading indicator disappears after items are loaded
      expect(find.byKey(Key('loadingIndicatorCenter')), findsOneWidget);
    });
  });
}
