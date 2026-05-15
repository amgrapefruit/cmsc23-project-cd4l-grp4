import 'package:flutter/material.dart';
import 'package:my_app/constants/brand_colors.dart';
import 'package:my_app/model/food_item.dart';

class ItemForm extends StatefulWidget {
  const ItemForm({super.key});

  final String title = "Post an Item";

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _form = GlobalKey<FormState>();

  // form controllers
  final item_name = TextEditingController();
  final pickup_location = TextEditingController();

  int quantity = 0;
  
  DateTime? _selectedDate;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: SafeArea(
        child: Form(
          key: _form,
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
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

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextFormField(
                  controller: item_name,
                  decoration: const InputDecoration(
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
              ),

              // category label
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
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

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextFormField(
                  onChanged: (String v) {
                    // parse to int
                    quantity = int.parse(v);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryGreen),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Quantity required";
                    return null;
                  },
                ),
              ),

              // expiration date label
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
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

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    OutlinedButton(
                      onPressed: _selectDate, 
                      child: const Text("Select Expiration Date"),
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
      ),
    );
  }
}