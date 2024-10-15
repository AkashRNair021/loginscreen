import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authservices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();  // Corrected this line

  // Stream to listen to user authentication state changes
  Stream<User?> get userState {
    return _auth.authStateChanges();
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;  // User canceled the Google Sign-In
      }

      final googleAuth = await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(cred);
      return userCredential;
    } catch (e) {
      print("Google Sign-In Error: ${e.toString()}");
      return null;
    }
  }

  // Sign in anonymously
  Future<User?> signinAnonymously() async {
    try {
      UserCredential res = await _auth.signInAnonymously();  // Corrected declaration
      User? user = res.user;
      return user;
    } catch (e) {
      print("Anonymous Sign-In Error: ${e.toString()}");
      return null;
    }
  }
}
