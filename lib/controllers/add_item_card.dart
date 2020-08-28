import 'file:///C:/Users/mateu/AndroidStudioProjects/supermercado_virtual/lib/controllers/connection_Cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supermercado_virtual/models/products_SQL.dart';
import 'package:supermercado_virtual/models/products_model.dart';

void add_item_card({Products products, String storeID, int AMOUNT = 1}) async{
  final _fireAuth = FirebaseAuth.instance;
  final user = await _fireAuth.currentUser();
  Products_SQL products_sql = Products_SQL(ID_STORE: storeID, ID_PRODUCT: products.id, AMOUNT: AMOUNT, EMAIL_USER: user.email);

  try {
    String where = 'ID_STORE = "$storeID" AND EMAIL_USER = "${user.email}" AND ID_PRODUCT = "${products.id}"';
    var search = await DB.find(DB.tableProduct,  where);
    //TODO Do conditional, for update amount of product.
    DB.insert(DB.tableProduct, products_sql);


    var getData = await DB.query(DB.tableProduct);
    print(getData);
  }catch(e) {
    print(e);
  }

}