import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_camera/pages/camera_page.dart';

List<CameraDescription> cameras;

void main() async {
  cameras = await availableCameras();
  runApp(new FlutterCameraApp());
  // 设置沉浸式状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class FlutterCameraApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MyState();
}

class _MyState extends State<FlutterCameraApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Camera',
      home: CameraPage(cameras),
      theme: ThemeData(
        primaryColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: Theme.of(context).textTheme,
        ),
        bottomAppBarColor: Colors.white,
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          display1: TextStyle(
            color: Colors.black,
            fontSize: 10.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
