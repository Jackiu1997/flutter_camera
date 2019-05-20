import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;

import 'package:flutter_camera/model/photo.dart';
import 'package:flutter_camera/tools/photo_tools.dart';

class FilterPage extends StatefulWidget {
  final Photo photo;

  FilterPage(this.photo, {Key key}) : super(key: key);

  @override
  _FilterPageState createState() => new _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String _fileName;
  File _srcFile;
  imageLib.Image _image;

  @override
  void initState() {
    super.initState();
    _fileName = widget.photo.name;
    _srcFile = File(widget.photo.srcPath);
    _image = imageLib.decodeImage(_srcFile.readAsBytesSync());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment(0.0, 0.0),
        child: PhotoFilterSelector(
                title: Text('滤镜'),
                image: _image,
                filters: presetFitersList,
                filename: _fileName,
                loader: Center(child: CircularProgressIndicator()),
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
    File(widget.photo.srcPath).writeAsBytesSync(imageLib.writeJpg(_image));
    await updatePhotoData(widget.photo);

    Navigator.pop(context);
  }
}