import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/constants/brand_colors.dart';
import 'package:my_app/constants/app_options.dart';
import 'package:my_app/provider/food_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';


class ItemForm extends StatefulWidget {
  const ItemForm({super.key});

  final String title = "Post an Item";

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _form = GlobalKey<FormState>();

  // form fields
  Uint8List? itemPic; // handle photo upload later
  final item_name = TextEditingController();
  final quantityController = TextEditingController();
  final unitController = TextEditingController();

  int? quantity;
  DateTime? _selectedDate;
  
  List<String?> selectedDietaryTags = [];
  List<String?> selectedFoodTypeTags = [];
  String? selectedLocation;

  bool _isLoading = false;
  bool _submitted = false;
  bool _errorCaught = false;

  // toggle tags
  void _toggleDietaryTag(String tag) {
    setState(() {
      if (selectedDietaryTags.contains(tag)) {
        selectedDietaryTags.remove(tag);
      } else {
        selectedDietaryTags.add(tag);
      }
    });
  }

  // toggle food type on/off
  void _toggleFoodType(String type) {
    setState(() {
      if (selectedFoodTypeTags.contains(type)) {
        selectedFoodTypeTags.remove(type);
      }
      else {
        selectedFoodTypeTags.add(type);
      }
    });
  }


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
    
