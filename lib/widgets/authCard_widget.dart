import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pv/data/saveData.dart';
import 'package:pv/exceptions/auth_exception.dart';
import 'package:pv/utils/appRoutes.dart';
import '../providers/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthMode { Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _passwordController = TextEditingController();
  bool _checkAutoLogin = false;

  final _auth = FirebaseAuth.instance;

  Future<void> sendPasswordResetEmail(String email) async {
    Future<void> ret;

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    if (email.isEmpty) {
      _showErrorDialog('Campo "Email" está vazio ! ');
      setState(() {
        _isLoading = false;
      });
    } else if (!email.contains('@')) {
      _showErrorDialog('Informe um Email válido !');
      setState(() {
        _isLoading = false;
      });
    } else {
      //print('sendPasswordResetEmail: $email');

      try {
        await _auth.sendPasswordResetEmail(email: email);

        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Cheque seu email para resetar a senha !');
      } on AuthException catch (error) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog(error.toString());
      } catch (error) {
        _showErrorDialog("Ocorreu um erro inesperado!");
        setState(() {
          _isLoading = false;
        });
      }
    }
    return ret;
  }

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  GlobalKey<FormState> _form = GlobalKey();

  bool _isLoading = false;

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ocorreu um erro!'),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Fechar'),
          )
        ],
      ),
    );
  }

  Future<void> _btnLogin() async {
    if (!_form.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    Auth auth = Provider.of(context, listen: false);

    try {
      await auth.login(_authData["email"], _authData["password"]);
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      //print('try catch error:');
      //print(error);
      _showErrorDialog("Ocorreu um erro inesperado!");
    }

    setState(() {
      _isLoading = false;
    });

    if (auth.isAuth) {
      Navigator.of(context).pushNamed(
        AppRoutes.APP_MANAGEMENT,
        arguments: 'email',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: deviceSize.height * 0.44,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return "Informe um e-mail válido!";
                  }
                  return null;
                },
                onSaved: (value) => _authData['email'] = value,
              ),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                validator: (value) {
                  if (value.isEmpty || value.length < 6) {
                    return "Informe uma senha válida!";
                  }
                  return null;
                },
                onSaved: (value) => _authData['password'] = value,
              ),
              Spacer(),
              if (_isLoading)
                CircularProgressIndicator()
              else
                Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    child: Text('Entrar'),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(4.0),
                    ),
                    onPressed: _btnLogin,
                  ),
                ),
              SwitchListTile(
                  title: Text("Manter logado"),
                  inactiveTrackColor: Colors.grey,
                  value: _checkAutoLogin,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool newValue) {
                    setState(() {
                      _checkAutoLogin = newValue;
                    });

                    if (_checkAutoLogin) {
                      Store.saveString('rememberLogin', 'true');
                      print('_checkAutoLogin true');
                    } else {
                      Store.saveString('rememberLogin', 'false');
                      print('_checkAutoLogin false');
                    }
                  }),
              Card(
                child: TextButton(
                  child: Text('Esqueci / Resetar a senha'),
                  onPressed: () => sendPasswordResetEmail(_authData['email']),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
