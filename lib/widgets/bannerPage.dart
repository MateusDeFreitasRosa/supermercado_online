import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supermercado_virtual/models/store_model.dart';

class BannerPage extends StatefulWidget {

  BannerPage({this.store});
  Store store;
  @override
  _BannerPageState createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> with TickerProviderStateMixin{

  AnimationController _controller;
  AnimationController _controllerAnimation;
  Animation _animation;
  bool allowClick = false;
  bool openClose = false;

  void ativateControllerCrescent() {
    setState(() {
      _controller.reset();
      _controllerAnimation.reset();
    });
    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });
    _controllerAnimation.forward();
    _controllerAnimation.addListener(() {
      setState(() {});
    });


  }

  void ativateControllerDecrescent() {
    setState(() {
      _controllerAnimation.reset();
      _controller.reset();
    });

    _controller.reverse(from: 1.0);
    _controller.addListener(() {
      setState(() {});
    });
    _controllerAnimation.reverse(from: 1.0);
    _controllerAnimation.addListener(() {
      setState(() {});
    });
  }


  @override
  void initState() {
    // TODO: implement initState

    _controller = AnimationController(vsync: this, duration: Duration(seconds: 3));
    _controllerAnimation = AnimationController(vsync: this, duration: Duration(seconds: 2));

    _animation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(_controllerAnimation);

    try {
      Future.delayed(const Duration(seconds: 5), () {
        ativateControllerCrescent();
        Future.delayed(const Duration(seconds: 3), () {
          allowClick = true;
          openClose = true;
        });
      });
    }catch(e) {

    }

    super.initState();
  }



  @override
  void dispose() {
    _controller.dispose();
    _controllerAnimation.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,

      child: MaterialButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          if (allowClick) {
            allowClick = false;
            if (openClose) {
              ativateControllerDecrescent();
            }
            else {
              ativateControllerCrescent();
            }
            Future.delayed(const Duration(seconds: 3), () {
              allowClick = true;
              openClose = !openClose;
            });
          }
        },
        child: Card(
          color: Colors.transparent,
          child: Material(
            elevation: 4,
            color: Color(0xffE6E6E6),
            borderRadius: BorderRadius.circular(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: Card(
                    elevation: 2,
                    child: Container(
                      width: 120,
                      height: 150 - (_controller.value*80),
                      child: widget.store.image == null
                          ? Image.asset('images/withoutImage.jpg')
                          : Image.network(widget.store.image, scale: .5,),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        widget.store.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18 + (_controller.value * 5),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                      width: 250,
                      child: Divider(thickness: 1, color: Colors.black,),
                    ),
                    FadeTransition(
                      opacity: _animation,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10 - (_controller.value*10)),
                        width: (MediaQuery.of(context).size.width-180) - ((MediaQuery.of(context).size.width-180)*_controller.value) ,
                        height: 50 - (50*_controller.value),
                        child: Text(
                          widget.store.adress,
                          maxLines: 4,
                          style: TextStyle(
                              fontSize: 14
                          ),
                        ),
                      ),
                    ),

                    FadeTransition(
                      opacity: _animation,
                      child: SizedBox(
                        height: 30 - (_controller.value * 30),
                        width: 250 - (_controller.value * 250),
                        child: Divider(thickness: 1, color: Colors.black,),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width-180,
                      child: Text(
                        'Telefone: '+ widget.store.phoneNumber,
                        maxLines: 4,
                        style: TextStyle(
                            fontSize: 13 + (_controller.value * 2)
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('_controller', _controller));
  }
}