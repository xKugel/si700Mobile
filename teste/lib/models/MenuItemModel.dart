class MenuItemModel {
  int _id = 0;
  String _imageURL = "";
  String _name = "";
  double _value = 0;
  int _active = 0;

  MenuItemModel.create({imageURL = '', description = '', value = 0}) {
    _id = 0;
    _imageURL = imageURL;
    _name = description;
    _value = value / 100;
    _active = 1;
  }

  MenuItemModel() {
    _id = 0;
    _imageURL = "";
    _name = "";
    _value = 0;
    _active = 0;
  }

  MenuItemModel.withData(
      {id = 0, imageURL = "", name = "", value = 0, active = 0}) {
    _id = id;
    _imageURL = imageURL;
    _name = name;
    _value = double.parse(value.toString());
    _active = active;
  }

  MenuItemModel.fromMap(map) {
    _id = map['id'];
    _imageURL = map['image_url'];
    _name = map['name'];
    _value = map['value'] / 100;
    _active = map['active'];
  }

  int get id => _id;
  String get imageURL => _imageURL;
  String get name => _name;
  double get value => _value;
  int get active => _active;

  set imageURL(String new_imageURL) {
    if (new_imageURL.isNotEmpty) {
      _imageURL = new_imageURL;
    }
  }

  set name(String new_name) {
    if (new_name.isNotEmpty) {
      _name = new_name;
    }
  }

  set value(num new_value) {
    _value = double.parse(new_value.toString());
  }

  set active(int new_active) {
    _active = new_active;
  }

  toMap() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['image_url'] = _imageURL;
    map['name'] = _name;
    map['value'] = (_value * 100).round();
    map['active'] = _active;
    return map;
  }
}
