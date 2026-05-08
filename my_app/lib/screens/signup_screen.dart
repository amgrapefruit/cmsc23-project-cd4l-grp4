import 'package:flutter/material.dart';
import 'package:my_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final _form = GlobalKey<FormState>();

  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  final confirm = TextEditingController();

  // Branding colors
  static const Color primaryGreen = Color(0xFF2C6B3F);
  static const Color primaryOrange = Color(0xFFE9743F);

//insert api logic


  //signup
  void doSignup() async {
    if (!_form.currentState!.validate()) return;

    String? error = await context
      .read<AuthProvider>()
      .signUpWithEmailAndPassword(
        email.text, 
        pass.text, 
        name.text);

    setState(() {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created')),
      );

      //clear text fields
      name.clear();
      email.clear();
      pass.clear();
      confirm.clear();
    });
  }

//insert call signin...
  void googleSignup() async {
    
    String? error = await context
      .read<AuthProvider>()
      .signInWithGoogle();

    setState(() {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created')),
      );
    });
  }

  void fbSignup() async {
    
    String? error = await context
      .read<AuthProvider>()
      .signInWithFacebook();

    setState(() {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created')),
      );
    });
  }

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

                  // Added our logo here
                  Image.asset(
                    'lib/assets/logo.png',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 30),

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

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: email,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryGreen),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Email required";
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: pass,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryGreen),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Password required";
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: confirm,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryGreen),
                      ),
                    ),
                    validator: (v) {
                      if (v != pass.text) return "Passwords do not match";
                      return null;
                    },
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: doSignup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen, 
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Sign Up"),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("OR", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: googleSignup,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: const BorderSide(color: Colors.black12),
                      ),
                      child: const Text("Continue with Google"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: fbSignup,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: const BorderSide(color: Colors.black12),
                      ),
                      child: const Text("Continue with Facebook"),
                    ),
                  ),

                  /*For testing*/
                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<AuthProvider>().signOut();
                      },
                      child: const Text("Sign out"),
                    ),
                  ),
                  /** */

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have account? "),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}