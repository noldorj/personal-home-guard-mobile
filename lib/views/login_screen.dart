import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pv/providers/alerts.dart';
import 'package:pv/widgets/authCard_widget.dart';

class FormLogin extends StatelessWidget {
  final RemoteMessage msg;

  FormLogin(this.msg);

  @override
  Widget build(BuildContext context) {
    final alerts = Provider.of<Alerts>(context, listen: false);
    if (msg != null) {
      //print('Message received at loginScreen: ${msg.notification.title}');
      alerts.saveAlertDevice(msg);
    }

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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AuthCard(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[],
      ),
    );
  }
}
