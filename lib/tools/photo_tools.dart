import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:image_compression/image_compression.dart';
import 'package:flutter_camera/model/photo.dart';
import 'package:flutter_camera/database/database_helper.dart';

/// 压缩原始图像，生成缩略图
void compressPhoto(String srcPath, String compressPath) {
  final input = ImageFile(
    rawBytes: File(srcPath).readAsBytesSync(),
    filePath: srcPath,
  );
  final output = compress(ImageFileConfiguration(input: input));
  File(compressPath).writeAsBytesSync(output.rawBytes);
}

/// 创建 Photo 数据并存入数据库，缩略图创建
Future createPhotoData(String srcPath) async {
  // 寻找存储文件夹
  var extDir = await getApplicationDocumentsDirectory();
  var compressDir = await Directory('${extDir.path}/Thumbnail/').create();
  var compressPath = compressDir.path + srcPath.split('/').last;

  compressPhoto(srcPath, compressPath);

  // Photo 数据加入数据库
  var nowTime = DateTime.now().toString();
  Photo photo = Photo(srcPath, compressPath, nowTime, nowTime);
  DatabaseHelper.to.savePhoto(photo);
}

/// 更新 Photo 数据并存入数据库，缩略图更新
Future updatePhotoData(Photo photo) async {
  compressPhoto(photo.srcPath, photo.thumbPath);

  photo.modifyDate = DateTime.now().toString();
  DatabaseHelper.to.updatePhoto(photo);
}

/// 删除 Photo 数据，源文件，缩略图等信息
Future deletePhotoData(Photo photo) async {
  File(photo.srcPath).deleteSync();
  File(photo.thumbPath).deleteSync();
  DatabaseHelper.to.deletePhoto(photo.id);
}

/// 检查未加入数据库的异常照片并将创建 Photo 数据和缩略图 加入数据库
Future checkNotInDBPhotos() async {
  var extDir = await getApplicationDocumentsDirectory();
  var srcDir = await Directory('${extDir.path}/Pictures').create();
  var srcFiles = srcDir.listSync();

  for (var file in srcFiles) {
    if (!await DatabaseHelper.to.isInDatabase(file.path)) {
      var compressDir = await Directory('${extDir.path}/Thumbnail/').create();
      var compressPath = compressDir.path + file.path.split('/').last;

      compressPhoto(file.path, compressPath);

      var nowTime = DateTime.now().toString();
      Photo photo = Photo(file.path, compressPath, nowTime, nowTime);
      DatabaseHelper.to.savePhoto(photo);
    }
  }
}
