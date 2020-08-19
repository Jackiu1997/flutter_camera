import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_camera/pages/splash_page.dart';

import 'pages/camera_page.dart';


// 相机描述符
List<CameraDescription> cameras;

Future<void> main() async {
  // 获取相机描述符
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  // APP 页面： 页面主题设置等
  runApp(MaterialApp(
    title: 'Flutter Camera',
    home: SplashPage(),
    theme: ThemeData(
      primaryColor: Colors.white,
      appBarTheme: AppBarTheme(
        color: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
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
         display2: TextStyle(
          color: Colors.blueGrey,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ));

  // 设置安卓沉浸式状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}
