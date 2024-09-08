import 'package:flutter/material.dart';
import 'package:shopping_app/models/grocery_item.dart';

class Itemrow extends StatelessWidget {
  const Itemrow({super.key, required this.groceryItem});
  final GroceryItem groceryItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                color: groceryItem.category.color,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                groceryItem.name,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
          Text(
            groceryItem.quantity.toString(),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
