import 'package:flutter/material.dart';
import 'package:flutter_toast_catalog/search_box.dart';

import 'constants.dart';

import 'item_manager.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({Key? key}) : super(key: key);

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

enum SortOption { name, lastSold, price }

class _ItemScreenState extends State<ItemScreen> {
  int selectedIndex = 0;
  SortOption _sortOption = SortOption.name;
  String _searchedValue = '';
  ItemManager itemsManager =
      const ItemManager(sortOption: SortOption.name, searchedValue: '');

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
              setState(() {
                _searchedValue = value;
                itemsManager =
                    ItemManager(sortOption: _sortOption, searchedValue: value);
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
                  itemsManager,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        IconButton(
          icon: const Icon(Icons.sort_by_alpha_rounded),
          onPressed: () {
            // Show the popup menu when the icon is pressed
            showMenu(
              context: context,
              position: const RelativeRect.fromLTRB(100, 100, 0, 0),
              items: <PopupMenuEntry<SortOption>>[
                const PopupMenuItem<SortOption>(
                  value: SortOption.name,
                  child: Text('Sort by Name'),
                ),
                const PopupMenuItem<SortOption>(
                  value: SortOption.lastSold,
                  child: Text('Sort by Last Sold'),
                ),
                const PopupMenuItem<SortOption>(
                  value: SortOption.price,
                  child: Text('Sort by Price'),
                ),
              ],
            ).then((value) {
              // Handle the selected sorting option
              if (value != null) {
                setState(() {
                  _sortOption = value;
                  itemsManager = ItemManager(
                      sortOption: _sortOption, searchedValue: _searchedValue);
                });
              }
            });
          },
        ),
      ],
    );
  }
}
