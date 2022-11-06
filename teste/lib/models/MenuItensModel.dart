import 'package:teste/models/MenuItemModel.dart';

class MenuItensModel {
  List<String> idList = [];
  List<MenuItemModel> menuItensList = [];

  MenuItemModelCollection() {
    idList = [];
    menuItensList = [];
  }

  int length() {
    return idList.length;
  }

  MenuItemModel getNodeAtIndex(int index) {
    MenuItemModel menuItem = menuItensList[index];
    return MenuItemModel.withData(
        id: menuItem.id,
        name: menuItem.name,
        value: menuItem.value,
        active: menuItem.active,
        imageURL: menuItem.imageURL);
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

  updateOrInsertMenuItemModelOfId(String id, MenuItemModel menuItem) {
    int index = getIndexOfId(id);
    if (index != -1) {
      menuItensList[index] = MenuItemModel.withData(
          id: menuItem.id,
          name: menuItem.name,
          value: menuItem.value,
          active: menuItem.active,
          imageURL: menuItem.imageURL);
    } else {
      idList.add(id);
      menuItensList.add(
        MenuItemModel.withData(
            id: menuItem.id,
            name: menuItem.name,
            value: menuItem.value,
            active: menuItem.active,
            imageURL: menuItem.imageURL),
      );
    }
  }

  updateMenuItemModelOfId(String id, MenuItemModel menuItem) {
    int index = getIndexOfId(id);
    if (index != -1) {
      menuItensList[index] = MenuItemModel.withData(
          id: menuItem.id,
          name: menuItem.name,
          value: menuItem.value,
          active: menuItem.active,
          imageURL: menuItem.imageURL);
    }
  }

  deleteMenuItemModelOfId(String id) {
    int index = getIndexOfId(id);
    if (index != -1) {
      menuItensList.removeAt(index);
      idList.removeAt(index);
    }
  }

  insertMenuItemModelOfId(String id, MenuItemModel menuItem) {
    idList.add(id);
    menuItensList.add(
      MenuItemModel.withData(
          id: menuItem.id,
          name: menuItem.name,
          value: menuItem.value,
          active: menuItem.active,
          imageURL: menuItem.imageURL),
    );
  }
}
