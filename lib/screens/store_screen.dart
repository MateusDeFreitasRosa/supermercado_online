import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:supermercado_virtual/models/products_model.dart';
import 'package:supermercado_virtual/models/store_model.dart';
import 'package:supermercado_virtual/widgets/bannerPage.dart';
import 'package:supermercado_virtual/widgets/card_products.dart';
import 'package:supermercado_virtual/widgets/cards_store_widget.dart';

class StoreScreen extends StatefulWidget {
  static String id = 'StoreScreen';

  StoreScreen({this.store});
  Store store;

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {

  final _fireStore = Firestore.instance;

  List<Products> _products = [];
  List<Products> _doubleProducts = [];
  bool _progress = false;


  void getProducts() async{
    try{
      _doubleProducts.clear();
      _products.clear();
      var verify = await _fireStore.collection('stores').document(widget.store.id).collection('products').getDocuments();
      print(verify.documents.length);
      if (verify.documents.length > 0) {
        await for( var snapshot in _fireStore.collection('stores').document(widget.store.id).collection('products').snapshots()) {
          for(var products in snapshot.documents) {
            if (products.data['inStock'] == true) {
              List<String> imgs = [];

              if (products.data['images'] != null) {
                for(var img in products.data['images']) {
                  StorageReference storageReference = FirebaseStorage.instance.ref().child(img);
                  var urlPhoto = await storageReference.getDownloadURL();
                  imgs.add(urlPhoto);
                }
              }

              double priceParse = double.parse(products.data['price'].toString());
              Products p = Products(title: products.data['title'], description: products.data['description'],
                  inStock: products.data['inStock'], price: priceParse ,images: imgs, id: products.documentID);

              setState(() {
                _products.add(p);
                _doubleProducts.add(p);
              });
            }
          }
        }
      }
    }catch(e) {
      print('Nothing: '+e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
  }


  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return ModalProgressHUD(
      inAsyncCall: _progress,
      child: Scaffold(

        floatingActionButton: FloatingActionButton(
          elevation: 2,
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.add_shopping_cart, color: Colors.white,),
          onPressed: () {
            open_card_store(context: context,storeID: widget.store.id);
          },
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return new Future.delayed(const Duration(seconds: 2), () {});
          },
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  //Banner***
                  child: BannerPage(store: widget.store,),
                ),
                Container(

                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Container(
                            height: 50,
                            child: TextField(

                              onChanged: (value) {
                                setState(() {
                                  _doubleProducts.clear();
                                });
                                _products.forEach((data) {
                                  if (data.title.toLowerCase().contains(value.toLowerCase()) ||
                                      data.description.toLowerCase().contains(value.toLowerCase())) {
                                    setState(() {
                                      _doubleProducts.add(data);
                                    });
                                  }
                                });

                               },
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 18
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                  hintText: 'Procurar uma produto',
                                  hintStyle: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )
                              ),
                            ),
                          ),
                        ),
                        _doubleProducts.length == 0 ? Text('Nenhum produto encontrado nessa loja',style: TextStyle(color: Colors.white),) : Container(height: 0,width: 0,)
                      ],
                    )
                ),
                Expanded(
                  child: GridView.builder(
                      itemCount: _doubleProducts == null ? 0 : _doubleProducts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                          childAspectRatio: .68),
                      itemBuilder: (context, index) {
                        return CardProducts(products: _doubleProducts[index],
                          storeID: widget.store.id,);
                      }
                  ),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}






