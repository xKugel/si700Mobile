import 'package:flutter/services.dart';

class Note {
  String _title = "";
  String _description = "";
  String _path = "";
  Uint8List? _img;

  Note() {
    _title = "";
    _description = "";
    _path = "";
  }

  Note.withData({title = "", description = "", path = ""}) {
    _title = title;
    _description = description;
    _path = path;
  }

  Note.fromMap(map) {
    _title = map["title"];
    _description = map["description"];
    _path = map["path"].toString();
  }

  String get title => _title;

  Uint8List? get img => _img;
  String get path => _path;
  String get description => _description;

  set path(String path) {
    _path = path;
  }

  set img(Uint8List? img) {
    _img = img;
  }

  set title(String newTitle) {
    if (newTitle.isNotEmpty) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.isNotEmpty) {
      _description = newDescription;
    }
  }

  toMap() {
    var map = <String, dynamic>{};
    map["title"] = _title;
    map["description"] = _description;
    map["path"] = _path;
    return map;
  }
}
