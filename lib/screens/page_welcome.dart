import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Producto/shared/progress_bar.dart';
import 'package:Producto/services/globals.dart';

class SplashScreen extends StatefulWidget {
  createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  navigateUser() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        Global.user=null;
        Timer(Duration(seconds: 2),() => Navigator.pushReplacementNamed(context, "/login"));
      } else {
        Global.user=user;
        Timer(Duration(seconds: 2),() => Navigator.pushReplacementNamed(context, '/page_principal'));
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
        child: WidgetLoadingInit(),
      ),
    );
  }
}
