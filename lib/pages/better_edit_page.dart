import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_cropper/image_cropper.dart';
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
  File _croppedFile;

  @override
  void initState() {
    super.initState();
    _photo = widget.photo;
    _imgFile = File(_photo.srcPath);
    _croppedFile = _imgFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: Image.file(_croppedFile),
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
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: _croppedFile.path,
      ratioX: 1.0,
      ratioY: 1.0,
    );
    setState(() {
     _croppedFile = croppedFile; 
    });
  }
}
