import 'dart:async';

import 'package:flutter/material.dart';

import '../main.dart';
import 'camera_page.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/launch_image.png',
              width: 200.0,
              height: 200.0,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Flutter Camera',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                'Created By Jackiu',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
