// Importing necessary packages and dependencies for testing Flutter code
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Importing constants from the Flutter Toast Catalog
import 'package:flutter_toast_catalog/src/constants/constants.dart';

// Main test function to validate the correctness of constants
void main() {
  // Verifying Constants in Flutter Toast Catalog
  test('Verify Constants', () {
    // Test to check if defaultPadding is equal to 20.0
    expect(defaultPadding, 20.0);

    // Test to ensure horizontalPadding is equal to defaultPadding
    expect(horizontalPadding, defaultPadding);

    // Test to verify verticalPadding is equal to half of defaultPadding
    expect(verticalPadding, defaultPadding / 2);

    // Test to confirm that backgroundColor is set to the correct value
    expect(backgroundColor, const Color(0xFFF1EFF1));

    // Test to validate that appMainColor is set to the correct color value
    expect(appMainColor, const Color(0xff429689));
  });
}
