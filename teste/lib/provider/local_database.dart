// Data Provider para o banco de dados local sqflite

import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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
  String pedidoMesa = 'table';
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
    print(path);
    return openDatabase(path, version: 1, onCreate: _createDb);
  }

  _createDb(Database db, int newVersion) {
    if (true) {
      db.execute("""
       CREATE TABLE $itemTable (
           $colId INTEGER PRIMARY KEY AUTOINCREMENT,
           $colCreatedAt DATE NOT NULL DEFAULT date('now'),
           $colUpdatedAt created_at DATE DEFAULT date('now'),
           $itemValor INTEGER NOT NULL DEFAULT 0,
           $itemNome TEXT NOT NULL,
           $itemAtivo INTEGER DEFAULT 1,
           $itemImagemUrl TEXT
          );
    """);

      db.execute("""
       CREATE TABLE $pedidoTable (
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colCreatedAt DATE NOT NULL DEFAULT date('now'),
          $colUpdatedAt created_at DATE DEFAULT date('now'),
          $pedidoMesa TEXT NOT NULL,
          $pedidoStatus TEXT CHECK( $pedidoStatus IN ('A','C','F') )   NOT NULL DEFAULT 'A',
          $itemAtivo INTEGER DEFAULT 1,
          $itemImagemUrl TEXT
          );
    """);

      db.execute("""
       CREATE TABLE $itemPedidoTable (
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colCreatedAt DATE NOT NULL DEFAULT date('now'),
          $colUpdatedAt created_at DATE DEFAULT date('now'),
          $itemPedidoQuantidade INTEGER NOT NULL DEFAULT 0,
          $pedidoStatus TEXT CHECK( $pedidoStatus IN ('A','C','F') )   NOT NULL DEFAULT 'A',
          $itemAtivo INTEGER DEFAULT 1,
          $itemImagemUrl TEXT
          );
    """);

      db.execute("""
        CREATE TABLE $itemPedidoTable (
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colCreatedAt DATE NOT NULL DEFAULT date('now'),
          $colUpdatedAt created_at DATE DEFAULT date('now'),
          $itemPedidoItem INTEGER,
          $itemPedidoPedido INTEGER,
          FOREIGN KEY($itemPedidoItem) REFERENCES $itemTable($colId),
          FOREIGN KEY($itemPedidoPedido) REFERENCES $pedidoTable($colId)
        );;
      """);
    }
  }

  Future<int> insertNote() async {
    Database? db = await database;
    //  int result = await db.insert();
    //notify();
    //  notify(result.toString(), note);
    print("TEstando");
    return 1;
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

  // Future<NoteCollection> getNoteList() async {
  //   Database db = await database;
  //   List<Map<String, Object?>> noteMapList =
  //       await db.rawQuery("SELECT * FROM $noteTable;");
  //   NoteCollection noteCollection = NoteCollection();

  //   for (int i = 0; i < noteMapList.length; i++) {
  //     Note note = Note.fromMap(noteMapList[i]);

  //     noteCollection.insertNoteOfId(noteMapList[i][colId].toString(), note);
  //   }
  //   return noteCollection;
  // } /*  */

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
