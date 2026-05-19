import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // responsive width
    double width = MediaQuery.of(context).size.width;

    return Scaffold(

      body: Padding(
        padding: EdgeInsets.all(width * 0.05),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(
              Icons.newspaper,
              size: width * 0.3,
            ),

            const SizedBox(height: 20),

            Text(

              "NewsMart",

              style: TextStyle(
                fontSize: width * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Anything Anywhere Anytime",
            ),

            const SizedBox(height: 40),

            // login button
            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },

                child: const Text("Login"),
              ),
            ),

            const SizedBox(height: 15),

            // register button
            SizedBox(

              width: double.infinity,

              child: OutlinedButton(

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },

                child: const Text("Register"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}