    return;
  }

  // handle submission function
  void handlePost(BuildContext context) async {
    // validate form fields
    if (itemPic == null ||
        item_name.text.isEmpty || 
        quantity == null || 
        _selectedDate == null || 
        selectedLocation == null ||
        selectedDietaryTags.isEmpty || 
        selectedFoodTypeTags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all required fields'))
      );
      setState(() {
        _errorCaught = true;
      });

      return; // catch empty fields
    }

    if (quantity! <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quantity must be greater than 0'))
      );
      setState(() {
        _errorCaught = true;
      });

      return; // catch invalid quantity
    }

    setState(() {
      _isLoading = true;
      _errorCaught = false;
    });

    String? error = await context.read<FoodProvider>().postFoodItem(
    {
      'name': item_name.text,
      'quantity': quantity,
      'expirationDate': _selectedDate,
      'pickupLocation': selectedLocation,
      'dietaryTags': selectedDietaryTags,
      'foodTypeTags': selectedFoodTypeTags,
      'itemPicBase64': base64Encode(itemPic!)
    });

    setState(() {
      _isLoading = false;
      _submitted = true;

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error))
        );
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item posted successfully!'))
        );

        // clear form
        item_name.clear();
        quantityController.clear();
        unitController.clear();
        itemPic = null;
        selectedLocation = null;
        quantity = null;
        _selectedDate = null;
        selectedDietaryTags = [];
        selectedFoodTypeTags = [];
      }
    });
  }

  // chip tags
  Widget _buildSelectableChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen : Colors.white,
          border: Border.all(
            color: isSelected ? primaryGreen : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // show checkmarks when selected
            if (isSelected) ...[
              const Icon(Icons.check, color: Colors.white, size: 14),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // dropdown for nearby location
  Widget _buildDropdown({
    required String hint,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
    bool showError = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: showError ? Colors.red : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey, size: 18),
                  const SizedBox(width: 8),
                  Text(hint, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              borderRadius: BorderRadius.circular(8),
              items: items.map((item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorText(String message) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Text(message, style: const TextStyle(color: Colors.red, fontSize: 12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: SafeArea(
        child: SingleChildScrollView(
          child: AbsorbPointer(
            absorbing: _isLoading,
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          final img = await ImagePicker().pickImage(source: ImageSource.camera);
                          if (img != null) {
                            final bytes = await img.readAsBytes();
                            setState(() {
                              itemPic = bytes;
                            });
                          }
                        },
                        child: Container(
                          height: 350,
                          width: 350,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: _errorCaught && itemPic == null ? Colors.red : Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: itemPic != null ?
                          Expanded(
                                child: Stack(
                                  children: [
                                    Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                        strokeWidth: 2,
                                      ) // Shown if image is loading or missing
                                    ),
                                  Center(
                                    child: Container(
                                      width: 340,
                                      height: 340,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: MemoryImage(itemPic!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: null,
                                    )
                                  ),
                                ],
                              ),
                          ) :
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Icon(
                              Icons.camera_alt,
                              size: 70,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (_errorCaught && itemPic == null) _buildErrorText('Item photo is required'),


                  // item name label
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 6),
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

                  // item form field
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: _errorCaught && item_name.text.isEmpty ? Colors.red : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: item_name,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryGreen),
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (_errorCaught && item_name.text.isEmpty) _buildErrorText('Item name is required'),

                  // description label
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Description Tags', 
                          style: const TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ],
                    )
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                    child: const Text('Dietary Preferences',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ),

                  // maps each option to a selectable chip
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: dietaryOptions.map((tag) {
                        return _buildSelectableChip(
                          label: tag,
                          isSelected: selectedDietaryTags.contains(tag),
                          onTap: () => _toggleDietaryTag(tag),
                        );
                      }).toList(),
                    ),
                  ),

                  if (_errorCaught && selectedDietaryTags.isEmpty) _buildErrorText('Please select at least 1 dietary preference tag'),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                    child: const Text('Food Type',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: foodTypeOptions.map((tag) {
                        return _buildSelectableChip(
                          label: tag,
                          isSelected: selectedFoodTypeTags.contains(tag),
                          onTap: () => _toggleFoodType(tag),
                        );
                      }).toList(),
                    ),
                  ),

                  if (_errorCaught && selectedFoodTypeTags.isEmpty) _buildErrorText('Please select at least 1 food type tag'),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // quantity column fields
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // quantity label
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 24, 16, 6),
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

                            // quantity form field
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: _errorCaught && quantity == null || _errorCaught && quantity == 0 ? Colors.red : Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextFormField(
                                  controller: quantityController,
                                  onChanged: (String v) {
                                    // parse to int
                                    quantity = int.parse(v);
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')), // RegEx for decimal limit
                                  ],
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: primaryGreen),
                                    ),
                                  ),
                                ),
                              )
                            ),

                            if (_errorCaught && quantity == null) _buildErrorText('Quantity is required'),

                            if (_errorCaught && quantity != null && quantity! <= 0) _buildErrorText('Quantity must be greater than 0'),
                          ],
                        ),
                      ),

                      // units column fields
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // units label
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 24, 16, 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Unit', 
                                    style: const TextStyle(
                                      fontSize: 16, 
                                      fontWeight: FontWeight.bold
                                    )
                                  ),

                                  SizedBox(width: 4,),

                                  Text('(eg: ml, g, pcs, etc.)',
                                    style: const TextStyle(
                                      fontSize: 12, 
                                      color: Colors.grey
                                    )
                                  ),  
                                ],
                              )
                            ),

                            // units form field
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: _errorCaught && unitController.text.isEmpty ? Colors.red : Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextFormField(
                                  controller: unitController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: primaryGreen),
                                    ),
                                  ),
                                ),
                              )
                            ),

                            if (_errorCaught && unitController.text.isEmpty) _buildErrorText('Unit is required'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // expiration date label
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Expiration Date', 
                          style: const TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold
                          )
                        ),

                        SizedBox(width: 8),

                        Text(_selectedDate == null ? 'No date chosen' : ' (${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year})',
                          style: const TextStyle(
                            fontSize: 16, 
                            color: Colors.grey
                          )
                        ),  
                      ],
                    )
                  ),

                  // date picker
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: _selectDate, 
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            backgroundColor: Colors.white,
                            side: BorderSide(color: _errorCaught && _selectedDate == null ? Colors.red : Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Select Expiration Date"),
                        ),
                      ],
                    )
                  ),

                  if (_errorCaught && _selectedDate == null) _buildErrorText('Expiration date is required'),

                  // pickup location
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Nearby Location', 
                          style: const TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ],
                    )
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: _buildDropdown(
                    hint: 'Select Nearby Location',
                    items: locationOptions,
                    value: selectedLocation,
                    onChanged: (val) => setState(() => selectedLocation = val),
                    showError: _errorCaught && selectedLocation == null ? true : false,
                    ),
                  ),

                  if (_errorCaught && selectedLocation == null) _buildErrorText('Pickup location is required'),

                  // post button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        
                        // disable button while loading
                        onPressed: _isLoading ? null : () => handlePost(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        // show spinner while loading, otherwise show "Continue"
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Post Food Item', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ),
      )
    );
  }
}