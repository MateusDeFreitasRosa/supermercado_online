import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:supermercado_virtual/controllers/criptografia.dart';
import 'file:///C:/Users/mateu/AndroidStudioProjects/supermercado_virtual/lib/controllers/connection_Cart.dart';
import 'package:supermercado_virtual/models/store_model.dart';
import 'package:supermercado_virtual/widgets/bannerPage.dart';
import 'package:supermercado_virtual/widgets/congratsForBuy.dart';

class BuyCard extends StatefulWidget {
  static String id = '/buycard';

  BuyCard({this.storeId});
  String storeId;

  @override
  _BuyCardState createState() => _BuyCardState();
}

class _BuyCardState extends State<BuyCard> {

  Store _store;
  final _fireStore = Firestore.instance;
  List<Widget> _list = [];
  Store _modelStore;
  bool _dinheiro = false;
  bool _cartao = false;
  double totalPrice = 0;
  double priceDelivery = 0;
  double change;

  //Variaveis usadas para pegar os endereços.
  final _fireAuth = FirebaseAuth.instance;
  //List<bool> markEndereco = [];


  String selectedValue;
  List<int> selectedAdress = [];
  List<DropdownMenuItem> adress = [];

  void getAdress(var user) async{
    try {

      var data = await _fireStore.collection('User').document(Criptografia.encode(user.email)).get();

      if (data['adress']!= null) {

        data.data['adress'].forEach((element) {
          setState(() {
            adress.add(
              DropdownMenuItem(
                child: Text(element['logradouro']+ ' '+ element['numero']+ ' '+ element['bairro']),
                value: element['logradouro'],
              )
            );
          });
        });
      }
    }catch(e) {
      print(e);
    }
  }



  void getStore() async{
    var getStore = await _fireStore.collection('stores').document(widget.storeId).snapshots().elementAt(0);

    String fileName = getStore.data['imageStore'];
    StorageReference storageReference = FirebaseStorage.instance.ref().child(fileName);
    String urlPhoto = await storageReference.getDownloadURL();

    setState(() {
      double deliveryRate = double.parse(getStore.data['deliveryRate'].toString());
      _store = Store(id: widget.storeId, description: getStore.data['description'], title: getStore.data['name'],
          image: urlPhoto, phoneNumber: getStore.data['phoneNumber'],
          deliveryRate: deliveryRate , adress: getStore.data['adress']);
      priceDelivery = deliveryRate;
      totalPrice += priceDelivery;
    });

  }

