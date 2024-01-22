import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_toast_catalog/main.dart';
import 'package:flutter_toast_catalog/src/constants/constants.dart';
import 'package:flutter_toast_catalog/src/screens/item_screen.dart';

void main() {
  testWidgets('MyApp Widget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed
    expect(find.text('Toast Catalog'), findsOneWidget);

    // Verify that the home screen is an ItemScreen
    expect(find.byType(ItemScreen), findsOneWidget);

    // Verify the theme settings
    MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.theme!.primaryColor, appMainColor);
    expect(app.theme!.colorScheme.secondary, appMainColor);
  });
}
