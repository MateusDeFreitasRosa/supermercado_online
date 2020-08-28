import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:supermercado_virtual/controllers/AlertErros.dart';
import 'package:supermercado_virtual/controllers/criptografia.dart';
import 'package:supermercado_virtual/screens/register.dart';
import 'package:supermercado_virtual/screens/tab_bar_sreen.dart';
import 'package:supermercado_virtual/screens/waitForConfirmation.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = '/WelcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _fireAuth = FirebaseAuth.instance;

  String email;

  String password;

  bool freeze=false;

  void login(BuildContext context) async{
    try {
      setState(() {
        freeze=true;
      });
      if (email != null && password != null)  {
        _fireAuth.signInWithEmailAndPassword(email: email, password: Criptografia.encode(password)).then((value) async{
          final user = await _fireAuth.currentUser();
          print("Entrou");
          if (user.isEmailVerified) {
            Navigator.popAndPushNamed(context, TabBarScreen.id);
          }
          else {
            Navigator.pushNamed(context, WaitForConfirmationOfEmail.id);
          }

        }).catchError((onError) {
          AlertBtnErros(context: context, error: onError.code, icon: Icon(Icons.mood_bad, size: 100.0, color: Colors.grey,));
        });
      }
    }catch(e) {
      AlertBtnErros(context: context, error: e.code, icon: Icon(Icons.mood_bad, size: 100.0, color: Colors.grey,));
    }finally {
      setState(() {
        freeze=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return ModalProgressHUD(
      inAsyncCall: freeze,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.png'),
                fit: BoxFit.fill,
              )
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Hero(
                          tag: 'logo',
                          child: Image(
                            image: AssetImage('images/logoWB.png'),
                            height: 150,
                          ),
                        )
                    ),
                    SizedBox(height: 10,),

                    Container(
                      height: 65,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      child: TextField(
                        onChanged: (value) {
                          email = value;
                        },
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decorationStyle: TextDecorationStyle.dashed
                        ),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          hintText: 'E-mail',
                          prefixIcon: Icon(Icons.phone, color: Colors.white,),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),

                        ),
                      ),
                    ),

                    Container(
                      height: 65,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      child: TextField(
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: true,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decorationStyle: TextDecorationStyle.dashed
                        ),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          hintText: 'Senha',
                          prefixIcon: Icon(Icons.lock, color: Colors.white,),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),

                        ),
                      ),
                    ),
                    SizedBox(height: 20,),


                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        height: 50,

                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white30, width: 2),
                          color: Colors.lightBlue,
                        ),
                        child: FlatButton(
                          onPressed: () {
                            login(context);
                          },
                          child: Text(
                            'Entrar',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      height: 0,
                      child: Divider(
                        thickness: 2,
                        color: Colors.white12,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            color: Colors.white30
                        ),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Registration.id);
                          },
                          child: Text(
                            'Criar uma conta',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
