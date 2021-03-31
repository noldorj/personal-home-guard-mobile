import 'dart:io';

import 'package:flutter/material.dart';

import '../providers/alert.dart';

class ImageAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Alert alert = ModalRoute.of(context).settings.arguments;
    var image = new File(alert.urlImageLocal);

    return Scaffold(
      appBar: AppBar(
        title: Text(alert.textAlert),
      ),
      body: Container(
        width: double.infinity,
        child: Image.file(
          image,
          fit: BoxFit.fitWidth,
          width: double.infinity,
        ),
      ),
    );
  }
}
