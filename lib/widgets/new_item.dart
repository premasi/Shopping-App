import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/data/category_data.dart';
import 'package:shopping_app/models/categories.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final formKey = GlobalKey<FormState>();
  var enteredName = "";
  var enteredQuantity = 1;
  var selectedCategory = categories[Categories.vegetables];
  var isSending = false;
  void saveItem() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isSending = true;
      });
      formKey.currentState!.save();
      final url = Uri.https(
          'shopping-app-flutter-630fe-default-rtdb.asia-southeast1.firebasedatabase.app',
          'shopping-list.json');
      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'name': enteredName,
            'quantity': enteredQuantity,
            'category': selectedCategory!.title,
          }),
        );
        // Check for successful response
        if (response.statusCode == 200) {
          setState(() {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Item was added"),
              ),
            );
          });
          final resData = json.decode(response.body);
          Navigator.of(context).pop(
            GroceryItem(
                id: resData['name'],
                name: enteredName,
                quantity: enteredQuantity,
                category: selectedCategory!),
          );

          // print('Item saved successfully');
          // if (!context.mounted) return;
          // Navigator.of(context).pop();
        } else {
          print('Failed to save item: ${response.statusCode}');
        }
      } catch (error) {
        print('Error occurred: $error');
      }
      // Navigator.of(context).pop(GroceryItem(
      //     id: DateTime.now().toString(),
      //     name: enteredName,
      //     quantity: enteredQuantity,
      //     category: selectedCategory!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Name"),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length >= 50) {
                    return "Name must between 1 and 50 characters";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  enteredName = newValue!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(label: Text("Quantity")),
                      initialValue: enteredQuantity.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! < 0) {
                          return "Quantity must greater than 0";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        enteredQuantity = int.tryParse(newValue!)!;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    color: category.value.color,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(category.value.title)
                                ],
                              ))
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: isSending
                          ? null
                          : () {
                              formKey.currentState!.reset();
                            },
                      child: const Text("Reset")),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                      onPressed: isSending ? null : saveItem,
                      child: isSending
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Text("Add Item"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
