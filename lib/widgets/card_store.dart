import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supermercado_virtual/models/store_model.dart';
import 'package:supermercado_virtual/screens/store_screen.dart';

class CardStore extends StatelessWidget {

  CardStore({this.data,this.auxContext});
  BuildContext auxContext;
  Store data;
  String withoutImageStore = 'images/cel.jpg';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 10, left: 0, right: 0),
        child: Material(
          color: Color(0xffE6E6E6),
          borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15),
          bottomLeft: Radius.circular(15)),
          child: MaterialButton(
            padding: EdgeInsets.symmetric(horizontal: 10),
            onPressed: () {
              Navigator.push(auxContext, MaterialPageRoute(builder: (context) {
                return StoreScreen(store: data,);
              }));
              },
            child: Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image(
                    image: data.image == null
                        ? AssetImage(withoutImageStore)
                        : NetworkImage(data.image,scale: .5),
                    width: 85,
                    height: 85,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Text(
                              data.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              data.description,
                              maxLines: 4,
                              style: TextStyle(
                                  fontSize: 14
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Card(
                            elevation: 0,
                            child: Container(
                              margin: EdgeInsets.only(right: 20),
                              alignment: Alignment.bottomRight,
                              child: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    'Taxa entrega: R\$'+(data.deliveryRate.toString().replaceAll('.', ',')),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
