import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:pv/data/dummy_data.dart';
import '../utils/db_util.dart';
import 'dart:async';
import '../utils/saveImage.dart';
import 'package:intl/intl.dart';

import 'alert.dart';

class Alerts with ChangeNotifier {
  //final Uri _url = Uri.https("pvalarmes-3f7ee-default-rtdb.firebaseio.com/",
  //    "v1/accounts:signInWithPassword", {"auth": _token});

  //final String _url = 'https://pvalarmes-3f7ee-default-rtdb.firebaseio.com/';

  /*
  List<Alert> _items = 
  */

  //String _token;
  //String _userId;

  Alerts() {
    this.loadAllAlerts();
  }
  List<Alert> _items = [];

  void loadItemsTest() async {
    print('alerts::loadItemsTest');
    for (Alert item in ALERTS_DUMMY) {
      print('loaditemsTest:: urlImageFirebase: ${item.urlImageFirebase}');
      String imageSavedPath = await saveImage(
          item.urlImageDownload, item.id, item.urlImageFirebase);
      print('imageSavedPath: $imageSavedPath');
      item.urlImageLocal = imageSavedPath;
      addAlert(item);
      print('alerts::addAlert chamado');
      this.loadItems();
      notifyListeners();
    }
  }

  Future<void> loadItemsAfterDate(DateTime date) async {
    DateFormat format = new DateFormat("dd/MM/yyyy");
    //String newDate = format.parse(date.toIso8601String()).toString();

    print('alerts::loadItemsLastDate:: date: $date');
    //print('loadItemsLastDate:: newDate: $newDate');

    final dataList = await DbUtil.getAlertAfterDate(date);
    var size = dataList.length;

    print('alerts::loadItemsAfterDate size datalist: $size');

    _items = dataList
        .map(
          (item) => Alert(
            id: item['id'],
            cameraName: item['cameraName'],
            regionName: item['regionName'],
            date: format
                .format(DateTime.fromMillisecondsSinceEpoch(item['date'])),
            hour: item['hour'],
            objectDetected: item['objectDetected'],
            textAlert: item['textAlert'],
            urlImageFirebase: item['urlImageFirebase'],
            urlImageDownload: item['urlImageDownload'],
            urlImageLocal: item['urlImageLocal'],
          ),
        )
        .toList();

    notifyListeners();
  }

  Future<void> loadItems() async {
    print('alerts::loadItems');
    _items = _items;
    notifyListeners();
  }

  Future<void> loadAllAlerts() async {
    final dataList = await DbUtil.getData('alerts');
    print('alerts::loadAllAlerts');
    var format = DateFormat('dd/MM/yyyy');
    var s = dataList.length;
    print('alerts::loadAllAlerts size datalist: $s');

    _items = dataList
        .map(
          (item) => Alert(
            id: item['id'],
            cameraName: item['cameraName'],
            regionName: item['regionName'],
            date: format
                .format(DateTime.fromMillisecondsSinceEpoch(item['date'])),
            hour: item['hour'],
            objectDetected: item['objectDetected'],
            textAlert: item['textAlert'],
            urlImageFirebase: item['urlImageFirebase'],
            urlImageDownload: item['urlImageDownload'],
            urlImageLocal: item['urlImageLocal'],
          ),
        )
        .toList();
    this.loadItems();
    notifyListeners();
  }

  Future<void> loadItemsByDate(DateTime date) async {
    DateFormat format = new DateFormat("dd/MM/yyyy");
    //String newDate = format.parse(date.toIso8601String()).toString();

    print('loadItemsByDate:: date: $date');
    //print('loadItemsLastDate:: newDate: $newDate');

    final dataList = await DbUtil.getAlertByDate(date);
    final size = dataList.length;
    print('loadItemsByDate dataList size: $size');

    _items = dataList
        .map(
          (item) => Alert(
            id: item['id'],
            cameraName: item['cameraName'],
            regionName: item['regionName'],
            date: format
                .format(DateTime.fromMillisecondsSinceEpoch(item['date'])),
            hour: item['hour'],
            objectDetected: item['objectDetected'],
            textAlert: item['textAlert'],
            urlImageFirebase: item['urlImageFirebase'],
            urlImageDownload: item['urlImageDownload'],
            urlImageLocal: item['urlImageLocal'],
          ),
        )
        .toList();

    notifyListeners();
  }