  void getProducts(var user) async{
    totalPrice = 0;
    var data = await DB.find(DB.tableProduct, 'ID_STORE = "${widget.storeId}" AND EMAIL_USER = "${user.email}" ');

    data.forEach((element) async{
      try {
        var product = await _fireStore.collection('stores').document(widget.storeId).collection('products').document(element['ID_PRODUCT']).get();

        List<String> img = List<String>.from(product.data['images']);
        StorageReference storageReference = FirebaseStorage.instance.ref().child(img[0]);
        String urlPhoto = await storageReference.getDownloadURL();

        double price = double.parse(product.data['price'].toString());

        setState(() {
          totalPrice += (price*element['AMOUNT']);
          _list.add(
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 3),
                padding: EdgeInsets.only(left: 4),
                width: MediaQuery.of(context).size.width,
                child: Material(
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(element['AMOUNT'].toString()+'x'),
                        ),
                        Container(
                          width: 40,
                          height: 50,

                          child: img.length == 0
                              ? Image.asset('images/withoutImage.jpg')
                              : Image.network(urlPhoto),
                        ),
                        Container(
                          child: Text(
                            product.data['title'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            (product.data['price']*element['AMOUNT']).toString(),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              icon: Icon(Icons.restore_from_trash),
                              onPressed: () {
                                DB.delete(DB.tableProduct, 'ID_PRODUCT = "${element['ID_PRODUCT']}"'
                                    'AND ID_STORE = "${widget.storeId}" AND EMAIL_USER = "${user.email}"');
                              }
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
          );
        });
      }catch(e) {
        print('ERROR: '+ e.toString());
      }
    });

  }

  void addNewShopping(BuildContext context) async{
    try {
      final user = await _fireAuth.currentUser();
      if (user != null) {
        var data = await DB.find(DB.tableProduct, 'ID_STORE = "${widget.storeId}" AND EMAIL_USER = "${user.email}"');
        List< dynamic > products = [];
        data.forEach((element) async{
          var productData = await _fireStore.collection('stores').document(widget.storeId).collection('products').document(element['ID_PRODUCT']).get();

          products.add({
            'product': productData.data['title'],
            'amount': element['AMOUNT'],
            'price': productData.data['price'],
          });
          print('PRODUCTS :;:.:.:.;=> '+ products.length.toString());
        });

        await _fireStore.collection('stores').document(widget.storeId).collection('requests').add({
          'buyer': Criptografia.encode(user.email),
          'store': widget.storeId,
          'products': products,
          'deliveryAdress': selectedValue,
          'totalPrice': totalPrice,
          'cardPayment': _cartao,
          'maneyPayment': _dinheiro,
          'change': _dinheiro == true ? change : null,
          'dateTime': DateTime.now(),
          'status': 'Pendente'
        });
        String _criptUser = Criptografia.encode(user.email);

        await _fireStore.collection('User').document(_criptUser).collection('requests').add({
          'store': widget.storeId,
          'products': products,
          'deliveryAdress': selectedValue,
          'totalPrice': totalPrice,
          'cardPayment': _cartao,
          'maneyPayment': _dinheiro,
          'change': _dinheiro == true ? change : null,
          'dateTime': DateTime.now(),
          'status': 'Pendente'
        });
        String where = 'ID_STORE = "${widget.storeId}" AND EMAIL_USER = "${user.email}"';
        DB.delete(DB.tableProduct, where);


        var infoUser = await _fireStore.collection('User').document(Criptografia.encode(user.email)).get();
        congrats(context, infoUser.data['name'].toString());
      }
    }catch(e) {
      print(e);
    }
  }

  bool allRight() {
    print('Entrei aqui');
    if ((_dinheiro || _cartao) && !((!_cartao && !_dinheiro) || (_cartao && _dinheiro))) {
      print('Entrei aqui2');
      if (selectedValue != null && selectedValue != '') {
        if (_dinheiro) {
          if (change != null && change > totalPrice) {
            print('Dinheiro -> TUDO CERTO!');
            return true;
          }
          print('Um pouco mais :)');
        }
        else {
          print('Cartão -> TUDO CERTO!');
          return true;
        }
      }
    }
    return false;
  }

  void getData() async{
    final user = await _fireAuth.currentUser();
    getStore();
    getProducts(user);
    getAdress(user);
  }

  @override
  void initState() {
    setState(() {
      _modelStore = Store(adress: '...', deliveryRate: 00, phoneNumber: '(xx) xxxx-xxxx', image: null, title: '...', description: '...', id: '...');
    });
    getData();
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BannerPage(store: _store == null ? _modelStore : _store,),
              SizedBox(height: 10,),
              Material(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    'Carrinho de compra',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),

              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Material(
                      color: Colors.white54,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _list.length == 0 ?
                        [
                          Container(
                            child: Text(
                              'Aguarde um instante...',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                              ),
                            ),
                          )
                        ] : _list,
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    alignment: Alignment.centerRight,
                    child: Material(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              elevation: 0,
                              child: Container(
                                child: Text(
                                  'Frete:  R\$'+priceDelivery.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,

                                  ),
                                ),
                              ),
                            ),
                            Material(
                              elevation: 0,
                              child: Container(
                                child: Text(
                                  'Total:  R\$'+totalPrice.toStringAsPrecision(totalPrice.toString().indexOf('.') +2).replaceAll('.', ','),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 1

                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Modo de pagamento',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),



                  SizedBox(height: 15,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dinheiro',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                      Checkbox(
                        value: _dinheiro,
                        onChanged: (newCheck) {
                          if (_cartao == true) {
                            setState(() {
                              _cartao = false;
                              _dinheiro = newCheck;
                            });
                          }
                          else {
                            setState(() {
                              _dinheiro = newCheck;
                            });
                          }
                        },
                      ),
                      Text(
                        'Cartão',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                      Checkbox(
                        value: _cartao,
                        onChanged: (newCheck) {
                          if (_dinheiro == true) {
                            setState(() {
                              _dinheiro = false;
                              _cartao = newCheck;
                            });
                          }
                          else {
                            setState(() {
                              _cartao = newCheck;
                            });
                          }
                        },
                      )
                    ],
                  ),

                  _dinheiro == true
                      ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(

                        onChanged: (value) {
                          change = double.parse(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Valor para troco',
                          hintStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      )
                  )
                      : Container(),

                  SizedBox(height: 15),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Material(
                      elevation: 2,
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text(
                          'Endereço para a entrega',
                          style: TextStyle(
                            color: Color(0xff2E2E2E),
                            fontWeight: FontWeight.bold,
                            fontSize: 17
                          ),
                        ),
                      ),
                    ),
                  ),


                  //Endereços.
                  SearchableDropdown.single(
                    items: adress,
                    value: selectedAdress,
                    hint: Text(
                        "Endereço de entrega",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                    searchHint: null,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                      return selectedValue;
                    },

                    closeButton: (selectedItems) {
                      selectedValue = selectedItems;
                      return selectedValue != '' && selectedValue != null ? "$selectedValue" : "Done";
                    },
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    dialogBox: false,
                    isExpanded: true,
                    menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
                  ),

                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightBlue,
                      child: MaterialButton(
                        child: Text(
                          'Finalizar compra',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white
                          ),
                        ),
                        onPressed: () {
                          if (allRight()) {
                            addNewShopping(context);
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 100,)
            ],
          ),
        ),
      ),
    );
  }
}


