import 'package:flutter/material.dart';
import 'package:pv/widgets/authCard_widget.dart';

class FormLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Portão Virtual v1.0'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: Image.asset('assets/img/logo/logo_transparent.png'),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AuthCard(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TextButton(
            child: Text('Esqueci a senha'),
            onPressed: () => {print('Esque a senha')},
          ),
          TextButton(
            child: Text('Suporte'),
            onPressed: () => {print('Suporte')},
          ),
        ],
      ),
    );
  }
}
