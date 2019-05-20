import 'dart:io';
import 'dart:ui' as ui;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_scroll_gallery/flutter_scroll_gallery.dart';

import 'package:flutter_camera/model/photo.dart';
import 'package:flutter_camera/pages/edit_page.dart';
import 'package:flutter_camera/database/database_helper.dart';

class PhotoPage extends StatefulWidget {
  final int currentPage;

  PhotoPage(this.currentPage, {Key key}) : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  bool _hideBar = true;

  int _nowPage;
  var _photosData = List<Photo>();

  @override
  void initState() {
    super.initState();
    _updateImage();
    _nowPage = widget.currentPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: Offstage(
          offstage: _hideBar,
          child: AppBar(
            title: Text("相册", style: Theme.of(context).textTheme.title),
            backgroundColor: Theme.of(context).appBarTheme.color,
            iconTheme: Theme.of(context).appBarTheme.iconTheme,
          ),
        ),
      ),
      backgroundColor: Colors.white10,
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          GestureDetector(
            child: ScrollGallery(
              _albumImages(),
              backgroundColor: _hideBar ? Colors.black : Colors.white,
              interval: Duration(seconds: 3),
              initialIndex: _nowPage,
              onPageChange: (index) {
                setState(() {
                  _nowPage = index;
                });
              },
            ),
            onTap: () {
              _hideBar = !_hideBar;
            },
          ),
        ],
      ),
      bottomNavigationBar: Offstage(
        offstage: _hideBar,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          color: Theme.of(context).bottomAppBarColor,
          child: _bottomBarWidget(),
        ),
      ),
    );
  }

  // Widget 控件
  Widget _bottomBarWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Icon(Icons.mode_edit),
            tooltip: '编辑',
            onPressed: _onButtonEditPressed,
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Icon(Icons.info),
            tooltip: '详细信息',
            onPressed: _onButtonInfoPressed,
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Icon(Icons.delete),
            tooltip: '删除',
            onPressed: _onButtonDeletePressed,
          ),
        ),
      ],
    );
  }

  List<ImageProvider> _albumImages() {
    var images = List<ImageProvider>();

    _photosData.forEach((f) {
      images.add(FileImage(File(f.srcPath)));
    });

    return images;
  }

  // 按钮响应函数
  void _onButtonEditPressed() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditPage(_photosData[_nowPage])));
  }

  void _onButtonInfoPressed() async {
    var nowPhoto = _photosData[_nowPage];
    var completer = Completer<ui.Image>();
    Image.asset(_photosData[_nowPage].srcPath)
        .image
        .resolve(ImageConfiguration())
        .addListener(
            (ImageInfo info, bool _) => completer.complete(info.image));

    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 200,
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 1, child: Text('照片名称：${nowPhoto.name}')),
                  Expanded(flex: 1, child: Text('拍摄时间：${nowPhoto.createDate}')),
                  Expanded(flex: 1, child: Text('修改时间：${nowPhoto.modifyDate}')),
                  Expanded(
                    flex: 1,
                    child: FutureBuilder<ui.Image>(
                      future: completer.future,
                      builder: (context, snapshot) => Text(
                          '照片尺寸： ${snapshot.data.width} x ${snapshot.data.height}'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _onButtonDeletePressed() async {
    var db = DatabaseHelper();

    var id = _photosData[_nowPage].id;
    var photo = await db.getPhoto(id);
    db.deletePhoto(id);

    File(photo.srcPath).deleteSync();
    File(photo.thumbPath).deleteSync();

    await _updateImage();
  }

  // 辅助功能函数
  Future _updateImage() async {
    var db = DatabaseHelper();

    _photosData = await db.getAllPhotos();
    setState(() {});
  }
}
