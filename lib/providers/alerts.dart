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

  List<Alert> _items = [];

  void loadItemsTest() async {
    print('alerts::loadItemsTest');
    for (Alert item in ALERTS_DUMMY) {
      String imageSavedPath = await saveImage(item.urlImageDownload, item.id);
      print('imageSavedPath: $imageSavedPath');
      item.urlImageLocal = imageSavedPath;
      addAlert(item);
      print('alerts::addAlert chamado');
      this.loadItems();
      notifyListeners();
    }
  }

  Future<void> loadItemsAfterDate(DateTime date) async {
    DateFormat format = new DateFormat("MM-dd-yyyy");
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
    var format = DateFormat('dd-MM-yyyy');
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
    DateFormat format = new DateFormat("MM-dd-yyyy");
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

  Future<void> saveAlertDevice(msg) async {
    final dynamic notification = msg['notification'];
    final dynamic data = msg['data'];

    print('alerts::saveAlertDevice');

    String imageSavedPath =
        await saveImage(data['urlImageFirebase'], data['id']);

    print('alerts::imageSavedPath $imageSavedPath');

    final al = Alert(
        id: data['id'],
        cameraName: data['cameraName'],
        regionName: data['regionName'],
        date: data['date'],
        objectDetected: data['objectDetected'],
        textAlert: notification['body'],
        urlImageDownload: data['urlImageDownload'],
        urlImageFirebase: data['urlImageFirebase'],
        urlImageLocal: imageSavedPath);

    addAlert(al);
  }

  void addAlert(Alert alert) {
    DateFormat format = new DateFormat("MM-dd-yyyy");

    print('alerts::addAlert');
    var img = alert.urlImageLocal;
    print('alerts::addAlert:: urlImageLocal: $img');

    var date = alert.date;
    print('alerts::addAlert:: alert.date: $date');
    date = date.replaceAll('/', '-');
    print('alerts::addAlert:: date replaced: $date');

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
