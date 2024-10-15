import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Import the required Google Sign-In package
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loginscreen/homepage.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _email, _password;
  String? _errorMessage;
  bool isLoading = false; // To manage loading state

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => isLoading = true);
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );
        print("User signed in: ${userCredential.user?.email}");
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
        print("Sign-in failed: $e");
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // if (googleUser == null) {
      //   // User canceled the sign-in process
      //   setState(() => isLoading = false);
      //   return;
      // }

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final user = await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Home(user: user.user!)));
    } catch (e) {
      print(e);
      setState(() {
        _errorMessage = e.toString();
      });
      print("Google Sign-In failed: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/palm.jpeg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Bottom sheet container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: <Widget>[
                          // Email Field
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              prefixIcon: Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) => _email = value,
                            validator: (value) {
                              if (value == null || !value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          // Password Field
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              prefixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                            onSaved: (value) => _password = value,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          // Sign-In Button
                          isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _signIn,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 100),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text('Sign In'),
                                ),
                          SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              // Handle Forgot Password
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 20),
                          // Or Sign in with Google or Facebook
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: _signInWithGoogle,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.g_mobiledata,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  // Handle Facebook sign-in
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child:
                                      Icon(Icons.facebook, color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
