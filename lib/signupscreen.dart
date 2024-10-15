import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _email, _password, _confirmPassword;
  bool _agreeToTerms = false;
  String? _errorMessage;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );
        print("User signed up: ${userCredential.user?.email}");
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
        print("Sign-up failed: $e");
      }
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
              height: MediaQuery.of(context).size.height * 0.7,
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
                      "Create Account",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Expanded(
                        child: ListView(
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
                              onChanged: (value) => _password = value,
                              validator: (value) {
                                if (value == null || value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            // Confirm Password Field
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                prefixIcon: Icon(Icons.lock),
                              ),
                              obscureText: true,
                              onChanged: (value) => _confirmPassword = value,
                              validator: (value) {
                                if (value != _password) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            // Agree to Terms Checkbox
                            Row(
                              children: [
                                Checkbox(
                                  value: _agreeToTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      _agreeToTerms = value ?? false;
                                    });
                                  },
                                ),
                                Text("I have read and agree to the "),
                                GestureDetector(
                                  onTap: () {
                                    // Handle T&C tap
                                  },
                                  child: Text(
                                    "T&C",
                                    style: TextStyle(
                                      color: Colors.orange,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (_errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            // Sign-Up Button
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _signUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 100),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text('Sign up'),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
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
