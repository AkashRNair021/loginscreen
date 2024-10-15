import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loginscreen/homepage.dart';
import 'package:loginscreen/signinscreen.dart';
import 'package:loginscreen/signupscreen.dart';
import 'firebase_options.dart';  // Generated file for Firebase options

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(LetsEscapeApp());
}

class LetsEscapeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'Let\'s Escape',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/signup': (context) => SignUpScreen(),
        '/signin': (context) => SignInScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(

        fit: StackFit.expand,
        children: <Widget>[
          // Background image
          Image.asset(
            'assets/palm.jpeg',  
            fit: BoxFit.cover,
          ),
          // Content over the background
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Mastercard logo and "Let's Escape" text
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mastercard logo
                      Image.asset(
                        'assets/mastercard_logo.png', 
                        width: 60,
                      ),
                      SizedBox(height: 10),
                      // "Let's Escape" text
                      Text(
                        'Let\'s Escape',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),  // Push buttons to the bottom-right
                // Buttons positioned to bottom-right
                Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right:0, bottom: 10.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 80),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text('Sign up'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 0, bottom: 20.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.orange,
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.orange, width: 2),
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 80),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/signin');
                          },
                          child: Text('Sign in'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
