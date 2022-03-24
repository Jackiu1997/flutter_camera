import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_camera/model/photo.dart';

/// 数据库管理模块 DatabaseHelper
///
/// 负责：
///   创建 Photo 数据库
///   存储 Photo 数据
///   更新 Photo 数据
///   删除 Photo 数据
///   获取 Photo 数据等功能
///
class DatabaseHelper {
  // 设置数据库管理单例模式
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  static DatabaseHelper get to => _instance;

  // 设置数据库连接单例模式
  static final String tableName = 'CameraPhotos';
  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initDb();
    }
    return _db;
  }

  /// SQLite 数据库文件创建
  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'camera_photos.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  /// Photo CameraPhotos 数据表表结构创建
  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, srcPath TEXT, thumbPath TEXT, createDate TEXT, modifyDate TEXT)');
  }

  /// 基础数据库功能
  ///
  /// 存储 photo 数据
  Future<int> savePhoto(Photo photo) async {
    var dbClient = await db;
    return await dbClient.insert(tableName, photo.toMap());
  }

  /// 更新 photo 数据
  Future<int> updatePhoto(Photo photo) async {
    var dbClient = await db;
    return await dbClient.update(tableName, photo.toMapId(),
        where: "id = ?", whereArgs: [photo.id]);
  }

  ///  按 id 获取 photo 数据
  Future<Photo> getPhoto(int id) async {
    var dbClient = await db;
    List<Map> result =
        await dbClient.rawQuery('SELECT * FROM $tableName WHERE id = $id');
    if (result.length > 0) {
      return Photo.fromMap(result.first);
    }
    return null;
  }

  /// 删除 Photo 数据
  Future<int> deletePhoto(int id) async {
    var dbClient = await db;
    return await dbClient.rawDelete('DELETE FROM $tableName WHERE id = $id');
  }

  /// 关闭数据库
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

  /// 拓展的数据库功能
  ///
  /// 获取所有 Photo 数据 （并按序号反序）
  Future<List<Photo>> getAllPhotos() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableName');
    var photos = <Photo>[];
    for (int i = result.length - 1; i >= 0; i--) {
      photos.add(Photo.fromMap(result[i]));
    }
    return photos;
  }

  /// 检查相片是否在数据库中存储
  Future<bool> isInDatabase(String srcpath) async {
    var dbClient = await db;
    int result = Sqflite.firstIntValue(await dbClient.rawQuery(
        'SELECT count(*) FROM $tableName WHERE srcPath = "$srcpath"'));
    return result > 0;
  }
}
