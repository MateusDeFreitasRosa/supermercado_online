import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supermercado_virtual/controllers/criptografia.dart';
import 'package:supermercado_virtual/screens/welcome_screen.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final _fireStore = Firestore.instance;
  final _fireAuth = FirebaseAuth.instance;
  //Variaveis -> Formulário.
  String logradouro;
  String numero;
  String bairro;

  String name = '';
  String email = '';
  String phoneNumber = '';

  List<Widget> enderecos = [];

  void getData() async{
    try {
      final user = await _fireAuth.currentUser();
      var data = await _fireStore.collection('User').document(Criptografia.encode(user.email)).get();

      setState(() {
        name = data.data['name'];
        email = user.email;
        phoneNumber = data.data['phoneNumber'];
      });

      if (data['adress']!= null) {
        data.data['adress'].forEach((element) {
          setState(() {
            enderecos.add(
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Logradouro: '+element['logradouro'],
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Bairro: '+ element['bairro'],
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Numero: '+element['numero'],
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
            );
            enderecos.add(
              SizedBox(
                height: 10,
                child: Divider(thickness: 1, color: Colors.black,),
              ),
            );
          });
        });
      }
      else {
        setState(() {
          enderecos.add(
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Nenhum email cadastrado!',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                       ),
                    ),
                  ],
                ),
              )
          );
          enderecos.add(
            SizedBox(
              height: 10,
              child: Divider(thickness: 1, color: Colors.black,),
            ),
          );
        });
      }

    }catch(e) {
      print(e);
    }
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    void addNewAdress() async{
      if (logradouro != null && numero != null && bairro != null) {
        if (logradouro.isNotEmpty && numero.isNotEmpty && bairro.isNotEmpty) {
          print('Entrei');
          int number = int.parse(numero);
          final user = await _fireAuth.currentUser();
          if (user != null) {
            var data = await _fireStore.collection('User').document(Criptografia.encode(user.email)).get();
            if (data.data['adress'] != null) {
              List<dynamic> newAdress = data.data['adress'];
              newAdress.add({
                'logradouro': logradouro,
                'numero': numero,
                'bairro': bairro,
              });

              _fireStore.collection('User').document(Criptografia.encode(user.email)).updateData({'adress': newAdress});
            }
            else {
              List<Map<String,dynamic>> newAdress = [
                {
                  'logradouro': logradouro,
                  'numero': numero,
                  'bairro': bairro,
                }
              ];
              _fireStore.collection('User').document(Criptografia.encode(user.email)).updateData({'adress': newAdress});
            }

            setState(() {
              enderecos.add(
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          logradouro,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          bairro,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,

                          ),
                        ),
                        Text(
                          numero,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,

                          ),
                        ),
                      ],
                    ),
                  )
              );
              enderecos.add(
                SizedBox(
                  height: 10,
                  child: Divider(thickness: 1, color: Colors.black,),
                ),
              );
            });

          }
        }
      }
    }



    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          elevation: 2,
                          color: Colors.orangeAccent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            child: Text(
                              'Perfil',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: 3,
                                  fontStyle: FontStyle.italic
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Material(
                          color: Colors.white,
                          elevation: 2,
                          borderRadius: BorderRadius.circular(10),
                          child: FlatButton(
                            onPressed: ()  async{
                              final user = await _fireAuth.currentUser();
                              if (user != null) {
                                Navigator.popAndPushNamed(context, WelcomeScreen.id);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              child: Text(
                                'Sair',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 3,
                                    fontStyle: FontStyle.italic
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30,),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Nome: '+name,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'E-mail: '+email,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Telefone: '+ phoneNumber,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                ),



                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.center,
                  child: Material(
                    elevation: 2,
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                          'Endereços cadastrados',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: enderecos == null ? Container() : enderecos,
                  ),
                ),




                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.white12
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                          height: 50,
                          child: TextField(
                            onChanged: (value) {
                              logradouro = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'Logradouro',
                                hintStyle: TextStyle(
                                  fontSize: 16
                                ),
                                enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              )
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                          height: 50,
                          child: TextField(
                            onChanged: (value) {
                              numero = value;
                            },
                            decoration: InputDecoration(
                                hintText: 'Numero',
                                hintStyle: TextStyle(
                                    fontSize: 16
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                )
                            ),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                          height: 50,
                          child: TextField(
                            onChanged: (value) {
                              bairro = value;
                            },
                            decoration: InputDecoration(
                                hintText: 'Bairro',
                                hintStyle: TextStyle(
                                    fontSize: 16
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                )
                            ),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        FlatButton(
                          child: Text(
                            'Cadastrar novo endereço',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17
                            ),
                          ),
                          color: Colors.lightBlue,
                          onPressed: () {
                            print('Cadastrar +1 endereço');
                            addNewAdress();
                          },
                        ),
                      ],
                    )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
