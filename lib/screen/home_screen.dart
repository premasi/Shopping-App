import 'package:flutter/material.dart';
import 'package:shopping_app/models/grocery_item.dart';
import 'package:shopping_app/widgets/item_row.dart';
import 'package:shopping_app/widgets/new_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<GroceryItem> groceryItems = [];

  @override
  Widget build(BuildContext context) {
    void addItem() async {
      final newItem = await Navigator.of(context).push<GroceryItem>(
          MaterialPageRoute(builder: (ctx) => const NewItem()));

      if (newItem == null) {
        return;
      }
      setState(() {
        groceryItems.add(newItem);
      });
    }

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
