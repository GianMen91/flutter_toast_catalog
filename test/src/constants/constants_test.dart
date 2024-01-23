import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_toast_catalog/src/constants/constants.dart';

void main() {
  test('Constants test', () {
    // Test the default padding
    expect(defaultPadding, 20.0);

    // Test the horizontal and vertical padding constants
    expect(horizontalPadding, defaultPadding);
    expect(verticalPadding, defaultPadding / 2);

    // Test the background color
    expect(backgroundColor, const Color(0xFFF1EFF1));

    // Test the main color theme
    expect(appMainColor, const Color(0xff429689));
  });
}
