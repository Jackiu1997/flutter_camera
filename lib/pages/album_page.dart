import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_camera/model/photo.dart';
import 'package:flutter_camera/database/database_helper.dart';
import 'package:flutter_camera/pages/photo_view_page.dart';

class AlbumPage extends StatefulWidget {
  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  var _photosData = List<Photo>();

  @override
  void initState() {
    super.initState();
    _updateImage();
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
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
        ),
        padding: EdgeInsets.all(10.0),
        children: _photosSizedBoxWidget(),
      ),
    );
  }

  // 控件Widget
  List<Widget> _photosSizedBoxWidget() {
    List<Widget> albums = List<Widget>();

    for (var i = 0; i < _photosData.length; i++) {
      albums.add(SizedBox(
        height: 190,
        width: 190,
        child: GestureDetector(
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.asset(_photosData[i].thumbPath, fit: BoxFit.cover),
            ),
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PhotoPage(i)));
          },
        ),
      ));
    }

    return albums;
  }

  // 辅助函数
  Future _updateImage() async {
    var db = DatabaseHelper();
    List<Photo> photos = await db.getAllPhotos();
    setState(() {
      _photosData = photos;
    });
  }
}
