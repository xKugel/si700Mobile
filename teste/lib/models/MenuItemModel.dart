class MenuItemModel {
  String? _id = null;
  String _imageURL = "";
  String _name = "";
  double _value = 0;

  MenuItemModel.create({imageURL = '', description = '', value = 0}) {
    _id = null;
    _imageURL = imageURL;
    _name = description;
    _value = value / 100;
  }

  MenuItemModel() {
    _id = null;
    _imageURL = "";
    _name = "";
    _value = 0;
  }

  MenuItemModel.withData(
      {id = 0, imageURL = "", name = "", value = 0, active = 0}) {
    _id = id;
    _imageURL = imageURL;
    _name = name;
    _value = double.parse(value.toString());
  }

  MenuItemModel.fromMap(map) {
    _id = map['id'];
    _imageURL = map['img_url'];
    _name = map['name'];
    _value = map['value'] / 100;
  }

  MenuItemModel.fromDoc(ref, map) {
    _id = ref;
    _imageURL = map['img_url'];
    _name = map['name'];
    _value = map['value'] / 100;
  }

  String? get id => _id;
  String get imageURL => _imageURL;
  String get name => _name;
  double get value => _value;

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

  toMap() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['img_url'] = _imageURL;
    map['name'] = _name;
    map['value'] = (_value * 100).round();
    return map;
  }
}
