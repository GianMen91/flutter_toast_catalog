// Importing necessary packages and dependencies for testing Flutter code
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_toast_catalog/main.dart';
import 'package:flutter_toast_catalog/src/constants/constants.dart';
import 'package:flutter_toast_catalog/src/screens/item_screen.dart';

// Main test function to test the MyApp widget
void main() {

  testWidgets('MyApp Widget Test', (WidgetTester tester) async {
    // Building the widget tree with the MyApp widget
    await tester.pumpWidget(const MyApp());

    // Verifying the presence of the app title
    expect(find.text('Toast Catalog'), findsOneWidget);

    // Verifying the presence of the ItemScreen widget
    expect(find.byType(ItemScreen), findsOneWidget);

    // Extracting and verifying properties of the MaterialApp widget
    MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.theme!.primaryColor, appMainColor);
    expect(app.theme!.colorScheme.secondary, appMainColor);
  });
}
