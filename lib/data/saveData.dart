import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../providers/alert.dart';

class Store {
  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<void> saveMap(String key, Map<String, dynamic> value) async {
    saveString(key, json.encode(value));
  }

  static Future<String> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<Map<String, dynamic>> getMap(String key) async {
    try {
      Map<String, dynamic> map = json.decode(await getString(key));
      return map;
    } catch (_) {
      return null;
    }
  }

  static Future<List<Alert>> getListItems() async {
    try {
      final list = await SharedPreferences.getInstance();
      List<Alert> alerts = [];
      Set<String> listKeys = list.getKeys();
      if (listKeys.isNotEmpty) {
        var it = listKeys.iterator;

        while (it.moveNext()) {
          final al = await getMap(it.current);
          final alert = Alert(
            id: al["id"],
            cameraName: al["cameraName"],
            regionName: al["regionName"],
            date: al["date"],
            objectDetected: al["objectDetected"],
            textAlert: al["textAlert"],
            urlImageDownload: al["urlImageDownload"],
            urlImageFirebase: al["urlImageFirebase"],
            urlImageLocal:
                "assets/alerts/2021/Marco/08/08-03-2021-16-13-35.png",
          );
          alerts.add(alert);
        }
        return alerts;
      } else {
        print('getListItems return null');
        return alerts;
      }
    } catch (_) {
      print('getListItems return null');
      return null;
    }
  }

  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
