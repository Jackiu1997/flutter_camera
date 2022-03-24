import 'dart:io';

import 'package:flutter/material.dart';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter_camera/model/photo.dart';
import 'package:flutter_camera/tools/photo_tools.dart';

/// 裁剪照片界面
///
///   进行相片的裁剪，目前有矩形框裁剪功能
///   todo： 增加额外裁剪功能 如不同形状裁剪框
///
class CropPage extends StatefulWidget {
  final Photo photo;

  CropPage(this.photo, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _CropPageState();
}

class _CropPageState extends State<CropPage> {
  /// 传入的相片数据
  Photo _photo;

  /// 使用照片文件
  File _imgFile;

  /// 裁剪页面所需 key
  final _controller = CropController();

  @override
  void initState() {
    super.initState();
    _photo = widget.photo;
    _imgFile = File(_photo.srcPath);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).backgroundColor,
        child: Crop(
          image: _imgFile.readAsBytesSync(),
          controller: _controller,
          onCropped: (image) async {
            // do something with image data
            _imgFile.writeAsBytesSync(image);
            await updatePhotoData(_photo);
            Navigator.pop(context);
          },
          interactive: true,
          initialAreaBuilder: (rect) => Rect.fromLTRB(rect.left + 32,
              rect.top + 100, rect.right - 32, rect.bottom - 100),
        ),
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.08,
        color: Theme.of(context).bottomAppBarColor,
        child: _bottomBarWidget(context),
      ),
    );
  }

  Row _bottomBarWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Icon(Icons.save),
            tooltip: '保存',
            onPressed: () => _controller.crop(),
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Icon(Icons.cancel),
            tooltip: '取消',
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}
