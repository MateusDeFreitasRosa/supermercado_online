import 'package:flutter/material.dart';
import 'package:supermercado_virtual/models/products_model.dart';
import 'package:supermercado_virtual/widgets/AlertConfirmProduct.dart';


class CardProducts extends StatelessWidget {

  CardProducts({this.products, this.storeID});
  Products products;
  String storeID;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5),
        child: Container(
          width: 200,
          height: 300,
          child: Card(
              color: Colors.transparent,
              child: Material(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                child: MaterialButton(
                  onPressed: () {
                    print('Clicked on '+ products.title);
                    ConfirmProduct(context: context, products: products, storeID: storeID);
                  },
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            child: products.images == null || products.images.isEmpty
                                ? Image.asset('images/withoutImage.jpg', scale: .6, width: 200, height: 120,)
                                : Image.network(products.images[0], scale: .6, width: 200, height: 120,fit: BoxFit.fill,),
                          ),
                          Material(
                            elevation: 10,
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              margin: EdgeInsets.all(5),
                              color: Colors.transparent,
                              child: Text(
                                'R\$${products.price.toString()}',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                        child: Divider(indent: 1, color: Colors.black,),
                      ),
                      Container(
                        child: Text(
                          products.title,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            products.description,
                            maxLines: 5,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Material(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  'Comprar',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
          ),
        ),
    );
  }
}

