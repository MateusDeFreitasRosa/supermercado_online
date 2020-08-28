import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:supermercado_virtual/screens/tab_bar_sreen.dart';

class WaitForConfirmationOfEmail extends StatefulWidget {
  static String id = '/waitForConfirmationOfEmail';
  @override
  _WaitForConfirmationOfEmailState createState() => _WaitForConfirmationOfEmailState();
}

class _WaitForConfirmationOfEmailState extends State<WaitForConfirmationOfEmail> {

  final _fireAuth = FirebaseAuth.instance;
  BuildContext _context;
  void verifyIfIsConfirm() async{
    FirebaseUser user = await _fireAuth.currentUser().then((u) => u.reload().then((_) => _fireAuth.currentUser()));

    if (user != null) {
      print(user.isEmailVerified);
      if (user.isEmailVerified) {
        Future.delayed(Duration(seconds: 1)).then((value) {
          Navigator.popAndPushNamed(context, TabBarScreen.id);
        });
      }
      else {
        Future.delayed(Duration(seconds: 2)).then((value) {
          verifyIfIsConfirm();
        });
      }
    }
  }

  void sendVerificationCode() async{
    try {
      final  user = await _fireAuth.currentUser();
      if (user != null) {
        await user.sendEmailVerification();
      }
    }catch(e) {
      print(e);
    }
  }

  @override
  void initState() {
    sendVerificationCode();
    verifyIfIsConfirm();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Material(
                    color: Colors.white70,
                    elevation: 2,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        'Enviamos um link de confirmação de conta para seu email!',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),


                SizedBox(height: MediaQuery.of(context).size.height/12,),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Material(
                    elevation: 2,
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Abra seu email e confirme seu email, clicando no link que enviamos para prosseguir.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height/8,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Material(
                    elevation: 2,
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Estamos aguardando sua verificação!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Container(
                    width: 200,
                    height: 100,
                    child: FlareActor(
                      'images/loading-animation-sun-flare.flr',
                      animation: 'active',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),SizedBox(height: MediaQuery.of(context).size.height/10,),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Material(
                    color: Colors.lightBlue,
                    elevation: 2,
                    borderRadius: BorderRadius.circular(10),
                    child: MaterialButton(
                      onPressed: () {
                        print('Resend link');
                        sendVerificationCode();
                      },
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        'Reenviar link',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
    );
  }
}