  List<Alert> get items {
    //updateListItems();
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  void deleteAll() {
    print('alerts::deleteAll');
    DbUtil.deleteAll();
    this.loadAllAlerts();
    notifyListeners();
  }

  Alert itemByIndex(int index) {
    return _items[index];
  }

  void deleteById(String id) async {
    print('delteById: $id');
    DbUtil.deleteAlert(id);
    this.loadAllAlerts();
    notifyListeners();
  }

  Future<void> saveAlertDevice(RemoteMessage msg) async {
    final RemoteNotification notification = msg.notification;

    print('::saveAlertDevice');
    print('');

    var cameraName,
        id,
        regionName,
        date,
        hour,
        objectDetected,
        textAlert,
        urlImageDownload,
        urlImageFirebase;

    MapEntry entry = msg.data.entries.firstWhere(
        (element) => element.key == 'regionName',
        orElse: () => null);
    regionName = entry.value;
    print('regionName: ${entry.value}');

    entry = msg.data.entries.firstWhere(
        (element) => element.key == 'cameraName',
        orElse: () => null);
    cameraName = entry.value;
    print('cameraName: ${entry.value}');

    entry = msg.data.entries
        .firstWhere((element) => element.key == 'date', orElse: () => null);
    date = entry.value;
    print('date: ${entry.value}');

    entry = msg.data.entries
        .firstWhere((element) => element.key == 'hour', orElse: () => null);
    hour = entry.value;
    print('hour: ${entry.value}');

    entry = msg.data.entries.firstWhere(
        (element) => element.key == 'objectDetected',
        orElse: () => null);
    objectDetected = entry.value;
    print('objectDetected: ${entry.value}');

    entry = msg.data.entries.firstWhere(
        (element) => element.key == 'urlImageDownload',
        orElse: () => null);
    urlImageDownload = entry.value;
    print('urlImageDownload: ${entry.value}');

    entry = msg.data.entries.firstWhere(
        (element) => element.key == 'urlImageFirebase',
        orElse: () => null);
    urlImageFirebase = entry.value;
    print('urlImageFirebase: ${entry.value}');

    entry = msg.data.entries
        .firstWhere((element) => element.key == 'id', orElse: () => null);
    id = entry.value;
    print('id: ${entry.value}');

    textAlert = notification.body;

    String imageSavedPath =
        await saveImage(urlImageDownload, id, urlImageFirebase);

    print('saveAlertDevice::imageSavedPath $imageSavedPath');

    final al = Alert(
        id: id,
        cameraName: cameraName,
        regionName: regionName,
        date: date,
        hour: hour,
        objectDetected: objectDetected,
        textAlert: textAlert,
        urlImageDownload: urlImageDownload,
        urlImageFirebase: urlImageFirebase,
        urlImageLocal: imageSavedPath);

    addAlert(al);
  }

  void addAlert(Alert alert) {
    DateFormat format = new DateFormat("dd/MM/yyyy");

    print('alerts::addAlert');
    var img = alert.urlImageLocal;
    print('alerts::addAlert:: urlImageLocal: $img');

    var date = alert.date;
    print('alerts::addAlert:: alert.date: $date');
    //date = date.replaceAll('/', '-');
    //print('alerts::addAlert:: date replaced: $date');

    int dateMill = format.parse(date).millisecondsSinceEpoch;

    date = dateMill.toString();
    print('alerts::addAlert:: dateMill: $dateMill');
    print(' ');

    try {
      DbUtil.insert('alerts', {
        "id": alert.id,
        "cameraName": alert.cameraName,
        "regionName": alert.regionName,
        "date": dateMill,
        "hour": alert.hour,
        "objectDetected": alert.objectDetected,
        "textAlert": alert.textAlert,
        "urlImageFirebase": alert.urlImageFirebase,
        "urlImageDownload": alert.urlImageDownload,
        "urlImageLocal": alert.urlImageLocal,
      });
    } on Exception catch (e) {
      print('alerts::addAlert:: error: $e');
    }

    this.loadAllAlerts();
    notifyListeners();
  }
/* 
  Future<void> loadAlarms() async {
    final response = await http.get();

    Map<String, dynamic> data = json.decode(response.body);

    final favResponse = await http.get(
        "${Constants.BASE_API_URL}/userFavorites/$_userId.json?auth=$_token");
    final favMap = json.decode(favResponse.body);

    _items.clear();
    if (data != null) {
      data.forEach((productId, productData) {
        final isFavorite = favMap == null ? false : favMap[productId] ?? false;
        _items.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorite,
        ));
      });
      notifyListeners();
    }
    return Future.value();
  } */
}
