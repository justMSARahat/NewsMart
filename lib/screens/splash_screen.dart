// async package import kortesi
// Timer use korar jonno eta lagbe
import 'dart:async';

// flutter material design widget import
// Scaffold, Text, Column, Icon etc use korar jonno
import 'package:flutter/material.dart';

// next screen import
// splash sesh hole welcome screen e jabe
import 'welcome_screen.dart';

// SplashScreen name er widget create kortesi
// StatefulWidget use kortesi karon screen dynamic kaj korbe
class SplashScreen extends StatefulWidget {

  // constructor
  // super.key widget identify korte help kore
  const SplashScreen({super.key});

  // createState() state object create kore
  // StatefulWidget er sathe state connect kore
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// _ diye private class bujhay
// ei file er baire use kora jabe na

// State<SplashScreen>
// mane ei state SplashScreen widget er state manage korbe

// stateful use kortesi karon delay + navigation hobe
class _SplashScreenState extends State<SplashScreen> {

  // initState screen load howar sathe sathe ekbar run hoy
  @override
  void initState() {

    // parent class er initState call
    // eta always use kora good practice
    super.initState();

    // custom function call
    // timer start hobe
    goToWelcome();
  }

  // custom function create kortesi
  // next screen e jawar kaj korbe
  void goToWelcome() {

    // Timer function
    // specific time pore code run korbe

    // const Duration(seconds: 3)
    // mane 3 second wait korbe

    Timer(const Duration(seconds: 3), () {

      // Navigator screen change kore

      // pushReplacement
      // current screen remove kore next screen open kore

      // splash screen e back ashbe na
      Navigator.pushReplacement(

        // current widget er context
        // navigation er jonno lagbe
        context,

        // MaterialPageRoute
        // screen transition animation handle kore
        MaterialPageRoute(

          // builder next screen create kore
          builder: (context) => const WelcomeScreen(),
        ),
      );
    });
  }

  // build function UI create kore
  // Flutter repeatedly build call korte pare
  @override
  Widget build(BuildContext context) {

    // MediaQuery current screen info dey

    // screen width nicchi responsive design er jonno
    double width = MediaQuery.of(context).size.width;

    // Scaffold page structure create kore
    return Scaffold(

      // body main content area
      body: Center(

        // Center widget sobkichu center e ane
        child: Column(

          // Column vertically widget arrange kore

          // mainAxisAlignment center
          // vertically center korbe
          mainAxisAlignment: MainAxisAlignment.center,

          // children list er moddhe sob widget thakbe
          children: [

            // newspaper icon show korbe

            // width * 0.25
            // responsive icon size
            Icon(

              Icons.newspaper,

              size: width * 0.25,
            ),

            // gap create korar jonno
            const SizedBox(height: 20),

            // app name
            Text(

              "NewsMart",

              // text design
              style: TextStyle(

                // responsive font size
                fontSize: width * 0.09,

                // bold text
                fontWeight: FontWeight.bold,
              ),
            ),

            // spacing
            const SizedBox(height: 10),

            // subtitle text
            const Text("Anything Anywhere Anytime"),
          ],
        ),
      ),
    );
  }
}