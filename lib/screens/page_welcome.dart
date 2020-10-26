import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
navigateUser() {
    //TODO: Verificar metodo de authenticacion
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        Timer(Duration(seconds: 2),() => Navigator.pushReplacementNamed(context, "/login"));
      } else {
        Timer(
          Duration(seconds: 2),
          () => Navigator.pushReplacementNamed(context, '/page_principal')
        );
      }
    });
  }

  @override
  void initState() {
    navigateUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
          child: Text(". . ."),
        ),
      );
    
  }
}
