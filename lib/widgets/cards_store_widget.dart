import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'file:///C:/Users/mateu/AndroidStudioProjects/supermercado_virtual/lib/controllers/connection_Cart.dart';
import 'package:supermercado_virtual/models/products_model.dart';
import 'package:supermercado_virtual/screens/buy_card.dart';


void open_card_store({BuildContext context, String storeID}) async{

  final _fireAuth = FirebaseAuth.instance;
  final user = await _fireAuth.currentUser();
  String where = 'ID_STORE = "$storeID" AND EMAIL_USER = "${user.email}"';
  var data = await DB.find(DB.tableProduct, where);
  print(data.isEmpty);
  if (data.isEmpty) {
    Alert(
      context: context,
      title: 'Não há produtos dessa loja em seu carrinho!',
      buttons: [
        DialogButton(
          child: Text(
              'Fechar',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        )
      ],
      style: AlertStyle(isCloseButton: false, )
    ).show();
  }
  else {
    Alert(
        context: context,
        title: 'Carrinho',
        content: _Cards(storeID: storeID,),
        buttons: [
          DialogButton(
            child: Text(
              'Fechar',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          DialogButton(
            color: Colors.green,
            child: Text(
              'Adquirir carrinho',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BuyCard(storeId: storeID,);
              }));
            },
          )
        ],
        style: AlertStyle(isCloseButton: false),
    ).show();

  }
}
/*
class _modelCards extends StatelessWidget {
  _modelCards({this.products});
  Products products;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            
            child: products.images.length == 0
                  ? Image.asset('withoutImage.jpg')
                  : Image.network(products.images.elementAt(0)),
          ),
          Container(
            child: Text(
              products.title,
            ),
          ),
          Container(
            child: Text(
              products.price.toString(),
            ),
          )
        ],
      ),
    );
  }
}
*/

class _Cards extends StatefulWidget {

  _Cards({this.storeID});
  String storeID;

  @override
  __CardsState createState() => __CardsState();
}

class __CardsState extends State<_Cards> {
  List<Widget> _model = [];
  final _firebase = Firestore.instance;
  final _fireAuth = FirebaseAuth.instance;

  void deleteProduct(int id, String userEmail) async{
    await DB.delete(DB.tableProduct, 'ID = "$id" AND ID_STORE = "${widget.storeID}" AND EMAIL_USER = "$userEmail"');
    var data = await DB.find(DB.tableProduct, 'ID_STORE = "${widget.storeID}" AND EMAIL_USER = "$userEmail"');
    if (data.isEmpty) {
      Navigator.of(context).pop();
    }
    else {
      getData();
    }
  }

  void getData() async{
    _model.clear();
    final user = await _fireAuth.currentUser();

    String where = 'ID_STORE = "${widget.storeID}" AND EMAIL_USER = "${user.email}"';
    var data = await DB.find(DB.tableProduct, where);
    print('DATA: '+data[0].toString());
    data.forEach((element) async{
      var getData = await _firebase.collection('stores').document(element['ID_STORE']).collection('products')
          .document(element['ID_PRODUCT']).snapshots().elementAt(0);

      List<String> img = List<String>.from(getData['images']);
      double price = double.parse(getData.data['price'].toString());
      Products p = Products(title: getData.data['title'], description: getData.data['description'],
          images: img, price: price, inStock: getData.data['inStock'], id: getData.documentID);

      StorageReference storageReference = FirebaseStorage.instance.ref().child(img[0]);
      var urlPhoto = await storageReference.getDownloadURL();

      setState(() {
        _model.add(
            Container(
              margin: EdgeInsets.only(bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: Material(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 50,

                            child: p.images.length == 0
                                ? Image.asset('images/withoutImage.jpg')
                                : Image.network(urlPhoto),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Text(
                              p.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Material(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Text(
                                  p.price.toString(),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.restore_from_trash),
                              onPressed: () {
                                deleteProduct(element['ID'], user.email);
                              }
                          )
                        ],
                      )
                    ],
                  )
                ),
              ),
            )
        );
      });
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _model,
    );
  }
}

