import 'package:flutter/material.dart';
import 'package:shopping_app/data/dummy_item.dart';
import 'package:shopping_app/widgets/item_row.dart';
import 'package:shopping_app/widgets/new_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final dummyData = groceryItems;

    void addItem() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => const NewItem()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [IconButton(onPressed: addItem, icon: const Icon(Icons.add))],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: dummyData.length,
              itemBuilder: (context, i) => Itemrow(groceryItem: dummyData[i]),
            ),
          )
        ],
      ),
    );
  }
}
