import 'package:flutter/material.dart';
//import api


class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _form = GlobalKey<FormState>();

  bool verify() {
    // call api to verify picture here
    print("verifying picture...");
    return true; // return true if verified, false if not
  }

  // Branding colors
  static const Color primaryGray = Color(0xFF2A312A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _form,
              child: Column(
                children: [

                  const SizedBox(height: 40),

                  const Text(
                    'Verify Your Identity',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Take a clear selfie to verify your identity and keep our community safe',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 32),

                  Column(
                    children: [
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          color: primaryGray,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryGray,
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.camera_alt,
                            size: 48,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFFE8E8E8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Tips for easy verification',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text('Use good lighting'),
                            SizedBox(height: 8),
                            Text('Look directly at the camera'),
                            SizedBox(height: 8),
                            Text('No sunglasses'),
                            SizedBox(height: 8),
                            Text('No closing of eyes'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        print("submitted picture to verify");
                        if (verify()) {
                          // navigate to dietary tags selection screen
                          Navigator.pushNamed(context, '/interests');
                        } else {
                          // show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Verification failed. Please retake your selfie."))
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGray,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Submit to Verify"),
                    ),
                  ),

                  const SizedBox(height: 25),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}