import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste/models/MenuItensModel.dart';
import 'package:teste/models/OrderItemModel.dart';
import 'package:teste/models/OrderModel.dart';

import '../provider/local_database.dart';

class MonitorOrderBloc extends Bloc<MonitorOrderEvent, MonitorOrderState> {
  List<OrderItemModel> itensCollection = [];

  MonitorOrderBloc() : super(MonitorOrderState(itensCollection: [])) {
    on<AskNewOrderList>((event, emit) async {
      OrderModel order = await LocalDatabase.helper.findOrCreateOrder(
          OrderModel.withData(tableNumber: event.table, itensList: []));
      itensCollection =
          await LocalDatabase.helper.findOrderItensByOrderId(order.id);
      emit(MonitorOrderState(itensCollection: itensCollection));
    });

    on<UpdateOrderList>((event, emit) {
      emit(MonitorOrderState(itensCollection: itensCollection));
    });

    on<CloseOrder>((event, emit) async {
      await LocalDatabase.helper.closeOrderByTable(event.table);
      itensCollection = [];
      emit(MonitorOrderState(itensCollection: itensCollection));
    });
  }
}

/*
Eventos
*/
abstract class MonitorOrderEvent {}

class AskNewOrderList extends MonitorOrderEvent {
  int table;
  AskNewOrderList({required this.table});
}

class UpdateOrderList extends MonitorOrderEvent {}

class CloseOrder extends MonitorOrderEvent {
  int table;
  CloseOrder({required this.table});
}

/*
Estados
*/
class MonitorOrderState {
  List<OrderItemModel> itensCollection;
  MonitorOrderState({required this.itensCollection});
}
