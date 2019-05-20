import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_crop/image_crop.dart';
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
  final cropKey = GlobalKey<CropState>();

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
      body: Center(
        child: Container(
          color: Colors.white,
          child: Crop.file(_imgFile, key: cropKey),
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        color: Theme.of(context).bottomAppBarColor,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.save),
                tooltip: '保存',
                onPressed: _onButtonSavePressed,
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.cancel),
                tooltip: '取消',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 存储按钮响应
  void _onButtonSavePressed() async {
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;
    if (area == null) {
      return;
    }
    final sample = await ImageCrop.sampleImage(
      file: _imgFile,
      preferredSize: (2000 / scale).round(),
    );
    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );
    sample.delete();

    _imgFile.writeAsBytesSync(file.readAsBytesSync());
    await updatePhotoData(_photo);

    Navigator.pop(context);
  }
}
