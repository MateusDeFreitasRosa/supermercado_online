import 'package:flutter/material.dart';
import 'file:///C:/Users/mateu/AndroidStudioProjects/supermercado_virtual/lib/controllers/connection_Cart.dart';
import 'package:supermercado_virtual/screens/register.dart';
import 'package:supermercado_virtual/screens/store_screen.dart';
import 'package:supermercado_virtual/screens/tab_bar_sreen.dart';
import 'package:supermercado_virtual/screens/teste.dart';
import 'package:supermercado_virtual/screens/waitForConfirmation.dart';
import 'package:supermercado_virtual/screens/welcome_screen.dart';


void main() => runApp(supermercado_virtual());


class supermercado_virtual extends StatefulWidget {
  @override
  _supermercado_virtualState createState() => _supermercado_virtualState();
}

class _supermercado_virtualState extends State<supermercado_virtual> {

  @override
  void initState() {

    try {
      DB.init();
    }catch(e) {
      print(e);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        primaryColorDark: Color(0xff2E2E2E),
        primaryColorLight: Color(0xffE6E6E6),
        scaffoldBackgroundColor: Color(0xff2E2E2E),
      ),
      initialRoute: WelcomeScreen.id,

      routes: {
        TabBarScreen.id : (context)=> TabBarScreen(),
        StoreScreen.id : (context) => StoreScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        Registration.id: (context) => Registration(),
        WaitForConfirmationOfEmail.id: (context) => WaitForConfirmationOfEmail(),
        Teste.id: (context) => Teste(),
      },
    );;
  }
}