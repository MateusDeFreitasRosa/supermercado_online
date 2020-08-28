import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:supermercado_virtual/controllers/add_item_card.dart';
import 'package:supermercado_virtual/models/products_model.dart';



void ConfirmProduct({@required BuildContext context, Products products, String storeID}) {
  int qntOfProduct = 1;

  observerChildren(int qnt) {
    qntOfProduct = qnt;
    print('Notify root\nOverwriten number to: '+ qntOfProduct.toString());
  }


  Alert(
    closeFunction: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
    title: 'Deseja adicionar ao carrinho?',
    context: context,
    content: _Content(products: products, notifyParent: observerChildren,),
    buttons: [
      DialogButton(
        color: Colors.green,
        onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            add_item_card(storeID: storeID, products: products, AMOUNT: qntOfProduct);

            Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.lightGreen,
              content: Text(
                'Produto adicionado ao carrinho com sucesso!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),

              ),
            ));
        },
        child: Text(
          'Confirmar',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      DialogButton(
        color: Colors.red,
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: Text(
          'Cancelar',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
    ]
  ).show();
}


class _Content extends StatefulWidget {

  _Content({this.products, this.notifyParent});
  Products products;
  final Function notifyParent;

  @override
  __ContentState createState() => __ContentState();
}

class __ContentState extends State<_Content> {
  double price;
  double priceProduct;

  observerChildren(int qnt) {
    setState(() {
      price = priceProduct*qnt;
    });
    print('Notify middle node');
    widget.notifyParent(qnt);

  }

  @override
  void initState() {
    setState(() {
      priceProduct = widget.products.price;
      price = priceProduct;
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
              widget.products.title
          ),
        ),
        Carousell(products: widget.products,),
        Padding(
          padding: EdgeInsets.all(10),
          child: Material(
            elevation: 2,
            color: Colors.white12,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Text(
                widget.products.description,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,

                ),
              ),
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _BoxAmount(notifyParent: observerChildren,),
            Container(
              alignment: Alignment.centerRight,
              child: Material(
                elevation: 2,
                color: Color(0xff7fff00),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    price.toString().indexOf('.')+2 == price.toString().length
                        ? 'R\$${(price.toString().replaceAll('.', ','))}0'
                        : 'R\$${(price.toString().replaceAll('.', ','))}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}

class _BoxAmount extends StatefulWidget {

  _BoxAmount({this.notifyParent});

  final Function notifyParent;
  @override
  __BoxAmountState createState() => __BoxAmountState();
}

class __BoxAmountState extends State<_BoxAmount> {
  int qnt = 1;
  TextStyle defaultTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
  );
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(
            iconSize: 16,
            padding: EdgeInsets.all(0),

            icon: Icon(Icons.remove),
            onPressed: () {
              if (qnt>=2) {
                setState(() {
                  qnt--;
                });
                widget.notifyParent(qnt);
              }
            },
          ),
          Container(
            width: 50,
            height: 50,
            child: Material(
              borderRadius: BorderRadius.circular(40),
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  if (int.parse(value) < 1) {
                    setState(() {
                      qnt = 1;
                    });
                    widget.notifyParent(qnt);
                    _controller.clear();
                  }
                  else {
                    qnt = int.parse(value);
                    widget.notifyParent(qnt);
                  }

                },
                style: defaultTextStyle,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintStyle: defaultTextStyle,
                  hintText: qnt.toString(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlueAccent),
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
              ),
            ),
          ),
          IconButton(
            iconSize: 16,
            icon: Icon(Icons.plus_one),
            onPressed: () {
              setState(() {
                qnt++;
              });
              widget.notifyParent(qnt);
            },
          ),
        ],
      ),
    );
  }
}


class Carousell extends StatefulWidget {

  Carousell({this.products});
  Products products;
  @override
  _CarousellState createState() => _CarousellState();
}

class _CarousellState extends State<Carousell> {

  double height = 180.0;
  double width = 300.0;

  List<Image> _images = [];
  void getImages() {
    if (widget.products.images != null && widget.products.images.length > 0) {
      for(var i in widget.products.images) {
        setState(() {
          _images.add(Image.network(i, height: height, width: width, scale: .6,));
        });
      }
    }
  }

  @override
  void initState() {
    getImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width,
        child: Carousel(
            borderRadius: true,
            autoplayDuration: Duration(seconds: 5),
            images: _images.length == 0
                ? [Image.asset('images/withoutImage.jpg', width: width, height: height,scale: .6,)]
                : _images
        )
    );
  }
}
