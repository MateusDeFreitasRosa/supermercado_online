import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:supermercado_virtual/controllers/criptografia.dart';
import 'package:supermercado_virtual/controllers/date.dart';
import 'package:supermercado_virtual/widgets/receipt.dart';

class MyRequests extends StatefulWidget {

  @override
  _MyRequestsState createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {

  final _fireAuth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;
  List<Widget> _list = [];
  bool _progress = false;

  void getData() async{
    try {
      setState(() {
        _progress = true;
      });
      final user =  await _fireAuth.currentUser();
      final dataUser = await _fireStore.collection('User').document(Criptografia.encode(user.email)).collection('requests').getDocuments();

      if (dataUser != null) {
        dataUser.documents.forEach((element) async{
          final store = await _fireStore.collection('stores').document(element['store']).get();

          Timestamp dateTimestamp = element['dateTime'];
          DateTime dateTime = dateTimestamp.toDate();

          if (store != null) {
            setState(() {
              _list.add(
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Material(
                      elevation: 2,
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.motorcycle),
                        title: Text(store.data['name']),
                        trailing: Text(formatDate(dateTime)),
                        subtitle: Text('Entrega: '+element['status']),
                        onTap: () {
                          String formOfPayment;
                          if (element['cardPayment']) {
                            formOfPayment = 'card';
                          }
                          else if (element['maneyPayment']){
                            formOfPayment = 'maney';
                          }
                          receipt(context, element['status'], formOfPayment, dateTime, element['deliveryAdress'],
                              element['products'], store, element['totalPrice']);
                        },
                      ),
                    ),
                  )
              );
            });
          }
        });
      }
      setState(() {
        _progress = false;
      });
    }catch(e) {
      print(e);
      setState(() {
        _progress = false;
      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  var styleText = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold
  );

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _progress,
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: ListView(
            children:  _progress == true ?
               [
                 ListTile(
                   title: Text(
                     'Estamos carregando seus dados!',
                     style: styleText,
                   ),
                   leading: Icon(Icons.find_in_page, color: Colors.white, size: 50,),
                 )
               ] : _list.length != 0 ? _list :  [
              ListTile(
                title: Text(
                    'Não há histórico de compras',
                  style: styleText,
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
