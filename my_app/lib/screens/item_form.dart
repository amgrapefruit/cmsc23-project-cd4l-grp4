import 'package:flutter/material.dart';
import 'package:my_app/model/food_item.dart';

class ItemForm extends StatefulWidget {
  const ItemForm({super.key});

  final String title = "Post an Item";

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  FoodItem? newItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 46, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              )
            ),

            // form photo label
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Item Photo', 
                    style: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                ],
              )
            ),

            // item photo upload form here
          
            // item name label
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Item Name', 
                    style: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                ],
              )
            ),

            TextFormField(
              controller: name,
              decoration: const InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryGreen),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return "Name required";
                return null;
              },
            ),

            // category label
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Category', 
                    style: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                ],
              )
            ),

            // quantity label\
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Quantity', 
                    style: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                ],
              )
            ),

            // expiration date label
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Expiration Date', 
                    style: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                ],
              )
            ),

            // pickup location
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Pickup Location', 
                    style: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}