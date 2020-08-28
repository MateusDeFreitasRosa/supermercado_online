import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:supermercado_virtual/screens/list_lojas_screen.dart';
import 'package:supermercado_virtual/screens/my_requests.dart';
import 'package:supermercado_virtual/screens/profile_screen.dart';


class TabBarScreen extends StatefulWidget {
  static String id = '/TabBarScreen';

  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {

  final _fireAuth = FirebaseAuth.instance;

  void verifyIfUserIsVerified() async{
    try {
      final user = await _fireAuth.currentUser();
      if (user != null) {
        print(user.isEmailVerified);
      }
    }catch(e) {
      print(e);
    }
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
    ListStoresScreen(),
    Text(
      'Index 1: Search',
      style: optionStyle,
    ),
    MyRequests(),
    Profile(),
  ];


  @override
  void initState() {
    verifyIfUserIsVerified();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SafeArea(
        child: Material(
          elevation: 2,
          color: Colors.tealAccent[400],
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: GNav(
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                duration: Duration(milliseconds: 800),
                tabBackgroundColor: Colors.deepPurple[300],
                tabs: [
                  GButton(
                    icon: Icons.store,
                    text: 'Lojas',
                  ),
                  GButton(
                    icon: Icons.search,
                    text: 'Buscar',
                  ),
                  GButton(
                    icon: Icons.motorcycle,
                    text: 'Pedidos',
                  ),
                  GButton(
                    icon: Icons.person_outline,
                    text: 'Perfil',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
    );
  }
}
