import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_camera/model/photo.dart';
import 'package:flutter_camera/database/database_helper.dart';
import 'package:flutter_camera/pages/photo_page.dart';

/// 相册界面
///   显示大量相片缩略图，造成内存拥挤
///   todo: 修复内存消耗问题（初步判断为 Flutter 框架消耗问题）
/// 
class AlbumPage extends StatefulWidget {
  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  var _photosData = List<Photo>();
  var _thumbData = List<String>();

  @override
  void initState() {
    super.initState();
    _updateImage();
  }

  @override
  void dispose() {
    _photosData?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('相册', style: Theme.of(context).textTheme.title),
        backgroundColor: Theme.of(context).appBarTheme.color,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
          ),
          itemCount: _thumbData.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset(
                    _thumbData[index],
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PhotoPage(index)));
              },
            );
          }),
    );
  }

  /// 从数据库异步读入相片数据
  Future _updateImage() async {
    var db = DatabaseHelper();

    _photosData = await db.getAllPhotos();
    _photosData.forEach((f) {
      _thumbData.add(f.thumbPath);
    });
    setState(() {});
  }
}
