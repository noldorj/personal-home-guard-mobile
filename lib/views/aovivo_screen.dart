// 'rtsp://admin:WWYZRL@192.168.5.101:554/profile0'
// 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
// 'https://media.w3.org/2010/05/sintel/trailer.mp4'

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

/*
void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AoVivo(),
    );
  }
}
*/

class AoVivo extends StatefulWidget {
  AoVivo({Key key}) : super(key: key);

  @override
  _AoVivoState createState() => _AoVivoState();
}

class _AoVivoState extends State<AoVivo> with WidgetsBindingObserver {
  VlcPlayerController _videoPlayerController;
  //int _lastSize;

  @override
  void initState() {
    super.initState();

    //_lastSize = 0;
    WidgetsBinding.instance.addObserver(this);

    _videoPlayerController = VlcPlayerController.network(
      'rtsp://admin:WWYZRL@192.168.5.101:554/profile0',
      hwAcc: HwAcc.AUTO,
      autoPlay: true,
      autoInitialize: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcVideoOptions.dropLateFrames(true),
          VlcAdvancedOptions.liveCaching(100),
          VlcAdvancedOptions.networkCaching(200),
          VlcStreamOutputOptions.soutMuxCaching(0),
          VlcAdvancedOptions.clockSynchronization(0)
        ]),
        video: VlcVideoOptions([VlcVideoOptions.skipFrames(true)]),
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController.stopRendererScanning();
    await _videoPlayerController.dispose();
  }

  /*
  @override
  void didChangeMetrics() {
    print('didChange');
    print(' ');
    setState(() {
      if (_lastSize == 0) {
        _lastSize = 1;
      } else {
        _lastSize = 0;
      }
    });
    
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: RotatedBox(
          quarterTurns: 1,
          child: VlcPlayer(
            controller: _videoPlayerController,
            aspectRatio: 16 / 9,
            placeholder: Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}

/*
Center(
          child: VlcPlayer(
            controller: _videoPlayerController,
            aspectRatio: 16 / 9,
            placeholder: Center(child: CircularProgressIndicator()),
          )
          */