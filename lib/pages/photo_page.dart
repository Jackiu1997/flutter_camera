import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'package:flutter_camera/model/photo.dart';
import 'package:flutter_camera/database/database_helper.dart';
import 'package:flutter_camera/tools/photo_tools.dart';
import 'package:flutter_camera/pages/crop_page.dart';

/// 相片详情界面
///
///   用于完整原图相片的展示，采用 PhotoView 作为预览 Widget
///   内部已经集成放大等基本操作
///   由此界面可进入裁剪界面
///
class PhotoPage extends StatefulWidget {
  final int currentPage;

  PhotoPage(this.currentPage, {Key key}) : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  /// AppBar 和 BottomBar 是否隐藏控制
  var _hideBar = true;

  /// 传入的当前浏览照片位置
  int _nowPage;

  /// 相片数据列表
  var _photosData = List<Photo>();

  /// PageView 控制器
  PageController _pageContorller;

  @override
  void initState() {
    super.initState();
    _updateImage();
    _nowPage = widget.currentPage;
    _pageContorller = PageController(initialPage: _nowPage);
  }

  @override
  void dispose() {
    _pageContorller?.dispose();
    _photosData?.clear();
    super.dispose();
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
      body: GestureDetector(
        child: _photosData.isEmpty
            ? Text("")
            : PageView.builder(
                controller: _pageContorller,
                itemCount: _photosData.length,
                itemBuilder: (context, index) => PhotoView(
                    imageProvider: FileImage(File(_photosData[index].srcPath))),
                onPageChanged: (index) {
                  setState(() {
                    _nowPage = index;
                  });
                },
              ),
        onTap: () {
          setState(() {
            _hideBar = !_hideBar;
          });
        },
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

  /// 子Widget 控件
  ///
  /// 底部按钮 Widget
  Widget _bottomBarWidget() {
    return Row(
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

  /// 按钮响应
  ///
  /// 裁剪按钮响应（进入裁剪界面）
  void _onButtonCropPressed() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CropPage(_photosData[_nowPage])));
    setState(() {});
  }

  /// 显示相片信息按钮响应
  void _onButtonInfoPressed() {
    var nowPhoto = _photosData[_nowPage];
    // 显示弹出式 sheet 显示当前浏览图片数据
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 300,
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 1, child: Text('照片名称：${nowPhoto.name}')),
                  Expanded(flex: 1, child: Text('拍摄时间：${nowPhoto.createDate}')),
                  Expanded(flex: 1, child: Text('修改时间：${nowPhoto.modifyDate}')),
                  Expanded(flex: 2, child: Text('原图路径：${nowPhoto.srcPath}')),
                  Expanded(flex: 2, child: Text('缩略图路径：${nowPhoto.thumbPath}')),
                ],
              ),
            ),
          );
        });
  }

  /// 删除相片按钮响应
  void _onButtonDeletePressed() {
    var photo = _photosData[_nowPage];
    setState(() {
      _photosData.removeAt(_nowPage);
    });
    // 调用 photo_tools 中的删除功能
    deletePhotoData(photo);
  }

  /// 更新显示图片数据
  Future _updateImage() async {
    var db = DatabaseHelper();
    _photosData = await db.getAllPhotos();
    setState(() {});
  }
}
