import 'package:flutter_bloc/flutter_bloc.dart';
import '../provider/local_database.dart';

class ManageBloc extends Bloc<ManageEvent, ManageState> {
  ManageBloc() : super(InsertState()) {
    on<UpdateRequest>((event, emit) {
      LocalDatabase.helper;
      emit(UpdateState());
    });

    on<UpdateCancel>((event, emit) {
      LocalDatabase.helper;
      emit(InsertState());
    });

    on<SubmitEvent>((event, emit) {
      if (state is InsertState) {
        //ToDo: Inserir uma chamada de insert
        // .insertNote(event.note);
      } else if (state is UpdateState) {
        //ToDo: Inserir uma chamada de Update
        LocalDatabase.helper;
        // .updateNote((state as UpdateState).noteId, event.note);
        emit(InsertState());
      }
      LocalDatabase.helper.insertNote();
    });
    on<DeleteEvent>((event, emit) {
      // ToDo: Inserir uma chamada de Delete

      LocalDatabase.helper;
      //.deleteNote(event.noteId);
    });
  }
}

/*
  Eventos
*/
abstract class ManageEvent {}

class SubmitEvent extends ManageEvent {
  SubmitEvent();
}

class DeleteEvent extends ManageEvent {
  DeleteEvent();
}

class UpdateRequest extends ManageEvent {
  UpdateRequest();
}

class UpdateCancel extends ManageEvent {}

/*
Estados
*/

abstract class ManageState {}

class InsertState extends ManageState {}

class UpdateState extends ManageState {
  UpdateState();
}
