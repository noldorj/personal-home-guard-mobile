//import 'dart:js';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/login_screen.dart';
import 'views/mainManagement_screen.dart';
import 'utils/appRoutes.dart';
import 'providers/alerts.dart';
import 'providers/auth.dart';
import 'views/imageAlert_screen.dart';

RemoteMessage messageReceived;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(PvApp());
}

class MessageAsArgument {
  final RemoteMessage msg;

  MessageAsArgument(this.msg);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  messageReceived = message;
  main();
}

class PvApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Alerts(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Auth(),
        ),
      ],
      child: MaterialApp(
        //home: FormLogin());
        routes: {
          AppRoutes.HOME: (ctx) => FormLogin(messageReceived),
          AppRoutes.APP_MANAGEMENT: (ctx) => MainManagement(messageReceived),
          AppRoutes.IMAGE_ALERT: (ctx) => ImageAlert(),
        },
      ),
    );
  }
}
