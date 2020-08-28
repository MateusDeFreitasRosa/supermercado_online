
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:supermercado_virtual/controllers/date.dart';

getProducts() async{

}

void receipt(BuildContext context, String status, String formOfPayment, DateTime dateTime, String deliveryAdress,
    var products, var store , var totalPrice) {


  Alert(
    title: 'Recibo de compra.',
    context: context,
    content: _Receipt(status: status, formOfPayment: formOfPayment, dateTime: dateTime, deliveryAdress: deliveryAdress,
            products: products, store: store, totalPrice: totalPrice,),
    buttons: [
      DialogButton(
        child: Text(
            'Fechar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
        ),
        onPressed: ()  {
          Navigator.of(context, rootNavigator: true).pop();
        },
      )
    ]
  ).show();
}




class _Receipt extends StatefulWidget {

  _Receipt({this.status, this.formOfPayment, this.dateTime, this.deliveryAdress,
          this.products, this.store, this.totalPrice});
  String status;
  String formOfPayment;
  DateTime dateTime;
  String deliveryAdress;
  var products;
  var store;
  var totalPrice;

  @override
  __ReceiptState createState() => __ReceiptState();
}

class __ReceiptState extends State<_Receipt> {
  List<ListTile> _list = [];
  var divider = SizedBox(
    height: 10,
    child: Divider(
      thickness: 1,
    ),
  );

  bigTitle(String text) {
    return Center(
      child: Container(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  void buildProducts() {
    try {
      widget.products.forEach((element) {
        print(element['product']);
        print(element['price'].toString());
        print(element['amount'].toString());
        setState(() {
          _list.add(
              ListTile(
                title: Text(element['product']),
                subtitle: Text('R\$'+element['price'].toString()),
                leading: Text(element['amount'].toString()+'x'),
            )
          );
        });
      });
    } catch(err) {
      print(err);
    }
  }

  @override
  void initState() {
    buildProducts();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: Text(widget.store.data['name']),
            leading: Icon(Icons.store),
          ),
          ListTile(
            title: Text(
              formatDate(widget.dateTime),
            ),
            leading: Icon(Icons.date_range),
            subtitle: Text(
              widget.dateTime.hour.toString() + ' : '+ widget.dateTime.minute.toString() + ' : '+ widget.dateTime.second.toString(),
            ),
          ),
          ListTile(
            title: Text('Status de Entrega'),
            subtitle: Text(widget.status),
            leading: Icon(Icons.motorcycle),
          ),
          ListTile(
            title: Text('Destino'),
            leading: Icon(Icons.home),
            subtitle: Text(widget.deliveryAdress),
          ),

          bigTitle('Produtos'),
          divider,
          Column(
            children: _list == null ? [Container()] : _list,
          ),

          bigTitle('Pagamento'),
          divider,
          ListTile(
            title: Text('Forma de pagamento'),
            subtitle: Text(widget.formOfPayment),
            leading: Icon(Icons.check),
          ),
          ListTile(
            title: Text('Valor total'),
            subtitle: Text('R\$'+widget.totalPrice.toString()),
            leading: Icon(Icons.payment),
          )
        ],
      )
    );
  }
}
