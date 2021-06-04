import 'package:flutter/foundation.dart';

class Alert {
  final String id;
  final String cameraName;
  final String regionName;
  final String date;
  final String hour;
  final String objectDetected;
  final String textAlert;
  final String urlImageFirebase;
  final String urlImageDownload;
  String urlImageLocal;

  Alert({
    @required this.id,
    @required this.cameraName,
    @required this.regionName,
    @required this.date,
    @required this.hour,
    @required this.objectDetected,
    @required this.textAlert,
    @required this.urlImageFirebase,
    @required this.urlImageDownload,
    @required this.urlImageLocal,
  });
}
