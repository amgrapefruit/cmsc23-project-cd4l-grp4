import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final dynamic user;

  const ProfileScreen({super.key, required this.user});

  static const Color primaryGreen = Color(0xFF1B4332);
  static const Color cleanBorder = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    final bool isVerified = user["isVerified"] ?? false;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      child: Column(
        children: [
          // --- PROFILE PHOTO ---
          const CircleAvatar(
            radius: 55,
            backgroundColor: Color(0xFFF1F5F9),
            child: Icon(Icons.person, size: 60, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          
          // --- NAME ---
          Text(
            user["name"] ?? "Guest",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 6),

          // --- VERIFIED BADGE ---
          if (isVerified)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified, color: Colors.blue, size: 16),
                const SizedBox(width: 4),
                const Text(
                  "Verified Community Member",
                  style: TextStyle(
                    fontSize: 12, 
                    color: Colors.blue, 
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            )
          else
            const Text(
              "Standard Member",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          
          const SizedBox(height: 40),

          // --- INFO CARDS  ---
          _buildTagCard("My Dietary Preferences", List<String>.from(user["dietaryTags"] ?? [])),
          _buildTagCard("My Food Interests", List<String>.from(user["foodInterests"] ?? [])),
        ],
      ),
    );
  }

  Widget _buildTagCard(String title, List<String> tags) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: cleanBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: primaryGreen, fontSize: 14)),
          const SizedBox(height: 12),
          tags.isEmpty 
            ? const Text("No preferences selected", style: TextStyle(fontSize: 11, color: Colors.grey))
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags.map((t) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                )).toList(),
              ),
        ],
      ),
    );
  }
}