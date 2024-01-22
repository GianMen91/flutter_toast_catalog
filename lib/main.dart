import 'package:flutter/material.dart';
import 'constants/constants.dart';
import 'screens/item_screen.dart';

// Entry point of the application
void main() {
  runApp(const MyApp());
}

// The root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Configuration for the entire application
      debugShowCheckedModeBanner: false,
      // Disable the debug banner in release mode
      title: 'Toast Catalog',
      // Title of the application
      theme: ThemeData(
        // Theme settings for the application
        primaryColor: appMainColor, // Set the primary color
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary:
                appMainColor), // Customize the color scheme with the secondary color
      ),
      home: const ItemScreen(), // Set the home screen of the application
    );
  }
}
