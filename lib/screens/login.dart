
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/services.dart';

class LoginScreen extends StatefulWidget {
  createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  AuthService auth = AuthService();
  

  @override
  void initState() {
    super.initState();

     
  }


  @override
  Widget build(BuildContext context) {

    auth.user.first.then((value) {
      if (value!= null) {
          Navigator.pushReplacementNamed(context, '/page_principal');
          //Navigator.of(context).pushNamedAndRemoveUntil('/page_catalogo', (Route<dynamic> route) => false);
        }else{
          return scaffold();
        }
    });
    
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Widget scaffold (){
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/barcode.png',width: 100.0,height: 100.0,color: Colors.white,),
            Text(
              'Catalogo',
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            Text('👋'),
            LoginButton(
              text: 'INICIAR SESIÓN CON GOOGLE',
              icon: FontAwesomeIcons.google,
              color: Colors.black45,
              loginMethod: auth.googleSignIn,
            ),
            Row(
              crossAxisAlignment:CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/ic_launcher_commer.png',width: 30.0,height: 30.0),
                SizedBox(width: 8.0,),
                Text("Commer",style: TextStyle(fontSize: 18.0),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton(
      {Key key, this.text, this.icon, this.color, this.loginMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: FlatButton.icon(
        padding: EdgeInsets.all(30),
        icon: Icon(icon, color: Colors.white),
        color: color,
        onPressed: () async {
          var user = await loginMethod();
          if (user != null) {
            Navigator.of(context).pushNamedAndRemoveUntil('/page_principal', (Route<dynamic> route) => false);
          }
        },
        label: Expanded(
          child: Text('$text', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
