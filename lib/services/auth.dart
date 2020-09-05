import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  

  // Firebase user one-time fetch
  //Future<User> get getUser => _auth.;

  // Firebase user a realtime stream
  Stream<User> get user => _auth.authStateChanges(); // Stream<User> get user => _auth.authStateChanges();



  

 
  Future<User> googleSignIn() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
     );

    // Once signed in, return the UserCredential
  UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

  return userCredential.user;
}

  

  // Sign out // desconectar
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    return await  _auth.signOut();
  }
}
