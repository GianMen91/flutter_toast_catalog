import 'package:flutter/material.dart';
import 'constants.dart';
import 'item_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
