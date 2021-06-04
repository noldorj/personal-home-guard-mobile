import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'login_screen.dart';
import './mainManagement_screen.dart';



class AuthOrHomeScreen extends StatelessWidget {

  final RemoteMessage msg;

  AuthOrHomeScreen(this.msg);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(child: Text('Ocorreu um erro!'));
        } else {
          return auth.isAuth ? MainManagement() : FormLogin(this.msg);
        }
      },
    );
  }
}
