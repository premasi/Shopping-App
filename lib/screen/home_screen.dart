import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/data/category_data.dart';
import 'package:shopping_app/models/grocery_item.dart';
import 'package:shopping_app/widgets/item_row.dart';
import 'package:shopping_app/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<GroceryItem> groceryItems = [];

  @override
  void initState() {
    super.initState();
    getItem();
  }

  void getItem() async {
    final url = Uri.https(
        'shopping-app-flutter-630fe-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list.json');
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> tempData = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value["category"])
          .value;
      tempData.add(
        GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category),
      );
    }
    setState(() {
      groceryItems = tempData;
    });
  }

  void addItem() async {
    await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx) => const NewItem()));

    getItem();
  }

  @override
  Widget build(BuildContext context) {
    // void addItem() async {
    //   final newItem = await Navigator.of(context).push<GroceryItem>(
    //       MaterialPageRoute(builder: (ctx) => const NewItem()));

    //   if (newItem == null) {
    //     return;
    //   }
    //   setState(() {
    //     groceryItems.add(newItem);
    //   });
    // }

    void removeItem(GroceryItem item) {
      setState(() {
        groceryItems.remove(item);
      });
    }

    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: groceryItems.length,
            itemBuilder: (context, i) => Dismissible(
                onDismissed: (direction) {
                  removeItem(groceryItems[i]);
                },
                key: ValueKey(groceryItems[i].id),
                child: Itemrow(groceryItem: groceryItems[i])),
          ),
        ),
      ],
    );

    if (groceryItems.isEmpty) {
      content = const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("Item still empty, add new item!")],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [IconButton(onPressed: addItem, icon: const Icon(Icons.add))],
      ),
      body: content,
    );
  }
}
