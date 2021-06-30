import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../exceptions/auth_exception.dart';
import '../data/saveData.dart';

class Auth with ChangeNotifier {
  // https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]

  String _userId;
  String _token;
  DateTime _expiryDate;
  Timer _logoutTimer;
  bool _logged = false;

  Future<void> isLogged() async {
    //print('keepLooged: ${await Store.getString('keepLogged')}');
    if (await Store.getString('keepLogged') == 'true') {
      _logged = true;
      //print('isLogged true');
    } else {
      //print('isLogged false');
      _logged = false;
    }
  }

  bool get isAuth {
    isLogged();
    if (_logged) {
      //print('get isAuth: $_logged');
      return true;
    } else {
      //print('get isAuth: token != null');
      return token != null;
    }
  }

  String get userId {
    isLogged();
    return isAuth ? _userId : null;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  Future<void> _authenticate(String email, String password) async {
    final Uri url = Uri.https(
        "identitytoolkit.googleapis.com",
        "v1/accounts:signInWithPassword",
        {"key": "AIzaSyCLXO-L5_NNDYlHEj6A2p-qkOYFjVJweWM"});

    final response = await http.post(
      url,
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    final responseBody = json.decode(response.body);

    //print(responseBody);

    if (responseBody["error"] != null) {
      throw AuthException(responseBody['error']['message']);
    } else {
      _token = responseBody["idToken"];
      _userId = responseBody["localId"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody["expiresIn"]),
        ),
      );

      //post salvar token no realtime_database
      /* const url = 'https://pvalarmes-3f7ee-default-rtdb.firebaseio.com/';
      http.post(
        url,
        body: null,
      ); */

      if (await Store.getString('rememberLogin') == 'true') {
        Store.saveString('keepLogged', 'true');
      } else {
        Store.saveString('keepLogged', 'false');
      }

      Store.saveMap('userData', {
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate.toIso8601String(),
      });

      String topic = email.replaceAll("@", ".");
      //print("Topic: $topic");
      await FirebaseMessaging.instance.subscribeToTopic(topic);

      _autoLogout();
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password);
  }

  Future<void> tryAutoLogin() async {
    //print('tryAutologin()');
    isLogged();

    if (isAuth) {
      //print('autoLogin _logged: $_logged');
      return Future.value();
    } else {
      final userData = await Store.getMap('userData');
      if (userData == null) {
        return Future.value();
      }

      final expiryDate = DateTime.parse(userData["expiryDate"]);

      if (expiryDate.isBefore(DateTime.now())) {
        return Future.value();
      }

      _userId = userData["userId"];
      _token = userData["token"];
      _expiryDate = expiryDate;

      _autoLogout();
      //logout();
      notifyListeners();
    }
    return Future.value();
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
      _logoutTimer = null;
    }
    Store.remove('userData');
    Store.saveString('keepLogged', 'false');
    Store.saveString('rememberLogin', 'false');
    isLogged();
    notifyListeners();
  }

  void _autoLogout() {
    //print('_autoLogout');
    if (_logoutTimer != null) {
      //print('_logoutTimer.cancel');
      _logoutTimer.cancel();
    }
    final timeToLogout = _expiryDate.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout), logout);
  }
}
