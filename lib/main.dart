import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/login_screen.dart';
import 'views/mainManagement_screen.dart';
import 'utils/appRoutes.dart';
import 'providers/alerts.dart';
import 'providers/auth.dart';
import 'views/imageAlert_screen.dart';

main() => runApp(PvApp());

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
          AppRoutes.HOME: (ctx) => FormLogin(),
          AppRoutes.APP_MANAGEMENT: (ctx) => MainManagement(),
          AppRoutes.IMAGE_ALERT: (ctx) => ImageAlert(),
        },
      ),
    );
  }
}
