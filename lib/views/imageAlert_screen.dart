import 'dart:io';

import 'package:flutter/material.dart';

import '../providers/alert.dart';

class ImageAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Alert alert = ModalRoute.of(context).settings.arguments;
    var image = new File(alert.urlImageLocal);
    var date = alert.date;
    var camera = alert.cameraName;

    return Scaffold(
      appBar: AppBar(
        title: Text(alert.textAlert),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Image.file(
                image,
              ),
            ),
            Text('$date'),
            Text('$camera'),
          ],
        ),
      ),
    );
  }
}
