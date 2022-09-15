import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  var turkey = tz.getLocation('Europe/Istanbul');
  tz.setLocalLocation(turkey);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _configureLocalTimeZone();

  runApp(new MaterialApp(
    theme: ThemeData(
        appBarTheme: AppBarTheme(
      color: Colors.red,
    )),
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('flutter_devs');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOs,
      macOS: null,
    );

    flutterLocalNotificationsPlugin.initialize(
      initSetttings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future<Widget> onSelectNotification(String payload) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewScreen(
          payload: payload,
        ),
      ),
    );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
      'id',
      'channel ',
      'description',
      priority: Priority.high,
      importance: Importance.max,
      playSound: true,
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(
      android: android,
      iOS: iOS,
      macOS: null,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Flutter devs',
      'Flutter Local Notification Demo',
      platform,
      payload: 'Welcome to the Local Notification demo ',
    );
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> scheduleNotification() async {
    var scheduledNotificationDateTime =
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));
    // DateTime.now().add(Duration(seconds: 5));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      icon: 'flutter_devs',
      largeIcon: DrawableResourceAndroidBitmap('flutter_devs'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
      macOS: null,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'scheduled title',
      'scheduled body',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation: null,
      androidAllowWhileIdle: false,
    );
  }

  Future<void> showBigPictureNotification() async {
    var bigPictureStyleInformation = BigPictureStyleInformation(
      DrawableResourceAndroidBitmap("flutter_devs"),
      largeIcon: DrawableResourceAndroidBitmap("flutter_devs"),
      contentTitle: 'flutter devs',
      htmlFormatContentTitle: true,
      summaryText: 'summaryText',
      htmlFormatSummaryText: true,
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'big text channel id',
      'big text channel name',
      'big text channel description',
      styleInformation: bigPictureStyleInformation,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: null,
      macOS: null,
    );
    await flutterLocalNotificationsPlugin.show(
      2,
      'big text title',
      'silent body',
      platformChannelSpecifics,
      payload: "big image notifications",
    );
  }

  Future<void> showNotificationMediaStyle() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'media channel id',
      'media channel name',
      'media channel description',
      color: Colors.red,
      enableLights: true,
      largeIcon: DrawableResourceAndroidBitmap("flutter_devs"),
      styleInformation: MediaStyleInformation(),
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: null,
      macOS: null,
    );
    await flutterLocalNotificationsPlugin.show(
      3,
      'notification title',
      'notification body',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Flutter notification demo'),
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: showNotification,
              child: new Text(
                'showNotification',
              ),
            ),
            RaisedButton(
              onPressed: cancelNotification,
              child: new Text(
                'cancelNotification',
              ),
            ),
            RaisedButton(
              onPressed: scheduleNotification,
              child: new Text(
                'scheduleNotification',
              ),
            ),
            RaisedButton(
              onPressed: showBigPictureNotification,
              child: new Text(
                'showBigPictureNotification',
              ),
            ),
            RaisedButton(
              onPressed: showNotificationMediaStyle,
              child: new Text(
                'showNotificationMediaStyle',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewScreen extends StatelessWidget {
  final String payload;

  NewScreen({
    @required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(payload),
      ),
    );
  }
}
