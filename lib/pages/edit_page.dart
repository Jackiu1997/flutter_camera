import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_camera/model/photo.dart';
import 'package:flutter_camera/pages/edit_cut_page.dart';

class EditPage extends StatefulWidget {
  final Photo photo;

  EditPage(this.photo, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _EditPageState();
}

class _EditPageState extends State<EditPage> {
  Photo _photo;
  Image _image;
  double _rotate;

  @override
  void initState() {
    super.initState();
    _photo = widget.photo;
    _image = Image.asset(_photo.srcPath);
    _rotate = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑', style: Theme.of(context).textTheme.title),
        backgroundColor: Theme.of(context).appBarTheme.color,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: Transform.rotate(
            child: _image,
            angle: _rotate,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        color: Theme.of(context).bottomAppBarColor,
        child: _bottomBarWidget(),
      ),
    );
  }

  // Widget 控件
  Widget _bottomBarWidget() {
    return SizedBox(
      width: 300,
      height: 40,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.content_cut),
              tooltip: '裁剪',
              onPressed: _onButtonCropPressed,
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.rotate_right),
              tooltip: '旋转',
              onPressed: _onButtonRotatePressed,
            ),
          ),
        ],
      ),
    );
  }

  // 按钮响应函数
  void _onButtonCropPressed() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CutPage(_photo)));
  }

  void _onButtonRotatePressed() {
    setState(() {
      _rotate = _rotate == 1.5 * pi ? 0.0 : _rotate + 0.5 * pi;
    });
  }
}
