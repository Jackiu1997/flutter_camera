import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_camera/pages/camera_page.dart';


// 相机描述符
List<CameraDescription> cameras;        

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 获取相机描述符
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

/// 启动页
/// 
///   用于显示 APP 启动时的空白响应期
/// 
class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  
  // 启动延时操作，显示时间到后进入相机页面
  startTime() async {
    var _duration = Duration(seconds: 1);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CameraPage(cameras)));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 150.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/launch_image.png',
                width: 200.0,
                height: 200.0,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Flutter Camera',
                    style: Theme.of(context).textTheme.display2),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text('Created By Jackiu',
                    style: Theme.of(context).textTheme.display1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
