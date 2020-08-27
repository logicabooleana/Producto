import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'dart:async';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firebase user one-time fetch
  Future<FirebaseUser> get getUser => _auth.currentUser();

  // Firebase user a realtime stream
  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  // Determine if Apple Signin is available on device
  Future<bool> get appleSignInAvailable => AppleSignIn.isAvailable();

  /// Sign in with Apple
  Future<FirebaseUser> appleSignIn() async {
    try {
      final AuthorizationResult appleResult =
          await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      if (appleResult.error != null) {
        // handle errors from Apple
      }

      final AuthCredential credential =
          OAuthProvider(providerId: 'apple.com').getCredential(
        accessToken:
            String.fromCharCodes(appleResult.credential.authorizationCode),
        idToken: String.fromCharCodes(appleResult.credential.identityToken),
      );

      AuthResult firebaseResult = await _auth.signInWithCredential(credential);
      FirebaseUser user = firebaseResult.user;

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  /// Inicia sesión con Google
  Future<FirebaseUser> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  /// Anonymous Firebase login
  Future<FirebaseUser> anonLogin() async {
    AuthResult result = await _auth.signInAnonymously();
    FirebaseUser user = result.user;

    return user;
  }

  // Sign out // desconectar
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    return await  _auth.signOut();
  }
}
