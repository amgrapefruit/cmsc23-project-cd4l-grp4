import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER: Location Section ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  
                  const Icon(Icons.location_on, color: Colors.orange), 
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Location', 
                        style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      const Text('Los Baños, Laguna', 
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ], 
              ), 
            ),

            // --- HERO SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // "Frame for photos " 
                    const Icon(Icons.collections_outlined, size: 50, color: Colors.grey),
                    const Positioned(
                      bottom: 20,
                      child: Text("PHOTOS...", style: TextStyle(color: Colors.grey)),
                    ),
                    
                    // Simple "Hover" effect placeholder
                    Positioned(
                      right: 15,
                      bottom: 15,
                      child: FloatingActionButton.small(
                        onPressed: () {},
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.arrow_forward_ios, size: 15, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Categories (In Progress)", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
            ),
          ],
        ),
      ),
    );
  }
}