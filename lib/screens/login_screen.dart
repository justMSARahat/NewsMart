import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// stateful use kortesi karon input change hobe
class _LoginScreenState extends State<LoginScreen> {

  // controller
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  // login function
  void loginUser() async {

    String email = emailController.text.trim();

    String password = passwordController.text.trim();

    // empty check
    if (email.isEmpty || password.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );

      return;
    }

    try {

      // firebase login
      await FirebaseAuth.instance.signInWithEmailAndPassword(

        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text("Login Successful"),
        ),
      );

      // login successful hole home screen e jabe
      Navigator.pushReplacement(

        context,

        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text("Invalid Email or Password"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    // responsive width
    double width = MediaQuery.of(context).size.width;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Login"),
      ),

      body: Padding(
        padding: EdgeInsets.all(width * 0.05),

        child: Column(

          children: [

            // email field
            TextField(

              controller: emailController,

              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // password field
            TextField(

              controller: passwordController,

              obscureText: true,

              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // login button
            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: loginUser,

                child: const Text("Login"),
              ),
            ),

            const SizedBox(height: 10),

            // register page button
            TextButton(

              onPressed: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },

              child: const Text(
                "Don't have account? Register",
              ),
            ),
          ],
        ),
      ),
    );
  }
}