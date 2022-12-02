import 'package:teste/models/MenuItemModel.dart';
import 'package:teste/models/OrderModel.dart';

class OrderItemModel {
  String? _id;
  MenuItemModel _item = MenuItemModel();
  OrderModel _order = OrderModel();
  int _quantity = 0;

  OrderItemModel() {
    _order = OrderModel();
    _item = MenuItemModel();
    _quantity = 0;
  }

  OrderItemModel.withData({id, item, order, quantity = 0}) {
    _id = id;
    _item = item;
    _quantity = quantity;
    _order = order ?? _order;
  }

  OrderItemModel.fromMap(map) {
    _id = map['id'];
    _quantity = map['quantity'];
    _item = MenuItemModel.withData(
        active: map['itensactive'],
        id: map['itensid'],
        name: map['itensname'],
        value: ((map['itensvalue']) / 100).toString(),
        imageURL: map['itensimage_url']);
    _order = OrderModel.withData(
        id: map['ordersid'],
        tableNumber: map['orderstable_number'],
        status: map['ordersstatus'],
        itensList: []);
  }

  OrderItemModel.fromDoc(ref, map, item, order) {
    _id = ref;
    _quantity = map['quantity'];
    _item = MenuItemModel.fromDoc(item['id'], item);
    _order = OrderModel.fromDoc(order["id"], order, []);
  }

  MenuItemModel get item => _item;
  OrderModel get order => _order;
  int get quantity => _quantity;
  String? get id => _id;

  set item(MenuItemModel item) {
    _item = item;
  }

  set order(OrderModel order) {
    _order = order;
  }

  set quantity(int quantity) {
    _quantity = quantity;
  }

  set id(String? id) {
    _id = id;
  }

  toMap() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['quantity'] = _quantity;
    map['id_pedido'] = _order.id;
    map['id_item'] = _item.id;

    return map;
  }

  toMapSemId() {
    var map = <String, dynamic>{};
    map['quantity'] = _quantity;
    map['id_pedido'] = _order.id;
    map['id_item'] = _item.id;

    return map;
  }
}
