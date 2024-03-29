import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(MaterialApp(home: MainPage()));
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late StreamSubscription<GyroscopeEvent> _listener;
  int _luxValue = 0;
  bool _useFootcandle = false;

  @override
  void initState() {
    super.initState();

    Wakelock.enable();

    _listener = gyroscopeEvents.listen((GyroscopeEvent event) {
      final newValue = event.x.round();
      if (_luxValue != newValue) {
        setState(() => _luxValue = newValue);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _listener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _useFootcandle = !_useFootcandle);
      },
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 2000 - min(2000, _luxValue),
                child: Container(color: Colors.grey[800]),
              ),
              Expanded(
                flex: min(2000, _luxValue),
                child: Container(color: Colors.grey[200]),
              ),
            ],
          ),
          Center(
            child: Text(
              _useFootcandle
                  ? (_luxValue / 10.764).toStringAsFixed(1)
                  : _luxValue.toString(),
              maxLines: 1,
              style: TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.w300,
                color: Colors.grey[600],
                decoration: TextDecoration.none,
                letterSpacing: -2.0,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.6),
            child: Text(
              _useFootcandle ? 'fc' : 'lux',
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
    );
  }
}
