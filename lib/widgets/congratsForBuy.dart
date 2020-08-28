import 'package:flutter/cupertino.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:supermercado_virtual/screens/tab_bar_sreen.dart';

void congrats(BuildContext context, String nameUser) {
  Alert(
    context: context,
    title: 'Obrigado $nameUser pela compra!',
    type: AlertType.success,
    style: AlertStyle(
      isCloseButton: false,
    ),
    buttons: [
      DialogButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).popAndPushNamed(TabBarScreen.id);
        },
        child: Text('Fechar'),
      )
    ]
  ).show();
}