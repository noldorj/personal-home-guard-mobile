import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pv/providers/alerts.dart';
import 'package:pv/providers/auth.dart';
import 'package:pv/utils/appRoutes.dart';
//import 'package:pv/utils/appRoutes.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final alertActions = Provider.of<Alerts>(context, listen: false);

    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Configurações'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();

              Navigator.of(context).pushReplacementNamed(
                AppRoutes.HOME,
              );
            },
          ),
          ListTile(
              onTap: () => alertActions.deleteAll(),
              leading: Icon(Icons.delete_forever),
              title: Text('Apagar todos Alarmes')),
        ],
      ),
    );
  }
}
