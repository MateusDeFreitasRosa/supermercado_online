import 'package:flutter/material.dart';


class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            'Telefone',
          ),
          TextField(
            onChanged: (value) {
              print(value);
            },
          )
        ],
      ),
    );
  }
}
