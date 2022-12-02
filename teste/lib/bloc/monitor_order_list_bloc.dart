import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste/models/MenuItensModel.dart';
import 'package:teste/models/MenuOrdersModel.dart';
import 'package:teste/provider/firebase_firestore.dart';

import '../provider/local_database.dart';

class MonitorOrderListBloc
    extends Bloc<MonitorOrderListEvent, MonitorOrderListState> {
  MenuOrdersModel itensCollection = MenuOrdersModel();

  MonitorOrderListBloc()
      : super(MonitorOrderListState(itensCollection: MenuOrdersModel())) {
    on<AskNewList>((event, emit) async {
      itensCollection = await FirestoreDatabase.helper.getOrdersList();
      emit(MonitorOrderListState(itensCollection: itensCollection));
    });

    on<UpdateList>((event, emit) {
      emit(MonitorOrderListState(itensCollection: itensCollection));
    });
    add(AskNewList());
  }
}

/*
Eventos
*/
abstract class MonitorOrderListEvent {}

class AskNewList extends MonitorOrderListEvent {}

class UpdateList extends MonitorOrderListEvent {}

/*
Estados
*/
class MonitorOrderListState {
  MenuOrdersModel itensCollection;
  MonitorOrderListState({required this.itensCollection});
}
