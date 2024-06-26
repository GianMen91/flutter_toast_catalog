import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_toast_catalog/src/screens/item_screen.dart';
import 'package:flutter_toast_catalog/src/widgets/item_card.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_toast_catalog/src/data/storage.dart';

import 'constants/constants.dart';
import 'data/item.dart';

// Widget for managing and displaying a list of items
class ItemManager extends StatefulWidget {
  final SortingOption sortingOption;
  final String searchedValue;

  const ItemManager({
    Key? key,
    required this.sortingOption,
    required this.searchedValue,
  }) : super(key: key);

  @override
  _ItemManagerState createState() => _ItemManagerState();
}

class _ItemManagerState extends State<ItemManager> {
  List<Item>? itemList; // List of items to display
  String? errorMessage; // Error message to display if an error occurs
  Storage storage = Storage(); // Storage utility for reading/writing data

  SortingOption _currentSortingOption = SortingOption.name;
  String _currentSearchedValue = '';

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  // Initialize the state of the widget
  void _initializeState() {
    _currentSortingOption = widget.sortingOption;
    _currentSearchedValue = widget.searchedValue;
    _loadItems();
  }

  @override
  void didUpdateWidget(ItemManager oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update sorting option if it changes
    if (widget.sortingOption != oldWidget.sortingOption) {
      _sortItems(widget.sortingOption);
    }

    // Update searched value if it changes
    if (widget.searchedValue != oldWidget.searchedValue) {
      _updateSearchedValue(widget.searchedValue);
    }
  }

  // Sort the items based on the selected option
  void _sortItems(SortingOption option) {
    setState(() {
      _currentSortingOption = option;
      itemList?.sort((a, b) {
        switch (option) {
          case SortingOption.name:
            return a.name.compareTo(b.name);
          case SortingOption.lastSold:
            return a.lastSold.compareTo(b.lastSold);
          case SortingOption.price:
            return a.price.compareTo(b.price);
          default:
            return 0;
        }
      });
    });
  }

  // Update the searched value
  void _updateSearchedValue(String value) {
    setState(() {
      _currentSearchedValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: const Key('itemManagerRefreshIndicator'),
      onRefresh: _downloadItems,
      child: itemList != null
          ? _itemListView(itemList!)
          : _buildLoadingIndicator(),
    );
  }

  // Build a loading indicator widget
  Widget _buildLoadingIndicator() {
    return const Center(
        key: Key('loadingIndicatorCenter'), // Added key
        child: CircularProgressIndicator());
  }

  // Load items from storage or download from API
  Future<void> _loadItems() async {
    String content = await storage.readFromFile();
    if (content != 'no file available') {
      itemList = _getListFromData(content);
    }

    if (itemList == null || itemList!.isEmpty) {
      await _downloadItems();
    } else {
      setState(() {});
    }
  }

  // Download items from the API
  Future<void> _downloadItems() async {
    const url = 'https://gist.githubusercontent.com/GianMen91/0f93444fade28f5755479464945a7ad1/raw/f7ad7a60b2cff021ecf6cf097add060b39a1742b/toast_list.json';

    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String responseResult = response.body;
        itemList = _getListFromData(responseResult);
        storage.writeToFile(response.body);
        setState(() {});
      } else {
        _handleError('Error occurred');
      }
    } on SocketException {
      _showErrorDialog(
        'Error',
        'Impossible to download the items from the server.\nCheck your internet connection and retry!',
      );
    }
  }

  // Handle errors during item download
  Future<void> _handleError(String message) async {
    setState(() {
      errorMessage = message;
    });
    throw Exception('Failed to load items from API');
  }

  // Show an error dialog with options for close and retry
  Future<void> _showErrorDialog(
      String title, String content) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: appMainColor,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: [
            if (itemList != null)
              _buildDialogButton('Close', () => Navigator.pop(context)),
            _buildDialogButton('Retry', () async {
              Navigator.pop(context);
              await  _downloadItems();
            }),
          ],
        );
      },
    );
  }

  // Build a styled elevated button for dialogs
  ElevatedButton _buildDialogButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: appMainColor, shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
        padding: const EdgeInsets.all(12.0),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 15)),
    );
  }

  // Convert JSON response to a list of Item objects
  List<Item> _getListFromData(String response) {
    final Map<String, dynamic> responseData = json.decode(response);
    final List<dynamic> items = responseData['items'];
    return items.map((item) => Item.fromJson(item)).toList();
  }

  // Build a ListView of items based on search and sort criteria
  Widget _itemListView(List<Item> data) {
    List<Item> filteredItems = List<Item>.from(data);

    filteredItems = _currentSearchedValue != ''
        ? filteredItems
        .where((item) => item.name
        .toLowerCase()
        .contains(_currentSearchedValue.toLowerCase()))
        .toList()
        : filteredItems;

    if (filteredItems.isNotEmpty) {
      _sortItems(_currentSortingOption);
      return ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (context, index) => ItemCard(
          itemIndex: index,
          item: filteredItems[index],
        ),
      );
    } else {
      return const Align(
        child: Text(
          "No Items Found",
          style: TextStyle(fontSize: 16),
        ),
      );
    }
  }
}
