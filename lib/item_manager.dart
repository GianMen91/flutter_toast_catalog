import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_toast_catalog/storage.dart';

import 'item_card.dart';
import 'item_screen.dart';
import 'item.dart';

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
  List<Item>? itemList;
  String? errorMessage;
  Storage storage = Storage();

  SortingOption _currentSortingOption = SortingOption.name;
  String _currentSearchedValue = '';

  @override
  void initState() {
    super.initState();
    _loadItems();
    _currentSortingOption = widget.sortingOption;
    _currentSearchedValue = widget.searchedValue;
  }

  @override
  void didUpdateWidget(ItemManager oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.sortingOption != oldWidget.sortingOption) {
      _sortItems(widget.sortingOption);
    }

    if (widget.searchedValue != oldWidget.searchedValue) {
      _updateSearchedValue(widget.searchedValue);
    }
  }

  void _sortItems(SortingOption option) {
    setState(() {
      _currentSortingOption = option;
      itemList?.sort((a, b) {
        switch (option) {
          case SortingOption.name:
            return (a.name).compareTo(b.name);
          case SortingOption.lastSold:
            return (a.lastSold).compareTo(b.lastSold);
          case SortingOption.price:
            return (a.price).compareTo(b.price);
          default:
            return 0;
        }
      });
    });
  }

  void _updateSearchedValue(String value) {
    setState(() {
      _currentSearchedValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _downloadItems,
      child: _listWidget(),
    );
  }

  Widget _listWidget() {
    if (itemList != null) {
      return _itemListView(itemList!);
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  RefreshIndicator _showNoData() {
    return RefreshIndicator(
      onRefresh: _downloadItems,
      child: const Center(),
    );
  }

  Future<void> _loadItems() async {
    String content = await storage.readList();

    if (content != 'no file available') {
      itemList = _getListFromData(content);
    }

    if ((itemList != null) && (itemList!.isNotEmpty)) {
      errorMessage = null;
      setState(() {});
    } else {
      await _downloadItems();
    }
  }

  Future<void> _downloadItems() async {
    String url = 'https://mocki.io/v1/fa5a29bd-623f-45d0-b2c9-04410875ca7b';

    http.Response response;
    try {
      response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String responseResult = response.body;
        itemList = _getListFromData(responseResult);
        storage.writeList(response.body);
        errorMessage = null;
        setState(() {});
      } else {
        setState(() {
          errorMessage = 'Error occurred';
        });
        throw Exception('Failed to load items from API');
      }
    } on SocketException {
      _showMyDialog();
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Color(0xFF1468b3),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Impossible to download the items from the server.'),
                Text('Check your internet connection and retry!'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(12.0),
                primary: const Color(0xFF1468b3),
                onPrimary: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Close", style: TextStyle(fontSize: 15)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(12.0),
                primary: const Color(0xFF1468b3),
                onPrimary: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                _downloadItems();
              },
              child: const Text("Retry", style: TextStyle(fontSize: 15)),
            ),
          ],
        );
      },
    );
  }

  List<Item> _getListFromData(String response) {
    final List<dynamic> responseData = json.decode(response);
    return responseData.map((item) => Item.fromJson(item)).toList();
  }

  Widget _itemListView(data) {
    List<Item> filteredItems = List<Item>.from(data);

    filteredItems = _currentSearchedValue != ''
        ? filteredItems
            .where((item) => item.name
                .toLowerCase()
                .contains(_currentSearchedValue.toLowerCase()))
            .toList()
        : filteredItems;

    if (filteredItems.isNotEmpty) {
      filteredItems.sort((a, b) {
        switch (_currentSortingOption) {
          case SortingOption.name:
            return (a.name.trim()).compareTo(b.name.trim());
          case SortingOption.lastSold:
            return (a.lastSold).compareTo(b.lastSold);
          case SortingOption.price:
            return (a.price).compareTo(b.price);
          default:
            return 0;
        }
      });
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
