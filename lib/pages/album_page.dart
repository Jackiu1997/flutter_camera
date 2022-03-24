import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_camera/database/database_helper.dart';
import 'package:flutter_camera/pages/photo_page.dart';

/// 相册界面
///   显示大量相片缩略图，造成内存拥挤
///
class AlbumPage extends StatefulWidget {
  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  int gridAxisCount = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('相册')),
      body: FutureBuilder(
          future: _updateImage(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? _buildGridView(snapshot.data)
                : Container();
          }),
    );
  }

  Widget _buildGridView(List<String> thumbData) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridAxisCount,
          childAspectRatio: 1.0,
        ),
        padding: const EdgeInsets.only(right: 12),
        itemCount: thumbData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 12, left: 12),
            child: GestureDetector(
              child: Image.file(
                File(thumbData[index]),
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PhotoPage(index)));
              },
            ),
          );
        });
  }

  /// 从数据库异步读入相片数据
  Future<List<String>> _updateImage() async {
    var photosData = await DatabaseHelper.to.getAllPhotos();
    var thumbData = <String>[];
    photosData.forEach((f) => thumbData.add(f.thumbPath));
    return thumbData;
  }
}
