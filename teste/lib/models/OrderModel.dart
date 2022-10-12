import 'package:teste/models/MenuItemModel.dart';

class OrderModel {
  MenuItemModel item;
  int quantity;

  OrderModel({required this.item, required this.quantity});
}