import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:supermercado_virtual/models/store_model.dart';
import 'package:supermercado_virtual/screens/teste.dart';
import 'package:supermercado_virtual/widgets/card_store.dart';


class ListStoresScreen extends StatefulWidget {
  static String id = 'ListStoresScreen';
  @override
  _ListStoresScreenState createState() => _ListStoresScreenState();
}

class _ListStoresScreenState extends State<ListStoresScreen> {

  List<Store> _stores = [];
  List<Store> _doubleStores = [];
  final _fireStore = Firestore.instance;
  String _searchStore;


  void getData() async{
    try {
      _stores.clear();
      _doubleStores.clear();
      await for( var snapshot in _fireStore.collection('stores').snapshots()) {
        for(var store in snapshot.documents) {
          String fileName = store.data['imageStore'];
          StorageReference storageReference = FirebaseStorage.instance.ref().child(fileName);
          var urlPhoto = await storageReference.getDownloadURL();

          //var urlPhoto = store.data['name']+'.jpg';
          double _rateDelivery = double.parse(store.data['deliveryRate'].toString());

          Store s = new Store(title: store.data['name'], description: store.data['description'], image: urlPhoto,
              phoneNumber: store.data['phoneNumber'], deliveryRate: _rateDelivery, adress: store.data['adress'], id: store.data['id']);

          setState(() {
            _stores.add(s);
            _doubleStores.add(s);
          });
          print('URL Image:  '+ urlPhoto);
        }
      }
    }catch(e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Algum erro ocorreu, tente novamente!'),));
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        child: RefreshIndicator(
          child: ListView.builder(
              itemCount: _doubleStores == null ||  _doubleStores.length == 0
                  ? 1
                  : _doubleStores.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                            color: Colors.deepPurple[300],
                          ),
                          height: 59,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),

                            child: TextField(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                              onChanged: (value) {
                               setState(() {
                                 _doubleStores.clear();
                               });
                               _stores.forEach((data) {
                                 if (data.title.toLowerCase().contains(value.toLowerCase()) ||
                                     data.description.toLowerCase().contains(value.toLowerCase())) {
                                   setState(() {
                                     _doubleStores.add(data);
                                   });
                                 }
                               });
                               print(_doubleStores.length);

                              },

                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                
                                hintText: 'Procurar uma loja',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                  height: .5,
                                ),
                                border: OutlineInputBorder(

                                )
                              ),
                            ),
                          ),
                        ),
                        _doubleStores.length == 0 ? Text('Nenhuma loja encontrada') : CardStore(data: _doubleStores[index], auxContext: context,)
                      ],
                    )
                  );
                }
                else {
                  return CardStore(data: _doubleStores[index], auxContext: context,);
                }
              }
          ),
          onRefresh: () {
            return new Future.delayed(const Duration(seconds: 2), () {});
          }
        )
    );
  }
}