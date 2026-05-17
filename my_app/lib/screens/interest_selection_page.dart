import 'package:flutter/material.dart';
import 'package:my_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_app/constants/app_options.dart';
import 'package:my_app/constants/brand_colors.dart';

class InterestSelectionScreen extends StatefulWidget {
  const InterestSelectionScreen({super.key});

  @override
  State<InterestSelectionScreen> createState() => _InterestSelectionScreenState();
}

class _InterestSelectionScreenState extends State<InterestSelectionScreen> {
  // selected state
  List<String> selectedDietaryTags = [];  // multi-select
  List<String> selectedFoodTypes = [];    // multi-select
  String? selectedLocation;               // single select (dropdown)
  String? selectedRole;                   // single select (chips)

  // whether Continue was tapped (to trigger validation UI)
  bool _submitted = false;

  // loading state for the Continue button
  bool _isLoading = false;

  // individual validation per section
  // each returns true if that section has a valid selection
  bool get _dietaryValid => selectedDietaryTags.isNotEmpty;
  bool get _foodTypeValid => selectedFoodTypes.isNotEmpty;
  bool get _roleValid => selectedRole != null;
  bool get _locationValid => selectedLocation != null;

  // toggle dietary tag on/off
  void _toggleDietaryTag(String tag) {
    setState(() {
      if (selectedDietaryTags.contains(tag)) {
        selectedDietaryTags.remove(tag);    // deselect tags if already selected
      }
      else {
        selectedDietaryTags.add(tag);       // select tags if not yet selected
      }
    });
  }
  
  // toggle food type on/off
  void _toggleFoodType(String type) {
    setState(() {
      if (selectedFoodTypes.contains(type)) {
        selectedFoodTypes.remove(type);
      }
      else {
        selectedFoodTypes.add(type);
      }
    });
  }

  // continue button
  void onContinue() async {
    setState(() => _submitted = true);

    // dietary AND food type are now both individually required
    if (!_dietaryValid || !_foodTypeValid || !_roleValid || !_locationValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all preferences before continuing.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    setState(() => _isLoading = false);

    // navigate to the next screen
    // using pushReplacementNamed so user can't go back to this screen
    Navigator.pushReplacementNamed(context, '/home');
  }
  
  // reusable selectable chip
  // used for dietary tags and food types
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

  // role chip (single select only)
  Widget _buildRoleChip(String label, String value) {
    final bool isSelected = selectedRole == value;
    return GestureDetector(
      onTap: () => setState(() => selectedRole = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
    return Container(
      decoration: BoxDecoration(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    
    // error flags
    final bool showDietaryError = _submitted && !_dietaryValid;
    final bool showFoodError = _submitted && !_foodTypeValid;
    final bool showRoleError = _submitted && !_roleValid;
    final bool showLocationError = _submitted && !_locationValid;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 20),

                // for header
                const Text(
                  'What kind of food\nsharing experience\ndo you want?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose at least 2 to personalize your food.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),

                const SizedBox(height: 30),

                // dietary preferences
                const Text('Dietary Preferences',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                const Text('Select your dietary needs or restrictions',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 10),
                
                // maps each option to a selectable chip
                Wrap(
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

                // show error if submitted but nothing selected
                if (showDietaryError) ...[
                  const SizedBox(height: 6),
                  const Text('Please select at least one dietary preference',
                        style: TextStyle(color: Colors.red, fontSize: 12)),
                ],

                const SizedBox(height: 20),

                // food type interest
                const Text('Food Type Interest',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                const Text('What type of food are you interested in?',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 10),
                
                // maps each option to a selectable chip
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: foodTypeOptions.map((type) {
                    return _buildSelectableChip(
                      label: type,
                      isSelected: selectedFoodTypes.contains(type),
                      onTap: () => _toggleFoodType(type),
                    );
                  }).toList(),
                ),

                // show error if submitted but nothing selected
                if (showFoodError) ...[
                  const SizedBox(height: 6),
                  const Text('Please select at least one food type',
                      style: TextStyle(color: Colors.red, fontSize: 12)),
                ],

                const SizedBox(height: 20),

                // sharing role
                const Text('Sharing Role Preferences',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                const Text('How do you want to participate in the community?',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildRoleChip('To receive food', 'receive'),
                    _buildRoleChip('To give surplus food', 'give'),
                    _buildRoleChip('Both giver and receiver', 'both'),
                  ],
                ),

                // show error if submitted but no role selected
                if (showRoleError) ...[
                  const SizedBox(height: 6),
                  const Text('Please select a role',
                      style: TextStyle(color: Colors.red, fontSize: 12)),
                ],

                const SizedBox(height: 20),

                // nearby location
                const Text('Nearby Location',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                _buildDropdown(
                  hint: 'Select Nearby Location',
                  items: locationOptions,
                  value: selectedLocation,
                  onChanged: (val) => setState(() => selectedLocation = val),
                  showError: showLocationError,
                ),

                if (showLocationError) ...[
                  const SizedBox(height: 6),
                  const Text('Please select a nearby location',
                      style: TextStyle(color: Colors.red, fontSize: 12)),
                ],
                
                const SizedBox(height: 40),

                // continue button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    
                    // disable button while loading
                    onPressed: _isLoading ? null : onContinue,
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
                        : const Text('Continue', style: TextStyle(fontSize: 16)),
                  ),
                ),

                const SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }
}