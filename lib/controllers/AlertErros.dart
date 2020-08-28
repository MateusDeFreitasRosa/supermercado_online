import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void AlertBtnErros({ BuildContext context,String error, Icon icon}) {

  String message = 'Error desconhecido';
  if (error == 'ERROR_WEAK_PASSWORD')
    message = 'Senha fraca';
  else if (error == 'ERROR_INVALID_EMAIL')
    message = 'E-mail invalido';
  else if (error == 'ERROR_EMAIL_ALREADY_IN_USE')
    message = 'E-mail já em uso';
  else if (error == 'ERROR_WRONG_PASSWORD')
    message = 'Senha incorreta';
  else if (error == 'ERROR_USER_NOT_FOUND')
    message = 'Usuario não existe!';
  else if (error == 'FAIL_ADD')
    message = 'Algum erro ocorreu, tente novamente!';
  else if (error == 'SUCCESS_ADD')
    message = 'Usuario adicionado com sucesso!';

  Alert(
      context: context,
      style: AlertStyle(
       isCloseButton: false,
        animationDuration: Duration(seconds: 1),
        animationType: AnimationType.grow
      ),
      content: icon,
      title: message,
      buttons: [
        DialogButton(
          child: Text(
            'Entendido',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16
            ),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
          color: Colors.lightBlue,
        ),
      ]
  ).show();
}