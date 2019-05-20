import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_camera/model/photo.dart';
import 'package:flutter_camera/database/database_helper.dart';

Future createPhotoData(String srcPath) async {
  var db = DatabaseHelper();

  var extDir = await getApplicationDocumentsDirectory();
  var compressDir = await Directory('${extDir.path}/Thumbnail/').create();
  var compressPath = compressDir.path + srcPath.split('/').last;
  FlutterImageCompress.compressAndGetFile(srcPath, compressPath, quality: 10);
  var nowTime = DateTime.now().toString();
  Photo photo = Photo(srcPath, compressPath, nowTime, nowTime);
  db.savePhoto(photo);
}

Future updatePhotoData(Photo photo) async {
  var db = DatabaseHelper();

  FlutterImageCompress.compressAndGetFile(photo.srcPath, photo.thumbPath, quality: 10);
  photo.modifyDate = DateTime.now().toString();
  db.updatePhoto(photo);
}

Future checkNotInDBPhotos() async {
  var db = DatabaseHelper();

  var extDir = await getApplicationDocumentsDirectory();
  var srcFiles = Directory('${extDir.path}/Pictures').listSync();
  for (var file in srcFiles) {
    if (!await db.isInDatabase(file.path)) {
      var compressDir = await Directory('${extDir.path}/Thumbnail/').create();
      var compressPath = compressDir.path + file.path.split('/').last;
      FlutterImageCompress.compressAndGetFile(file.path, compressPath, quality: 10);
      var nowTime = DateTime.now().toString();
      Photo photo = Photo(file.path, compressPath, nowTime, nowTime);
      db.savePhoto(photo);
    }
  }
}
