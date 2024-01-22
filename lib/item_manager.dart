import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_toast_catalog/storage.dart';

import 'item_card.dart';
import 'item_screen.dart';
import 'item.dart'; // Add this import statement

class ItemManager extends StatefulWidget {
  final SortOption sortOption;
  final String searchedValue;

  const ItemManager(
      {Key? key, required this.sortOption, required this.searchedValue})
      : super(key: key);

  @override
  _ItemManagerState createState() => _ItemManagerState();
}

class _ItemManagerState extends State<ItemManager> {
  List<Item>? list;
  String? errorMessage;
  Storage storage = Storage();

  String _selectedType = 'all';
  SortOption _sortOption = SortOption.name;
  String _searchedValue = '';

  @override
  void initState() {
    super.initState();
    loadItems();
    _sortOption = widget.sortOption;
    _searchedValue = widget.searchedValue;
  }

  @override
  void didUpdateWidget(ItemManager oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.sortOption != oldWidget.sortOption) {
      sortItems(widget.sortOption);
    }

    if (widget.searchedValue != oldWidget.searchedValue) {
      updateSearchedValue(widget.searchedValue);
    }
  }

  void sortItems(SortOption option) {
    setState(() {
      _sortOption = option;
      list?.sort((a, b) {
        switch (option) {
          case SortOption.name:
            return (a.name).compareTo(b.name);
          case SortOption.lastSold:
            return (a.lastSold).compareTo(b.lastSold);
          case SortOption.price:
            return (a.price).compareTo(b.price);
          default:
            return 0;
        }
      });
    });
  }


  void updateFilteredItems(String type) {
    setState(() {
      _selectedType = type;
    });
  }

  void updateSearchedValue(String value) {
    setState(() {
      _searchedValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: downloadItems,
      child: listWidget(),
    );
  }

  Widget listWidget() {
    if (list != null) {
      return _itemListView(list!); // Return a ListView
    } else {
      return const Center(
          child: CircularProgressIndicator()); // Return a Center widget
    }
  }

  RefreshIndicator showNoData() {
    return RefreshIndicator(
      onRefresh: downloadItems,
      child: const Center(),
    );
  }

  Future<void> loadItems() async {
    String content = await storage.readList();

    if (content != 'no file available') {
      list = getListFromData(content);
    }

    if ((list != null) && (list!.isNotEmpty)) {
      errorMessage = null;
      setState(() {});
    } else {
      await downloadItems();
    }
  }

  Future<void> downloadItems() async {
    String url = 'https://mocki.io/v1/fa5a29bd-623f-45d0-b2c9-04410875ca7b';


    http.Response response;
    try {
      response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String responseResult = response.body;
        list = getListFromData(responseResult);
        storage.writeList(response.body);
        errorMessage = null;
        setState(() {});
      } else {
        setState(() {
          errorMessage =
              'Error occurred'; // here, you would actually add more if, else statements to show a better error message
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
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Color(0xFF1468b3),
              )),
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
                downloadItems();
              },
              child: const Text("Retry", style: TextStyle(fontSize: 15)),
            ),
          ],
        );
      },
    );
  }

  List<Item> getListFromData(String response) {
    final List<dynamic> responseData = json.decode(response);
    return responseData.map((item) => Item.fromJson(item)).toList();
  }

  Widget _itemListView(data) {
    List<Item> filteredItems = _selectedType != 'all'
        ? data.where((item) => item.type == _selectedType).toList()
        : List<Item>.from(data);

    filteredItems = _searchedValue != ''
        ? filteredItems
        .where((item) =>
    item.name.toLowerCase().contains(_searchedValue.toLowerCase()))
        .toList()
        : filteredItems;

    if (filteredItems.isNotEmpty) {
      filteredItems.sort((a, b) {
        switch (_sortOption) {
          case SortOption.name:
            return (a.name.trim()).compareTo(b.name.trim());
          case SortOption.lastSold:
            return (a.lastSold).compareTo(b.lastSold);
          case SortOption.price:
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
