import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fb_utils/fb_utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Column(
            children: [
              Text('fb utils'),
              ElevatedButton(
                onPressed: () {
                  FbUtils.getMD5WithSring("fb");
                },
                child: Text('md5 string'),
              ),
              ElevatedButton(
                onPressed: () {
                  FbUtils.hideKeyboard();
                },
                child: Text('hide keyboard'),
              ),
            ],
          )),
    );
  }
}
