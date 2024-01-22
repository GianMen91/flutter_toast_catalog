import 'package:flutter/material.dart';
import 'package:flutter_toast_catalog/search_box.dart';

import 'constants.dart';
import 'item_manager.dart';

// Screen for displaying a list of items
class ItemScreen extends StatefulWidget {
  const ItemScreen({Key? key}) : super(key: key);

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

// Enumeration for sorting options
enum SortingOption { name, lastSold, price }

class _ItemScreenState extends State<ItemScreen> {
  int selectedIndex = 0; // Index of the selected item
  SortingOption _sortOption = SortingOption.name; // Default sorting option
  String _searchedValue = ''; // Value entered in the search box
  ItemManager itemManager = const ItemManager(
      sortingOption: SortingOption.name, searchedValue: ''); // Item manager

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: appMainColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            SearchBox(onChanged: (value) {
              // Update the searched value and refresh the item manager
              setState(() {
                _searchedValue = value;
                itemManager = ItemManager(
                    sortingOption: _sortOption, searchedValue: value);
              });
            }),
            const SizedBox(height: defaultPadding / 2),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 70),
                    decoration: const BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  itemManager,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the app bar with the title and sorting menu button
  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text(
        'Toast Catalog',
        style: TextStyle(
          fontFamily: 'Niconne',
          fontSize: 32,
        ),
      ),
      backgroundColor: appMainColor,
      actions: <Widget>[
        buildSortingMenuButtons(),
      ],
    );
  }

  // Build the sorting menu button in the app bar
  IconButton buildSortingMenuButtons() {
    return IconButton(
      icon: const Icon(Icons.sort_by_alpha_rounded),
      onPressed: () {
        // Show the popup menu when the icon is pressed
        showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(100, 100, 0, 0),
          items: <PopupMenuEntry<SortingOption>>[
            const PopupMenuItem<SortingOption>(
              value: SortingOption.name,
              child: Text('Sort by Name'),
            ),
            const PopupMenuItem<SortingOption>(
              value: SortingOption.lastSold,
              child: Text('Sort by Last Sold'),
            ),
            const PopupMenuItem<SortingOption>(
              value: SortingOption.price,
              child: Text('Sort by Price'),
            ),
          ],
        ).then((value) {
          // Handle the selected sorting option
          if (value != null) {
            setState(() {
              _sortOption = value;
              itemManager = ItemManager(
                  sortingOption: _sortOption, searchedValue: _searchedValue);
            });
          }
        });
      },
    );
  }
}
