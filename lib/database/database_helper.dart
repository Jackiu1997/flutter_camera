import 'dart:async';
 
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_camera/model/photo.dart';
 
class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  final String tableName = 'CameraPhotos';
  static Database _db;
 
  DatabaseHelper.internal();
 
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
 
  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'camera_photos.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
 
  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, srcPath TEXT, thumbPath TEXT, createDate TEXT, modifyDate TEXT)');
  }
 
  // Basic database function
  Future<int> savePhoto(Photo photo) async {
    var dbClient = await db;
    return await dbClient.insert(tableName, photo.toMap());
  }

  Future<int> updatePhoto(Photo photo) async {
    var dbClient = await db;
    return await dbClient.update(tableName, photo.toMapId(), where: "id = ?", whereArgs: [photo.id]);
  }
 
  Future<Photo> getPhoto(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.rawQuery('SELECT * FROM $tableName WHERE id = $id');
    if (result.length > 0) {
      return Photo.fromMap(result.first);
    }
    return null;
  }

  Future<int> deletePhoto(int id) async {
    var dbClient = await db;
    return await dbClient.rawDelete('DELETE FROM $tableName WHERE id = $id');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

  // Impliment database function
  Future<int> getPhotoCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }
  
  Future<List<Photo>> getAllPhotos() async {
    var dbClient = await db;
    List<Map> result = await dbClient.rawQuery('SELECT * FROM $tableName');
    List<Photo> photos = List<Photo>();
    result.forEach((f) {
      photos.add(Photo.fromMap(f));
    });
    return photos;
  }

  Future<bool> isInDatabase(String srcpath) async {
    var dbClient = await db;
    int result = Sqflite.firstIntValue(await dbClient.rawQuery('SELECT count(*) FROM $tableName WHERE srcPath = "$srcpath"'));
    return result > 0;
  }
}