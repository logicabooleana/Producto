import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:producto/services/preferencias_usuario.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService auth = AuthService();

  /* Declarar variables */
  PreferenciasUsuario prefs;

  @override
  Widget build(BuildContext context) {

    prefs = new PreferenciasUsuario();
    User user = Provider.of<User>(context);

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
            if (user.photoURL != null)
              Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(user.photoURL),
                  ),
                ),
              ),
            Text(user.email ?? '', style: Theme.of(context).textTheme.headline4),
            Spacer(),
            Text('Quizzes Completed',
                style: Theme.of(context).textTheme.subtitle1),
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
      return Container();
    }
  }

}
