import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:supermercado_virtual/controllers/AlertErros.dart';
import 'file:///C:/Users/mateu/AndroidStudioProjects/supermercado_virtual/lib/controllers/criptografia.dart';
import 'package:supermercado_virtual/screens/waitForConfirmation.dart';


class Registration extends StatefulWidget {
  static String id = '/Registration';

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _fireAuth = FirebaseAuth.instance;

  final _fireStore = Firestore.instance;

  String name;
  String email;
  String phoneNumber;
  String password;
  bool progress = false;
  String smsCode;

  var textEditingController = TextEditingController();
  var maskTextInputFormatter = MaskTextInputFormatter(mask: "(##) # ####-####", filter: { "#": RegExp(r'[0-9]') });

  void registerUser (BuildContext context) async{
    try {
      setState(() {
        progress = true;
      });
      final newUser = await _fireAuth.createUserWithEmailAndPassword(email: email, password: Criptografia.encode(password));
      if (newUser != null) {
        _fireStore.collection('User').document(Criptografia.encode(email)).setData({
          'name': name,
          'phoneNumber': phoneNumber,
        });
        _fireAuth.signInWithEmailAndPassword(email: email, password: Criptografia.encode(password));
        Navigator.pushNamed(context, WaitForConfirmationOfEmail.id);
      }

      setState(() {
        progress = false;
      });
    }catch(e) {
      AlertBtnErros(context: context, error: e.code, icon: Icon(Icons.mood_bad, size: 100.0, color: Colors.grey,));
    }finally {
      setState(() {
        progress = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: progress,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Hero(
                        tag: 'logo',
                        child: Image(
                          image: AssetImage('images/logoHorizontalWB.png'),
                          height: 100,
                        ),
                      ),
                    ),

                    Container(
                      height: 65,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      child: TextField(
                        onChanged: (value) {
                          name = value;
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
                          hintText: 'Nome completo',
                          prefixIcon: Icon(Icons.perm_identity, color: Colors.white,),
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
                          email = value;
                        },
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decorationStyle: TextDecorationStyle.dashed,

                        ),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          hintText: 'E-mail',
                          prefixIcon: Icon(Icons.alternate_email, color: Colors.white,),
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
                          phoneNumber = value;
                        },
                        controller: textEditingController,
                        inputFormatters: [maskTextInputFormatter],
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
                          hintText: 'Numero deste celular',
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

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      child: Container(
                        height: 50,

                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white30, width: 2),
                          color: Colors.lightGreen,
                        ),
                        child: FlatButton(
                          onPressed: () {
                            registerUser(context);
                          },
                          child: Text(
                            'Registrar',
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
