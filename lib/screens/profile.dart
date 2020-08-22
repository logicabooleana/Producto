import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:catalogo/services/preferencias_usuario.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService auth = AuthService();

  /* Declarar variables */
  PreferenciasUsuario prefs;

  @override
  Widget build(BuildContext context) {

    prefs = new PreferenciasUsuario();
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    if (user != null) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(user.displayName ?? 'Guest'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (user.photoUrl != null)
              Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(user.photoUrl),
                  ),
                ),
              ),
            Text(user.email ?? '', style: Theme.of(context).textTheme.headline),
            Spacer(),
            Text('Quizzes Completed',
                style: Theme.of(context).textTheme.subhead),
            Spacer(),
            FlatButton(
                child: Text('logout'),
                color: Colors.red,
                onPressed: () async {
                  await auth.signOut();
                  prefs.setIdNegocio="";
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                }),
            Spacer()
          ],
        ),
      ),
    );
    } else {
      return LoadingScreen();
    }
  }

}