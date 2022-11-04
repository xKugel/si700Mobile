import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste/models/MenuItensModel.dart';

import '../provider/local_database.dart';

class MonitorItemBloc extends Bloc<MonitorEvent, MonitorItemState> {
  MenuItensModel itensCollection = MenuItensModel();

  MonitorItemBloc()
      : super(MonitorItemState(itensCollection: MenuItensModel())) {
    on<AskNewList>((event, emit) async {
      itensCollection = await LocalDatabase.helper.getItemList();
      emit(MonitorItemState(itensCollection: itensCollection));
    });

    on<UpdateList>((event, emit) {
      emit(MonitorItemState(itensCollection: itensCollection));
    });
    add(AskNewList());
  }
}

/*
Eventos
*/
abstract class MonitorEvent {}

class AskNewList extends MonitorEvent {}

class UpdateList extends MonitorEvent {}

/*
Estados
*/
class MonitorItemState {
  MenuItensModel itensCollection;
  MonitorItemState({required this.itensCollection});
}
