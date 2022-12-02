import 'package:teste/models/OrderModel.dart';

class MenuOrdersModel {
  List<String> idList = [];
  List<OrderModel> menuItensList = [];

  OrderModelCollection() {
    idList = [];
    menuItensList = [];
  }

  int length() {
    return idList.length;
  }

  OrderModel getNodeAtIndex(int index) {
    OrderModel menuItem = menuItensList[index];
    return OrderModel.withData(
        id: menuItem.id,
        itensList: menuItem.itensList,
        status: menuItem.status,
        tableNumber: menuItem.tableNumber);
  }

  String getIdAtIndex(int index) {
    return idList[index];
  }

  int getIndexOfId(String id) {
    for (int i = 0; i < idList.length; i++) {
      if (id == idList[i]) {
        return i;
      }
    }

    return -1;
  }

  updateOrInsertOrderModelOfId(String id, OrderModel menuItem) {
    int index = getIndexOfId(id);
    if (index != -1) {
      menuItensList[index] = OrderModel.withData(
          id: menuItem.id,
          itensList: menuItem.itensList,
          status: menuItem.status,
          tableNumber: menuItem.tableNumber);
    } else {
      idList.add(id);
      menuItensList.add(
        OrderModel.withData(
            id: menuItem.id,
            itensList: menuItem.itensList,
            status: menuItem.status,
            tableNumber: menuItem.tableNumber),
      );
    }
  }

  updateOrderModelOfId(String id, OrderModel menuItem) {
    int index = getIndexOfId(id);
    if (index != -1) {
      menuItensList[index] = OrderModel.withData(
          id: menuItem.id,
          itensList: menuItem.itensList,
          status: menuItem.status,
          tableNumber: menuItem.tableNumber);
    }
  }

  deleteOrderModelOfId(String id) {
    int index = getIndexOfId(id);
    if (index != -1) {
      menuItensList.removeAt(index);
      idList.removeAt(index);
    }
  }

  insertOrderModelOfId(String id, OrderModel menuItem) {
    idList.add(id);
    menuItensList.add(
      OrderModel.withData(
          id: menuItem.id,
          itensList: menuItem.itensList,
          status: menuItem.status,
          tableNumber: menuItem.tableNumber),
    );
  }
}
