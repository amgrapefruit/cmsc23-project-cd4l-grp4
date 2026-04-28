// no logo, icons, design yet 

import 'package:flutter/material.dart';
import 'package:my_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
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

//instantiate api here

  //login
  //for form checking if may laman
  void doLogin() {
    if (!_form.currentState!.validate()) return;



    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login success')),
    );

    //clear after
    email.clear();
    pass.clear();
  }



  void googleLogin() {
    
    //insert call the sign in...
    print("google login tapped");
  }

  void fbLogin() {
    print("fb login tapped");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _form,
              child: Column(
                children: [

                  const SizedBox(height: 30),

                  const Text(
                    "Welcome Back!",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Good to see you again",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 40),

                  TextFormField(
                    controller: email,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
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
                      child: const Text("Forgot password?"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: doLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Login"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Text("  OR  "),
                      Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: googleLogin,
                      child: const Text("Continue with Google"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: fbLogin,
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
                        child: const Text("Sign up"),
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