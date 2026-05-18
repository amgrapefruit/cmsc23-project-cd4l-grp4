import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../provider/auth_provider.dart';
import '../mock_data.dart';
import 'profile_screen.dart';
import 'item_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const Color primaryGreen = Color(0xFF1B4332); 
  static const Color accentGold = Color(0xFFD97706); 
  static const Color surfaceBackground = Color(0xFFF8FAF9); 
  static const Color cleanBorder = Color(0xFFE2E8F0); 
  static const Color placeholderGrey = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    final dynamic user = globalMockUser;

    final List<Widget> pages = [
      _buildHomeFeed(context, user),
      const Center(child: Text("Pantry Inventory")),
      const Center(child: Text("Post Item")),
      const Center(child: Text("Messages")),
      ProfileScreen(user: user),
    ];


    return Scaffold(
      backgroundColor: surfaceBackground,
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey.shade400,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Pantry'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box, size: 28, color: accentGold), label: 'Post'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Message'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomeFeed(BuildContext context, dynamic user) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Row(
              children: [
                const Icon(Icons.location_on_rounded, color: primaryGreen, size: 24),
                const SizedBox(width: 8),
                const Text('Calamba City, Philippines',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.logout_rounded, color: Colors.grey, size: 20),
                  onPressed: () => _handleLogout(context),
                ),
              ],
            ),
          ),

          // --- SEARCH ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: cleanBorder)),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search surplus items...',
                  prefixIcon: Icon(Icons.search, color: primaryGreen),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // --- HERO SECTION ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: placeholderGrey,
                border: Border.all(color: cleanBorder),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 10, bottom: 10,
                    child: Icon(Icons.image_outlined, size: 80, color: Colors.grey.shade300),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Reduce Waste. Share Food.",
                          style: TextStyle(color: primaryGreen, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        const Text("Building a sustainable community together.",
                          style: TextStyle(color: Colors.black54, fontSize: 13)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: primaryGreen, borderRadius: BorderRadius.circular(4)),
                          child: const Text("Join Now", style: TextStyle(color: Colors.white, fontSize: 11)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // for "Available Items" section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Available Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("See all", style: TextStyle(color: accentGold, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          // list updates every time an item is added or deleted
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('food_items')
                //.where('isReserved', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              // display progress indicator
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No items available right now.', style: TextStyle(color: Colors.grey)),
                );
              }

              final docs = snapshot.data!.docs;

              // for horizontal scrolling list of items
              return SizedBox(
                height: 170,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final docId = docs[index].id;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ItemDetailsScreen(foodItemId: docId),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Container(
                          width: 130,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: cleanBorder)
                          ),
                          child: Column(
                            children: [
                              // display food photo if it exists
                              Expanded(
                                child: data['itemPic'] != null
                                    ? Image.network(data['itemPic'],
                                        width: double.infinity,
                                        fit: BoxFit.cover)
                                    : Container(
                                        width: double.infinity,
                                        color: placeholderGrey,
                                        child: Icon(Icons.image_outlined,
                                            size: 28,
                                            color: Colors.grey.shade300),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['name'] ?? 'Item', 
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 2),
                                    const Text("Available now", 
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    try {
      await context.read<AuthProvider>().signOut();
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    }
  }
}