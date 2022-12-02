import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:teste/models/MenuItemModel.dart';
import 'package:teste/models/MenuItensModel.dart';
import 'package:teste/models/MenuOrdersModel.dart';
import 'package:teste/models/OrderItemModel.dart';
import 'package:teste/models/OrderModel.dart';

class FirestoreDatabase {
  // Atributo que irá afunilar todas as consultas
  static FirestoreDatabase helper = FirestoreDatabase._createInstance();
  // Construtor privado
  FirestoreDatabase._createInstance();

  // Ponto de acesso com o servidor
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Campos comuns
  String colId = "id"; // Autoenumerar
  String colCreatedAt = 'created_at'; // Now() no insert
  String colUpdatedAt = 'updated_at'; // Now() no update

  // Itens
  String itemTable = "itens";
  String itemValor = "value";
  String itemNome = "name";
  String itemAtivo = "active";
  String itemImagemUrl = "img_url";

  // Pedidos
  String pedidoTable = 'orders';
  String pedidoMesa = 'table_number';
  String pedidoStatus = 'status'; // A -> aberto, C -> Cancelado, F -> Fechado

  // Itens de Pedido
  String itemPedidoTable = 'rel_order_item';
  String itemPedidoPedido = 'id_pedido';
  String itemPedidoItem = 'id_item';
  String itemPedidoQuantidade = 'quantity';

  Future<OrderModel> findOrCreateOrder(OrderModel order) async {
    QuerySnapshot doc = await firestore
        .collection(pedidoTable)
        .where(pedidoMesa, isEqualTo: order.tableNumber)
        .where(pedidoStatus, isEqualTo: "A")
        .limit(1)
        .get();

    if (doc.docs.isNotEmpty) {
      OrderModel pedido =
          OrderModel.fromDoc(doc.docs[0].id, doc.docs[0].data(), []);
      List<OrderItemModel> existingItens =
          await findOrderItensByOrderId(pedido.id);
      for (int i = 0; i < order.itensList.length; i++) {
        OrderItemModel itemToCreate = order.itensList[i];
        itemToCreate.order = pedido;
        OrderItemModel itemThatExists = existingItens.firstWhere(
            (e) => e.item.name == itemToCreate.item.name,
            orElse: () => OrderItemModel());
        itemToCreate.quantity = itemThatExists.quantity + itemToCreate.quantity;
        itemToCreate.id = itemThatExists.id;
        await insertOrderItem(itemToCreate);
      }
      pedido.itensList = await findOrderItensByOrderId(pedido.id);
      return pedido;
    }
    DocumentReference ref =
        await firestore.collection(pedidoTable).add(order.toMap());
    await ref.update({"id": ref.id});
    DocumentSnapshot created = await ref.get();

    OrderModel createdOrder = await findOrCreateOrder(
        OrderModel.fromDoc(created.id, created.data(), []));
    for (int i = 0; i < order.itensList.length; i++) {
      OrderItemModel itemToCreate = order.itensList[i];
      itemToCreate.order = order;
      await insertOrderItem(itemToCreate);
    }
    createdOrder.itensList = await findOrderItensByOrderId(createdOrder.id);
    return createdOrder;
  }

  Future<List<OrderItemModel>> findOrderItensByOrderId(String? orderId) async {
    QuerySnapshot doc = await firestore
        .collection(itemPedidoTable)
        .where(itemPedidoPedido, isEqualTo: orderId)
        .get();
    List<OrderItemModel> list = [];
    if (doc != null && doc.docs.isNotEmpty) {
      for (int i = 0; i < doc.docs.length; i++) {
        dynamic obj = doc.docs[i].data();
        DocumentSnapshot itemSnap = await firestore
            .collection(itemTable)
            .doc(obj[itemPedidoItem])
            .get();

        DocumentSnapshot orderSnap = await firestore
            .collection(pedidoTable)
            .doc(obj[itemPedidoPedido])
            .get();

        list.add(OrderItemModel.fromDoc(doc.docs[i].id, doc.docs[i].data(),
            itemSnap.data(), orderSnap.data()));
      }
      return list;
    } else {
      return list;
    }
  }

  Future<int> insertOrderItem(OrderItemModel item) async {
    if (item == null) {
      return 0;
    }
    DocumentReference doc =
        await firestore.collection(itemPedidoTable).doc(item.id);
    await doc.set(item.toMap(), SetOptions(merge: true));
    await doc.update({"id": doc.id});
    return 0;
  }

  Future<MenuItensModel> getItemList() async {
    QuerySnapshot snap = await firestore.collection(itemTable).get();

    MenuItensModel menuItensModel = MenuItensModel();
    for (int i = 0; i < snap.docs.length; i++) {
      MenuItemModel menuItem =
          MenuItemModel.fromDoc(snap.docs[i].id, snap.docs[i].data());
      menuItensModel.insertMenuItemModelOfId(snap.docs[i].id, menuItem);
    }
    return menuItensModel;
  }

  Future<MenuOrdersModel> getOrdersList() async {
    QuerySnapshot snap = await firestore
        .collection(pedidoTable)
        .where(pedidoMesa, isNotEqualTo: 0)
        .get();
    MenuOrdersModel orderModel = MenuOrdersModel();
    for (int i = 0; i < snap.docs.length; i++) {
      String id = snap.docs[i].id;
      List<OrderItemModel> itens = await findOrderItensByOrderId(id);
      OrderModel order = OrderModel.fromDoc(id, snap.docs[i].data(), itens);
      orderModel.insertOrderModelOfId(id, order);
    }
    return orderModel;
  }

  Future<void> closeOrderByTable(int table) async {
    QuerySnapshot snap = await firestore
        .collection(pedidoTable)
        .where(pedidoMesa, isEqualTo: table)
        .where(pedidoStatus, isEqualTo: 'A')
        .get();
    await snap.docs[0].reference.update({'$pedidoStatus': 'F'});
  }
}
