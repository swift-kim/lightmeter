import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      MaterialApp(title: 'Lightmeter', home: MainPage());
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  StreamSubscription<GyroscopeEvent> _listener;
  int value = 0;

  @override
  void dispose() {
    super.dispose();
    _listener?.cancel();
  }

  void initState() {
    super.initState();

    Wakelock.enable();

    _listener = gyroscopeEvents.listen((GyroscopeEvent event) {
      final newValue = event.x.round();
      if (value != newValue) {
        setState(() => value = newValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment(0, 0),
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
              flex: 2000 - min(2000, value),
              child: Container(color: Colors.grey[800]),
            ),
            Expanded(
              flex: min(2000, value),
              child: Container(color: Colors.grey[200]),
            ),
          ],
        ),
        Text(
          '$value',
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 100,
            fontWeight: FontWeight.w300,
            color: Colors.grey[600],
            decoration: TextDecoration.none,
          ),
        ),
        Column(
          children: <Widget>[
            Expanded(flex: 2, child: Container()),
            Expanded(
              flex: 1,
              child: Text(
                'lux',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[600],
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
