import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


void VerifyPhone(BuildContext context, String phoneNumber) {

  Alert(
    title: 'Title',
    context: context,
    content: ContentVerify(phoneNumber: phoneNumber,),

    buttons: [
      DialogButton(
        child: Text('Done'),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      )
    ]
  ).show();
}



class ContentVerify extends StatefulWidget {

  String phoneNumber;
  ContentVerify({this.phoneNumber});
  @override
  _ContentVerifyState createState() => _ContentVerifyState();
}

class _ContentVerifyState extends State<ContentVerify> {


  String phoneNo, verificationId, smsCode;
  bool codeSent;

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      FirebaseAuth.instance.signInWithCredential(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }


  @override
  void initState() {
    verifyPhone(widget.phoneNumber);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        onChanged: (value) {
          smsCode = value;
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
    );
  }
}
