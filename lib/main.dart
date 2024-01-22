import 'package:flutter/material.dart';
import 'constants.dart';
import 'item_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Toast Catalog',

      theme: ThemeData(
        primaryColor: appMainColor,
        visualDensity: VisualDensity.adaptivePlatformDensity, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: appMainColor),
      ),
      home: const ItemScreen(),
    );
  }
}
