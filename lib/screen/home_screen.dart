import 'package:flutter/material.dart';
import 'package:shopping_app/data/dummy_item.dart';
import 'package:shopping_app/widgets/item_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final dummyData = groceryItems;
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
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
