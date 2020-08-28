import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:supermercado_virtual/screens/tab_bar_sreen.dart';
import 'package:supermercado_virtual/screens/welcome_screen.dart';

void AlertInfoVerifyEmail(BuildContext context) {

  String message = '';
  Alert(
    context: context,
    style: AlertStyle(
      isCloseButton: false,
    ),
    content: Content(),
    title: 'Confirme seu emaiil para prosseguir!!!',
    type: AlertType.info,
    buttons: [
      DialogButton(
        onPressed: () async{
          final _fireAuth = FirebaseAuth.instance;

          try {
            final user = await _fireAuth.currentUser();
            if (user != null) {
              print(user.isEmailVerified);
              if (user.isEmailVerified) {
                Navigator.popAndPushNamed(context, TabBarScreen.id);
              }
              else {
                Navigator.popAndPushNamed(context, WelcomeScreen.id);
              }
            }
          }catch(e) {
            print(e);
          }
        },
        child: Text('Email confirmado'),
      ),
      DialogButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, WelcomeScreen.id);
        },
        child: Text('Fechar'),
      ),
    ],
  ).show();
}

class Content extends StatefulWidget {
  @override
  ContentState createState() => ContentState();
}

class ContentState extends State<Content>
  {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
              'Porfavor acesse o link que enviamos ao seu e-mail para confirmar sua conta!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black
            ),
          ),
          Icon(Icons.email),
        ],
      ),
    );
  }
}
