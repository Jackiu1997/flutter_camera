import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:compressimage/compressimage.dart';
import 'package:flutter_camera/model/photo.dart';
import 'package:flutter_camera/database/database_helper.dart';

/// 创建 Photo 数据并存入数据库，缩略图创建
Future createPhotoData(String srcPath) async {
  var db = DatabaseHelper();

  // 寻找存储文件夹
  var extDir = await getApplicationDocumentsDirectory();
  var compressDir = await Directory('${extDir.path}/Thumbnail/').create();
  var compressPath = compressDir.path + srcPath.split('/').last;

  // 生成缩略图
  await File(srcPath).copy(compressPath);
  await CompressImage.compress(imageSrc: compressPath, desiredQuality: 7);

  // Photo 数据加入数据库
  var nowTime = DateTime.now().toString();
  Photo photo = Photo(srcPath, compressPath, nowTime, nowTime);
  db.savePhoto(photo);
}

/// 更新 Photo 数据并存入数据库，缩略图更新
Future updatePhotoData(Photo photo) async {
  var db = DatabaseHelper();

  await File(photo.srcPath).copy(photo.thumbPath);
  await CompressImage.compress(imageSrc: photo.thumbPath, desiredQuality: 7);

  photo.modifyDate = DateTime.now().toString();
  db.updatePhoto(photo);
}

/// 删除 Photo 数据，源文件，缩略图等信息
Future deletePhotoData(Photo photo) async {
  var db = DatabaseHelper();

  File(photo.srcPath).deleteSync();
  File(photo.thumbPath).deleteSync();
  db.deletePhoto(photo.id);
}

/// 检查未加入数据库的异常照片并将创建 Photo 数据和缩略图 加入数据库
Future checkNotInDBPhotos() async {
  var db = DatabaseHelper();

  var extDir = await getApplicationDocumentsDirectory();
  var srcDir = await Directory('${extDir.path}/Pictures').create();
  var srcFiles = srcDir.listSync();
  
  for (var file in srcFiles) {
    if (!await db.isInDatabase(file.path)) {
      var compressDir = await Directory('${extDir.path}/Thumbnail/').create();
      var compressPath = compressDir.path + file.path.split('/').last;

      await File(file.path).copy(compressPath);
      await CompressImage.compress(imageSrc: compressPath, desiredQuality: 7);

      var nowTime = DateTime.now().toString();
      Photo photo = Photo(file.path, compressPath, nowTime, nowTime);
      db.savePhoto(photo);
    }
  }
}
