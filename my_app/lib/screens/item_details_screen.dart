import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';


class ItemDetailsScreen extends StatefulWidget {
  final String foodItemId;
  
  const ItemDetailsScreen({super.key, required this.foodItemId});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  static const Color primaryGreen = Color(0xFF1B4332);
  static const Color cleanBorder = Color(0xFFE2E8F0);

  // text controllers for the receiver
  final TextEditingController _dateCtrl = TextEditingController();
  final TextEditingController _timeCtrl = TextEditingController();
  final TextEditingController _messageCtrl = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    // dispose controllers to avoid memory leaks
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    final String? currentUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.black,

      // updates screen if someone else edits this item
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('food_items')
            .doc(widget.foodItemId)
            .snapshots(),
        builder: (context, snapshot) {

          // display progress indicator while first data loads
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white)
            );
          }

          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text('Item not found.', style: TextStyle(color: Colors.white))
            );
          }

          final data    = snapshot.data!.data() as Map<String, dynamic>;
          final docId   = snapshot.data!.id;
 
          final bool isOwner = data['owner'] == currentUid;
 
          // Show the correct view based on ownership
          return isOwner
              ? _buildGiverView(context, data, docId)
              : _buildReceiverView(context, data, docId, currentUid);
        },
      ),
    );
  }

  // top section with photo, name, qty, expirydate, status
  Widget _buildItemHeader(Map<String, dynamic> data) {

    String expiryText = 'No expiry date';
    final rawExpiry = data['expirationDate'];
    if (rawExpiry != null) {
      DateTime? dt;
      if (rawExpiry is Timestamp) {
        dt = rawExpiry.toDate(); // Firestore Timestamp → Dart DateTime
      } else if (rawExpiry is String) {
        dt = DateTime.tryParse(rawExpiry);
      }
      if (dt != null) {
        expiryText = 'Expires on ${DateFormat('MMM dd, yyyy').format(dt)}';
      }
    }
 
    final bool isAvailable = !(data['isReserved'] ?? false);
 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
 
        // food photo
        Container(
          width: double.infinity,
          height: 200,
          color: const Color(0xFF2A2A2A), // dark placeholder background
          child: data['itemPic'] != null
              ? Image.network(
                  data['itemPic'],
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) =>
                      progress == null
                          ? child
                          : const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white)),
                  errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.camera_alt,
                          size: 48, color: Colors.grey)),
                )
              : const Center(
                  child:
                      Icon(Icons.camera_alt, size: 48, color: Colors.grey)),
        ),
 
        // item name + label
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  data['name'] ?? 'Unnamed Item',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isAvailable ? primaryGreen : Colors.orange,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isAvailable ? 'Available' : 'Reserved',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
 
        // quantity
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: Text('${data['quantity'] ?? '?'} pcs',
              style:
                  const TextStyle(color: Colors.white70, fontSize: 13)),
        ),
 
        // expiry date
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
          child: Text(expiryText,
              style:
                  const TextStyle(color: Colors.white54, fontSize: 12)),
        ),
 
        // distance (hardcoded for now; replace with real GPS later)
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 2, 16, 0),
          child: Text('1.3km away',
              style: TextStyle(color: Colors.white54, fontSize: 12)),
        ),
      ],
    );
  }

  // view for giver
  Widget _buildGiverView(
      BuildContext context, Map<String, dynamic> data, String docId) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
 
            _buildBackButton(context),
 
            // photo + name + qty + expiry + status
            _buildItemHeader(data),
 
            const SizedBox(height: 16),
 
            // "Posted by" card showing the owner's name and verified status
            _buildPostedByCard(data['owner']),
 
            const SizedBox(height: 12),
 
            // description box
            _buildDescriptionCard(data['description']),
 
            const SizedBox(height: 24),
 
            // edit item button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () =>
                      _showEditDialog(context, data, docId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Edit Item',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
 
            const SizedBox(height: 12),
 
            // delete item button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () =>
                      _confirmDelete(context, docId, data['itemPic']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Delete Item',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
 
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // view for receiver
  Widget _buildReceiverView(BuildContext context, Map<String, dynamic> data,
      String docId, String? currentUid) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildBackButton(context),
 
            // photo + name + qty + expiry + badge
            _buildItemHeader(data),
 
            const SizedBox(height: 24),
 
            // preferred date field
            // tapping opens a date picker instead of a keyboard
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Preferred Date',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => _pickDate(context), // opens date picker
                    child: AbsorbPointer(
                      // AbsorbPointer stops keyboard from appearing
                      child: TextField(
                        controller: _dateCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF1A1A1A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
 
            const SizedBox(height: 16),
 
            // preferred time field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Preferred Time',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => _pickTime(context), // opens time picker
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _timeCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF1A1A1A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
 
            const SizedBox(height: 16),
 
            // message to the owner field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Message to the Owner',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _messageCtrl,
                    maxLines: 4, // taller box for longer messages
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1A1A1A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(14),
                    ),
                  ),
                ],
              ),
            ),
 
            const SizedBox(height: 28),
 
            // request item button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  // grey out and disable while the request is being saved
                  onPressed: _isSubmitting
                      ? null
                      : () =>
                          _submitRequest(context, docId, currentUid),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.black),
                        )
                      : const Text('Request Item',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
 
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
 
  // white back arrow at the top-left
  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => Navigator.pop(context),
    );
  }
 
  // "Posted by <Name>  ✓ Verified" card
  // does a one-time fetch of the owner's user document from Firestore
  Widget _buildPostedByCard(String? ownerUid) {
    if (ownerUid == null) return const SizedBox.shrink();
 
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(ownerUid)
          .get(), // one-time read (not a stream, no need for real-time here)
      builder: (context, snap) {
        String ownerName = 'Loading...';
        bool isVerified  = false;
 
        if (snap.hasData && snap.data!.exists) {
          final userData = snap.data!.data() as Map<String, dynamic>;
          ownerName  = userData['name']       ?? 'Unknown';
          isVerified = userData['isVerified'] ?? false;
        }
 
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // Avatar placeholder circle
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFF333333),
                  child: Icon(Icons.person, color: Colors.white54, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Posted by',
                          style: TextStyle(
                              color: Colors.white54, fontSize: 11)),
                      Text(ownerName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14)),
                      const Text('1.3km away',
                          style: TextStyle(
                              color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
                // only show the "Verified" badge if isVerified == true
                if (isVerified)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check_circle,
                          color: Colors.greenAccent, size: 16),
                      SizedBox(width: 4),
                      Text('Verified',
                          style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
 
  // description text box for giver view only
  Widget _buildDescriptionCard(String? description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Description',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            const SizedBox(height: 8),
            Text(
              description ?? 'No description provided.',
              style:
                  const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
 
  // date and time pickers
  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),                                // no past dates
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      // Put the formatted date into the text field, e.g. "May 10, 2026"
      _dateCtrl.text = DateFormat('MMM d, yyyy').format(picked);
    }
  }
 
  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      // Put the formatted time into the text field, e.g. "2:30 PM"
      _timeCtrl.text = picked.format(context);
    }
  }
 
  // submit request
  Future<void> _submitRequest(
      BuildContext context, String docId, String? currentUid) async {
 
    // Validate: both date and time must be filled before submitting
    if (_dateCtrl.text.isEmpty || _timeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please pick a preferred date and time.')));
      return;
    }
 
    setState(() => _isSubmitting = true);
 
    try {
      // add this user's UID to the item's requestedBy array.
      // arrayUnion safely adds without creating duplicates.
      await FirebaseFirestore.instance
          .collection('food_items')
          .doc(docId)
          .update({
        'requestedBy': FieldValue.arrayUnion([currentUid]),
      });
 
      // save the full request details (date, time, message) in a
      // sub-collection so the owner can review each request.
      await FirebaseFirestore.instance
          .collection('food_items')
          .doc(docId)
          .collection('requests')
          .doc(currentUid) // one document per requester
          .set({
        'requesterUid':  currentUid,
        'preferredDate': _dateCtrl.text,
        'preferredTime': _timeCtrl.text,
        'message':       _messageCtrl.text.trim(),
        'submittedAt':   FieldValue.serverTimestamp(), // records exact time
      });
 
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('✅ Request sent! Wait for the owner to accept.')));
        Navigator.pop(context); // go back to the feed
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send request: $e')));
      }
    }
 
    if (mounted) setState(() => _isSubmitting = false);
  }
 
  // for edit dialog
  Future<void> _showEditDialog(
      BuildContext context, Map<String, dynamic> data, String docId) async {
 
    // pre-fill controllers with the item's current values
    final nameCtrl = TextEditingController(text: data['name']);
    final qtyCtrl  = TextEditingController(text: '${data['quantity'] ?? ''}');
    final descCtrl = TextEditingController(text: data['description'] ?? '');
 
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Edit Item',
            style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _darkField(nameCtrl, 'Item Name'),
              const SizedBox(height: 10),
              _darkField(qtyCtrl, 'Quantity',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              _darkField(descCtrl, 'Description', maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: primaryGreen),
            onPressed: () async {
              // Save only the fields that can be edited; preserve everything else
              await FirebaseFirestore.instance
                  .collection('food_items')
                  .doc(docId)
                  .update({
                'name':        nameCtrl.text.trim(),
                'quantity':    int.tryParse(qtyCtrl.text) ?? data['quantity'],
                'description': descCtrl.text.trim(),
              });
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
 
  // Dark-themed TextField used inside the edit dialog
  Widget _darkField(TextEditingController ctrl, String label,
      {TextInputType keyboardType = TextInputType.text,
      int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
 
  // confirm then delete item
  Future<void> _confirmDelete(
      BuildContext context, String docId, String? imageUrl) async {
 
    // Show a confirmation dialog before actually deleting anything
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Delete Item',
            style: TextStyle(color: Colors.white)),
        content: const Text(
            'Are you sure? This cannot be undone.',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false), // user said No
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, true), // user said Yes
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
 
    if (confirmed == true && mounted) {
      try {
        // delete the Firestore document for this food item
        await FirebaseFirestore.instance
            .collection('food_items')
            .doc(docId)
            .delete();
 
        // also delete the photo from Firebase Storage to avoid wasted space.
        if (imageUrl != null && imageUrl.isNotEmpty) {
          try {
            await FirebaseStorage.instance
                .refFromURL(imageUrl)
                .delete();
          } catch (_) {}
        }
 
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item deleted.')));
          Navigator.pop(context); // return to previous screen
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to delete: $e')));
        }
      }
    }
  }
}
