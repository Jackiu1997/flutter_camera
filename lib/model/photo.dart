class Photo {
  int _id;
  String _name;
  String _srcPath;
  String _thumbPath;
  String _createDate;
  String _modifyDate;
  
  int get id => _id;
  String get name => _name;
  String get srcPath => _srcPath;
  String get thumbPath => _thumbPath;
  String get createDate => _createDate;
  String get modifyDate => _modifyDate;

  set modifyDate(String date) {
    _modifyDate = date;
  }

  Photo(this._srcPath, this._thumbPath, this._createDate, this._modifyDate) {
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