// Data Provider para o banco de dados local sqflite

import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:teste/models/MenuItemModel.dart';
import 'package:teste/models/MenuItensModel.dart';
import 'package:teste/models/OrderItemModel.dart';
import 'package:teste/models/OrderModel.dart';

// import '../model/notes.dart';
// import '../model/note.dart';

class LocalDatabase {
  // Atributo que irá afunilar todas as consultas
  static LocalDatabase helper = LocalDatabase._createInstance();

  // Construtor privado
  LocalDatabase._createInstance();

  // Objeto do SQFLite para fazer as requisições.
  static Database? _database;

  // Campos comuns
  String colId = "id"; // Autoenumerar
  String colCreatedAt = 'created_at'; // Now() no insert
  String colUpdatedAt = 'updated_at'; // Now() no update

  // Itens
  String itemTable = "itens";
  String itemValor = "value";
  String itemNome = "name";
  String itemAtivo = "active";
  String itemImagemUrl = "image_url";

  // Pedidos
  String pedidoTable = 'orders';
  String pedidoMesa = 'table_number';
  String pedidoStatus = 'status'; // A -> aberto, C -> Cancelado, F -> Fechado

  // Itens de Pedido
  String itemPedidoTable = 'rel_order_item';
  String itemPedidoPedido = 'id_pedido';
  String itemPedidoItem = 'id_item';
  String itemPedidoQuantidade = 'quantity';

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  // Gerar um arquivo e depois aplicar uma função que gera um banco de dados nesse arquivo.
  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = "${directory.path}/database.db";
    return openDatabase(path, version: 1, onCreate: _createDb);
    // await deleteDatabase(path);
    // return database;
  }

  _createDb(Database db, int newVersion) async {
    if (newVersion >= 1) {
      await db.execute("""
       CREATE TABLE $itemTable (
           $colId INTEGER PRIMARY KEY AUTOINCREMENT,
           $colCreatedAt DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
           $colUpdatedAt created_at DATE DEFAULT CURRENT_TIMESTAMP,
           $itemValor INTEGER NOT NULL DEFAULT 0,
           $itemNome TEXT NOT NULL,
           $itemAtivo INTEGER DEFAULT 1,
           $itemImagemUrl TEXT
          );
    """);

      await db.execute("""
         CREATE TABLE $pedidoTable (
            $colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $colCreatedAt DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
            $colUpdatedAt created_at DATE DEFAULT CURRENT_TIMESTAMP,
            $pedidoMesa TEXT NOT NULL,
            $pedidoStatus TEXT CHECK( $pedidoStatus IN ('A','C','F') )   NOT NULL DEFAULT 'A'
            );
      """);

      await db.execute("""
          CREATE TABLE $itemPedidoTable (
            $colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $colCreatedAt DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
            $colUpdatedAt created_at DATE DEFAULT CURRENT_TIMESTAMP,
            $itemPedidoQuantidade INTEGER,
            $itemPedidoItem INTEGER NOT NULL,
            $itemPedidoPedido INTEGER NOT NULL,
            FOREIGN KEY($itemPedidoItem) REFERENCES $itemTable($colId),
            FOREIGN KEY($itemPedidoPedido) REFERENCES $pedidoTable($colId)
          );
        """);

      List<Map> foundItens = await db.rawQuery("select * from $itemTable;");
      if (foundItens.length == 0) {
        await db.execute("""
        INSERT INTO $itemTable (image_url, name ,value) VALUES
            ('https://blog.biglar.com.br/wp-content/uploads/2021/10/typical-brazilian-dish-called-feijoada-made-with-black-beans-pork-sausage.jpg',
            'Feijoada',
            4300),
            ('https://img.itdg.com.br/tdg/images/recipes/000/000/876/324587/324587_original.jpg?mode=crop&width=710&height=400',
            'Lasanha',
            3700),
            ('https://images.aws.nestle.recipes/original/73cfbb5072ff136c81aed2c7c3a7cd65_stogonoff-carne-receitas-nestle.jpg',
            'Strogonoff',
            3500),
            ('https://espetinhodesucesso.com.br/wp-content/uploads/2018/03/espetinho-de-carne-com-bacon-1200x900.jpg',
            'Espetinho',
            1500),
            ('https://receitinhas.com.br/wp-content/uploads/2022/06/cachorro-quente-tradicional-2.jpg',
            'Hot Dog',
            1400),
            ('https://classic.exame.com/wp-content/uploads/2020/05/mafe-studio-LV2p9Utbkbw-unsplash-1.jpg?quality=70&strip=info&w=1024',
            'Hamburguer',
            2000),
            ('https://img.itdg.com.br/tdg/images/blog/uploads/2022/07/5-itens-necessarios-para-se-tornar-um-pizzaiolo-neste-Dia-da-Pizza.jpg?mode=crop&width={:width=%3E150,%20:height=%3E130}',
            'Pizza',
            3000),
            ('https://img.itdg.com.br/tdg/images/recipes/000/080/686/21535/21535_original.jpg?w=1200',
            'Coxinha',
            1000),
            ('https://www.imigrantesbebidas.com.br/bebida/images/products/full/1984-refrigerante-coca-cola-lata-350ml.jpg',
            'Coca Cola',
            800),
            ('https://riomarrecife.com.br/recife/2020/03/guarana-antarctica.jpg',
            'Guarana',
            800);
""");
      }
    }
  }

  Future<OrderModel> findOrCreateOrder(OrderModel order) async {
    Database? db = await database;
    List<Map<String, Object?>> pedidos = await db.rawQuery("""
        SELECT * FROM $pedidoTable WHERE $pedidoMesa = ${order.tableNumber} AND $pedidoStatus = "A" LIMIT 1;""");

    if (pedidos != null && pedidos.isNotEmpty) {
      OrderModel pedido = OrderModel.fromMap(pedidos[0], []);
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
    await db.insert(pedidoTable, order.toMap());

    OrderModel created = await findOrCreateOrder(order);
    for (int i = 0; i < order.itensList.length; i++) {
      OrderItemModel itemToCreate = order.itensList[i];
      itemToCreate.order = order;
      await insertOrderItem(itemToCreate);
    }
    created.itensList = await findOrderItensByOrderId(created.id);
    return created;
  }

  Future<int> insertOrderItem(OrderItemModel item) async {
    if (item == null) {
      return 0;
    }
    Database? db = await database;
    int result = await db.insert(itemPedidoTable, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<List<OrderItemModel>> findOrderItensByOrderId(int? orderId) async {
    Database? db = await database;
    if (orderId == null) {
      return [];
    }
    List<Map<String, Object?>> itensPedido = await db.rawQuery("""SELECT
            $itemPedidoTable.$colId as $colId,
            $itemPedidoTable.$itemPedidoQuantidade as $itemPedidoQuantidade,
            $itemTable.$colId as $itemTable$colId,
            $itemTable.$itemValor as $itemTable$itemValor,
            $itemTable.$itemNome as $itemTable$itemNome,
            $itemTable.$itemAtivo as $itemTable$itemAtivo,
            $itemTable.$itemImagemUrl as $itemTable$itemImagemUrl,
            $pedidoTable.$pedidoMesa as $pedidoTable$pedidoMesa,
            $pedidoTable.$pedidoStatus as $pedidoTable$pedidoStatus,
            $pedidoTable.$colId as $pedidoTable$colId
         FROM $itemPedidoTable as $itemPedidoTable
              LEFT JOIN $itemTable ON $itemTable.id = $itemPedidoTable.$itemPedidoItem
              LEFT JOIN $pedidoTable ON $pedidoTable.id = $itemPedidoTable.$itemPedidoPedido
           WHERE $itemPedidoPedido = ${orderId};""");
    List<OrderItemModel> list = [];

    if (itensPedido.isEmpty) {
      return list;
    }

    for (int i = 0; i < itensPedido.length; i++) {
      list.add(OrderItemModel.fromMap(itensPedido[i]));
    }
    return list;
  }

  Future<void> closeOrderByTable(int table) async {
    Database? db = await database;
    await db.update(
        pedidoTable,
        {
          '$pedidoStatus': 'F',
        },
        where: '$pedidoStatus = ? AND $pedidoMesa = ?',
        whereArgs: ['A', table]);

    // .execute("""
    //   UPDATE $pedidoTable SET $pedidoStatus = "F" WHERE $pedidoMesa = $table AND $pedidoStatus = "A";
    // """);
  }

  // Future<int> updateNote(String noteId, Note note) async {
  //   Database db = await database;
  //   int result = await db.update(noteTable, note.toMap(),
  //       where: "$colId = ?", whereArgs: [noteId]);
  //   notify(noteId, note);
  //   return result;
  // }

  // Future<int> deleteNote(String noteId) async {
  //   Database db = await database;

  //   int result = await db.rawDelete("""
  //       DELETE FROM $noteTable WHERE $colId = $noteId;
  //     """);
  //   notify(noteId, null);
  //   return result;
  // }

  Future<MenuItensModel> getItemList() async {
    Database db = await database;
    List<Map<String, Object?>> noteMapList =
        await db.rawQuery("SELECT * FROM $itemTable;");
    MenuItensModel menuItensModel = MenuItensModel();
    for (int i = 0; i < noteMapList.length; i++) {
      MenuItemModel menuItem = MenuItemModel.fromMap(noteMapList[i]);
      menuItensModel.insertMenuItemModelOfId(
          noteMapList[i][colId].toString(), menuItem);
    }
    return menuItensModel;
  } /*  */

  // /*
  //    Parte da STREAM
  // */
  // notify(String noteId, Note? note) async {
  //   _controller?.sink.add([noteId, note]);
  // }

  // Stream get stream {
  //   _controller ??= StreamController.broadcast();
  //   return _controller!.stream;
  // }

  // dispose() {
  //   if (_controller != null) {
  //     if (!_controller!.hasListener) {
  //       _controller!.close();
  //       _controller = null;
  //     }
  //   }
  // }

  static StreamController? _controller;
}
