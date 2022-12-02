import 'package:teste/models/OrderItemModel.dart';

class OrderModel {
  String? _id;
  int _tableNumber = 0;
  String _status = 'A';
  List<OrderItemModel> _itensList = [];

  OrderModel() {
    int _tableNumber = 0;
    String _status = 'A';
    List<OrderItemModel> _itensList = [];
  }

  OrderModel.withData(
      {id,
      tableNumber = 0,
      status = 'A',
      required List<OrderItemModel> itensList}) {
    _id = id;
    _tableNumber = int.parse(tableNumber.toString());
    _status = status;
    _itensList = itensList ?? [];
  }

  OrderModel.fromMap(map, List<OrderItemModel> itensList) {
    _id = map['id'];
    _tableNumber = int.parse(map['table_number']);
    _status = map['status'];
    _itensList = itensList;
  }

  OrderModel.fromDoc(id, map, List<OrderItemModel> itensList) {
    _id = id.toString();
    _tableNumber = map['table_number'];
    _status = map['status'];
    _itensList = itensList;
  }

  String? get id => _id;
  int get tableNumber => _tableNumber;
  String get status => _status;
  List<OrderItemModel> get itensList => _itensList;

  set id(String? id) {
    _id = id;
  }

  set tableNumber(int tableNumber) {
    _tableNumber = tableNumber;
  }

  set status(String status) {
    _status = status;
  }

  set itensList(List<OrderItemModel> itensList) {
    _itensList = itensList;
  }

  toMap() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['table_number'] = _tableNumber;
    map['status'] = _status;
    return map;
  }
}
