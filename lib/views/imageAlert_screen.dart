import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';

import '../providers/alert.dart';

class ImageAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Alert alert = ModalRoute.of(context).settings.arguments;
    var image = new File(alert.urlImageLocal);

    //var aux = alert.date.split('-');
    //var date = aux[1] + '/' + aux[0] + '/' + aux[2];
    var camera = alert.cameraName;
    var date = alert.date;
    //var format = DateFormat('dd/MM/yyyy');
    //String newDate = format.parse(date).toString();

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
