import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_crop/image_crop.dart';
import 'package:flutter_camera/model/photo.dart';
import 'package:flutter_camera/tools/photo_tools.dart';

class CutPage extends StatefulWidget {
  final Photo photo;

  CutPage(this.photo, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _CutPageState();
}

class _CutPageState extends State<CutPage> {
  Photo _photo;
  File _imgFile;
  final cropKey = GlobalKey<CropState>();

  @override
  void initState() {
    super.initState();
    _photo = widget.photo;
    _imgFile = File(_photo.srcPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
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
