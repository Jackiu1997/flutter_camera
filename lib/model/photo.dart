/// Photo 相片数据模型
///
class Photo {
  /// Photo 私有数据成员
  ///
  /// 唯一标识号
  int _id;

  ///   相片名
  String _name;

  ///   原图片路径
  String _srcPath;

  ///   缩略图路径
  String _thumbPath;

  ///   创建时间
  String _createDate;

  ///   修改时间
  String _modifyDate;

  /// get set
  ///
  /// 私有数据 get
  int get id => _id;
  String get name => _name;
  String get srcPath => _srcPath;
  String get thumbPath => _thumbPath;
  String get createDate => _createDate;
  String get modifyDate => _modifyDate;

  /// modifyDate set
  set modifyDate(String date) {
    _modifyDate = date;
  }

  /// Photo 构造函数
  Photo(this._srcPath, this._thumbPath, this._createDate, this._modifyDate) {
    // _name 按 path 自动构建
    _name = _srcPath.split('/').last;
  }

  Photo.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._srcPath = obj['srcPath'];
    this._thumbPath = obj['thumbPath'];
    this._createDate = obj['createDate'];
    this._modifyDate = obj['modifyDate'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['name'] = _name;
    map['srcPath'] = _srcPath;
    map['thumbPath'] = _thumbPath;
    map['createDate'] = _createDate;
    map['modifyDate'] = _modifyDate;
    return map;
  }

  Map<String, dynamic> toMapId() {
    var map = new Map<String, dynamic>();
    map['id'] = _id;
    map['name'] = _name;
    map['srcPath'] = _srcPath;
    map['thumbPath'] = _thumbPath;
    map['createDate'] = _createDate;
    map['modifyDate'] = _modifyDate;
    return map;
  }

  Photo.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._srcPath = map['srcPath'];
    this._thumbPath = map['thumbPath'];
    this._createDate = map['createDate'];
    this._modifyDate = map['modifyDate'];
  }
}
