import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_camera/tools/photo_tools.dart';
import 'package:flutter_camera/pages/album_page.dart';

/// 相机主页面
///
///   用于进行照相操作，采用 camera 获取相机流数据
///
class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraPage(this.cameras, {Key key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController controller;
  int nowCamera = 1;

  @override
  void initState() {
    super.initState();

    _onButtonChangeCameraPressed();
    checkNotInDBPhotos();
  }

  @override
  void dispose() {
    controller?.dispose();

    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              color: Colors.black,
              child: _cameraPreViewWidget(),
            ),
            Positioned(
              bottom: 18.0,
              child: _bottomBarWidget(),
            ),
          ],
        ),
      ),
      onWillPop: () => SystemNavigator.pop(),
    );
  }

  /// 子 Widget 定义
  ///
  /// 相机预览 Widget
  Widget _cameraPreViewWidget() {
    return Center(
      child: !controller.value.isInitialized
          ? null
          : AspectRatio(
              aspectRatio:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 1 / controller.value.aspectRatio
                      : controller.value.aspectRatio,
              child: CameraPreview(controller),
            ),
    );
  }

  /// 页面底部按钮 Widget
  Widget _bottomBarWidget() {
    var btnGroup = <Widget>[
      Expanded(
        flex: 1,
        child: FloatingActionButton(
          heroTag: "btn1",
          child: Icon(Icons.photo),
          backgroundColor: Color(0x50FFFFFF),
          onPressed: _onButtonOpenAlbumPressed,
        ),
      ),
      Expanded(
        flex: 1,
        child: FloatingActionButton(
          heroTag: "btn2",
          child: Icon(Icons.camera),
          backgroundColor: Color(0x50FFFFFF),
          onPressed: _onButtonTakePhotoPressed,
        ),
      ),
      Expanded(
        flex: 1,
        child: FloatingActionButton(
          heroTag: "btn3",
          child: nowCamera == 0
              ? Icon(Icons.camera_rear)
              : Icon(Icons.camera_front),
          backgroundColor: Color(0x50FFFFFF),
          onPressed: _onButtonChangeCameraPressed,
        ),
      ),
    ];

    return SizedBox(
      width: 300,
      height: 90,
      child: Row(children: btnGroup),
    );
  }

  /// 按钮事件响应
  ///
  /// 进入相册按钮响应
  void _onButtonOpenAlbumPressed() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AlbumPage()));
  }

  /// 拍照按钮响应
  void _onButtonTakePhotoPressed() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/IMG_${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      return null;
    }
    final image = await controller.takePicture();
    image.saveTo(filePath);
    createPhotoData(filePath);
  }

  /// 转换摄像头按钮响应
  void _onButtonChangeCameraPressed() async {
    nowCamera = nowCamera == 0 ? 1 : 0;
    CameraDescription cameraDescription = widget.cameras[nowCamera];
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);
    controller.addListener(() {
      if (mounted) setState(() {});
    });
    await controller.initialize();
    if (mounted) setState(() {});
  }

  /// 生成当前时间戳，用作相片名称一部分
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
}
