import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste/models/MenuItemModel.dart';
import 'package:teste/models/OrderItemModel.dart';
import 'package:teste/models/OrderModel.dart';
import 'package:teste/provider/firebase_firestore.dart';
import 'package:teste/provider/local_database.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  int tableNumber = 0;
  List<OrderItemModel> listOrder = [];

  _handleEmit(Function e) {
    if (tableNumber == 0) {
      return e(NoTableCartState());
    }
    if (listOrder.isEmpty) {
      return e(EmptyCartState());
    }
    e(CartInsertState());
  }

  CartBloc() : super(NoTableCartState()) {
    on<InsertCartEvent>((event, emit) {
      int index = listOrder.indexWhere((e) => e.item.id == event.item.id);

      if (index >= 0) {
        listOrder[index] = OrderItemModel.withData(
            item: listOrder[index].item,
            quantity: listOrder[index].quantity + 1);
      } else {
        listOrder.add(OrderItemModel.withData(
            item: event.item, quantity: 1, order: OrderModel()));
      }
      _handleEmit(emit);
    });

    on<RemoveCartEvent>((event, emit) {
      int index = listOrder.indexWhere((e) => e.item.id == event.item.id);
      if (index >= 0) {
        listOrder[index] = OrderItemModel.withData(
            item: listOrder[index].item,
            quantity: listOrder[index].quantity - 1);
      }

      if (listOrder[index].quantity == 0) {
        listOrder.removeAt(index);
      }

      _handleEmit(emit);
    });

    on<SetCartTableEvent>((event, emit) {
      tableNumber = event.tableNumber;
      _handleEmit(emit);
    });

    on<OrderEvent>((event, emit) async {
      if (state is CartInsertState) {
        await FirestoreDatabase.helper.findOrCreateOrder(OrderModel.withData(
            status: 'A', itensList: listOrder, tableNumber: tableNumber));
      }
      listOrder = [];
      _handleEmit(emit);
    });

    on<ResetCart>((event, emit) async {
      tableNumber = 0;
      listOrder = [];
      _handleEmit(emit);
    });
  }
}

/*
  Eventos
*/
abstract class CartEvent {}

class InsertCartEvent extends CartEvent {
  MenuItemModel item;
  InsertCartEvent({required this.item});
}

class RemoveCartEvent extends CartEvent {
  MenuItemModel item;
  RemoveCartEvent({required this.item});
}

class SetCartTableEvent extends CartEvent {
  int tableNumber;
  SetCartTableEvent({required this.tableNumber});
}

class OrderEvent extends CartEvent {
  OrderEvent();
}

class ResetCart extends CartEvent {
  ResetCart();
}

/*
Estados
*/

abstract class CartState {}

class EmptyCartState extends CartState {}

class NoTableCartState extends CartState {}

class CartInsertState extends CartState {}
