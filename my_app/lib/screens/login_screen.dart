import 'package:flutter/material.dart';
import 'signup_screen.dart';
//import api here, i did not import cause chineck ko lang iyong screen


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _form = GlobalKey<FormState>();

  final email = TextEditingController();
  final pass = TextEditingController();

  // Branding colors
  static const Color primaryGreen = Color(0xFF2C6B3F); 
  static const Color primaryOrange = Color(0xFFE9743F); 
  static const Color greyText = Colors.grey;

//instantiate api here

  //login
  //for form checking if may laman
  void doLogin() {
    if (!_form.currentState!.validate()) return;


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login success')),
    );


    email.clear();
    pass.clear();
  }



  void googleLogin() {
    
   
    print("google login tapped");
  }

  void fbLogin() {
    print("fb login tapped");
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

                  const SizedBox(height: 60),

                  // Added our logo
                  Image.asset(
                    'lib/assets/logo.png',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 50),

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

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        print("forgot password");
                      },
                      child: const Text(
                        "Forgot password?", 
                        style: TextStyle(color: primaryOrange),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: doLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen, 
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Login"),
                    ),
                  ),

                  const SizedBox(height: 30),

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
                      onPressed: googleLogin,
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
                      onPressed: fbLogin,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: const BorderSide(color: Colors.black12),
                      ),
                      child: const Text("Continue with Facebook"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No account yet? "),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignupScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign up",
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