import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import 'package:pv/utils/appRoutes.dart';
//import 'package:pv/utils/db_util.dart';
import 'package:pv/widgets/drawer_configuracoes_sair.dart';

import '../providers/alerts.dart';

class MainManagement extends StatefulWidget {
  final RemoteMessage msg;

  @override
  _MainManagementState createState() => _MainManagementState(this.msg);

  MainManagement(this.msg);
}

class _MainManagementState extends State<MainManagement> {
  final RemoteMessage msg;

  _MainManagementState(this.msg);

  DateTime _selectedDate, _yesterday, _today, _weekPeriod, _monthPeriod;

  FlutterLocalNotificationsPlugin fltNotification;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    enableLights: true,
    showBadge: true,
    ledColor: Colors.lightBlue,
  );

  @override
  initState() {
    notitficationPermission();
    initMessaging();
    initializeFlutterFire();
    super.initState();
  }

  void initMessaging() async {
    var androiInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    var iosInit = IOSInitializationSettings();

    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);

    //await FirebaseMessaging.instance.subscribeToTopic('igorddf.gmail.com');

    fltNotification = FlutterLocalNotificationsPlugin();
    await fltNotification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    fltNotification.initialize(initSetting);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      //print('onMessage.listen');

      final alerts = Provider.of<Alerts>(context, listen: false);

      alerts.saveAlertDevice(message);

      //RemoteNotification notification = message.notification;
      // AndroidNotification android = message.notification.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      /*
      if (notification != null && android != null) {
        await fltNotification.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // other properties...
              ),
            ));
      }
      */

      showNotification(message);
    });
  }

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      print('Error Firebase.initializeApp(): ${e.toString()}');
    }
  }

  void showNotification(RemoteMessage msg) async {
    var androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channel.description,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      channelShowBadge: true,
      ledColor: Colors.lightBlue,
      priority: Priority.high,
    );

    //print('Channel name: ${androidDetails.channelName}');

    var iosDetails = IOSNotificationDetails();

    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await fltNotification.show(0, msg.notification.title, msg.notification.body,
        generalNotificationDetails,
        payload: 'Notification');
  }

  void notitficationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    print(
        'notitficationPermission:: seetings: ${settings.authorizationStatus}');
  }

  _showDatePicker() {
    final alerts = Provider.of<Alerts>(context, listen: false);
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
        alerts.loadItemsByDate(_selectedDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Alerts alertActions = Provider.of<Alerts>(context, listen: false);
    final alertUpdate = Provider.of<Alerts>(context, listen: true);

    if (this.msg != null) {
      //print('_MainManagementState::build - Message received at loginScreen: ${this.msg.notification.title}');
      alertActions.saveAlertDevice(this.msg);
      //alertActions.loadItemsByDate(DateTime.now());
    }
    /*
    setState(() {
      alertActions.loadItemsByDate(DateTime.now());
      alertActions.loadAllAlerts();
    });
    */

    //DbUtil.deleteDatabase();
    //DbUtil.deleteAll();

    return Scaffold(
      appBar: AppBar(
        title: Text('Portão Virtual - Gerenciador'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: AppDrawer(),
      ),
      body: Column(
        children: [
          // COLUNA COM MODAL de "CALENDARIO"
          Column(
            children: [
              TextButton(
                onPressed: _showDatePicker,
                child: Text('Selecionar data'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.AOVIVO,
                  );
                },
                child: Text('Ver Ao-vivo'),
              ),
              Card(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => {
                              _today = DateTime.now(),
                              alertActions.loadItemsByDate(_today),
                              //print('_today: $_today')
                            },
                        child: Text('Hoje')),
                    TextButton(
                        onPressed: () => {
                              _yesterday =
                                  DateTime.now().subtract(Duration(days: 1)),
                              alertActions.loadItemsByDate(_yesterday),
                              //print('_yesterday: $_yesterday')
                            },
                        child: Text('Ontem')),
                    TextButton(
                      onPressed: () => {
                        _weekPeriod =
                            DateTime.now().subtract(Duration(days: 7)),
                        alertActions.loadItemsAfterDate(_weekPeriod),
                        //print('weekPeriod: $_weekPeriod')
                      },
                      child: Text('Da semana'),
                    ),
                    TextButton(
                      onPressed: () => {
                        _monthPeriod =
                            DateTime.now().subtract(Duration(days: 30)),
                        alertActions.loadItemsAfterDate(_monthPeriod),
                        //print('_monthPeriod: $_monthPeriod')
                      },
                      child: Text('Do Mês'),
                    ),
                    TextButton(
                      onPressed: () => {alertActions.loadAllAlerts()},
                      child: Text('Todos'),
                    ),
                  ],
                ),
              ),
              Card(
                  color: Colors.white60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () => {
                                alertActions.loadItemsByPeriod('manha'),
                                //print('_yesterday: $_yesterday')
                              },
                          child: Text('Manhã')),
                      TextButton(
                          onPressed: () => {
                                alertActions.loadItemsByPeriod('tarde'),
                                //print('_yesterday: $_yesterday')
                              },
                          child: Text('Tarde')),
                      TextButton(
                          onPressed: () => {
                                alertActions.loadItemsByPeriod('noite'),
                                //print('_yesterday: $_yesterday')
                              },
                          child: Text('Noite')),
                      TextButton(
                          onPressed: () => {
                                alertActions.loadItemsByPeriod('madrugada'),
                                //print('_yesterday: $_yesterday')
                              },
                          child: Text('Madrugada')),
                    ],
                  )),
            ],
          ),

          FutureBuilder(
            future: Provider.of<Alerts>(context, listen: false).loadItems(),
            builder: (ctx, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Consumer<Alerts>(
                    child: Center(
                      child: Text('Nenhum alarme gravado !'),
                    ),
                    builder: (ctx, listAlerts, ch) => listAlerts.itemsCount == 0
                        ? ch
                        :
                        // LISTA DE ALERTAS
                        Expanded(
                            child: Container(
                              child: ListView.builder(
                                itemCount: listAlerts.itemsCount,
                                itemBuilder: (ctx, i) => ListTile(
                                  leading: Container(
                                    height: 110,
                                    width: 110,
                                    decoration: BoxDecoration(
                                      image: new DecorationImage(
                                        image: FileImage(File(listAlerts
                                            .itemByIndex(i)
                                            .urlImageLocal)),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                  title: Text(listAlerts.itemByIndex(i).date +
                                      ' - ' +
                                      listAlerts.itemByIndex(i).hour),
                                  subtitle: Row(children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(listAlerts
                                                .itemByIndex(i)
                                                .cameraName)
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('Região: '),
                                            Text(listAlerts
                                                .itemByIndex(i)
                                                .regionName)
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                          alignment: Alignment.topRight,
                                          icon:
                                              const Icon(Icons.delete_outline),
                                          onPressed: () => {
                                            listAlerts.deleteById(
                                                listAlerts.itemByIndex(i).id),
                                          },
                                        ),
                                      ],
                                    ),
                                  ]),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      AppRoutes.IMAGE_ALERT,
                                      arguments: listAlerts.itemByIndex(i),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 30.0,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 2.0)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            '  Quantidade alertas: ${alertUpdate.itemsCount}',
            style: TextStyle(color: Colors.blueGrey),
          ),
        ]),
      ),
    );
  }
}
