import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:path_provider/path_provider.dart';

import '../model/note.dart';
import '../bloc/manage_bloc.dart';

class AddNote extends StatelessWidget {
  AddNote({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey();
  final Note note = Note();
  final ImagePicker _picker = ImagePicker();
  File? _photo;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageBloc, ManageState>(builder: (context, state) {
      Note note;
      if (state is UpdateState) {
        note = state.previousNote;
      } else {
        note = Note();
      }
      return Form(
          key: formKey,
          child: Column(
            children: [
              tituloFormField(note),
              descriptionFormField(note),
              filePickerButton(note, state),
              submitButton(note, context, state),
              cancelButton(note, context, state),
            ],
          ));
    });
  }

  Widget tituloFormField(Note note) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: note.title,
        decoration: InputDecoration(
            labelText: "Título",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: (value) {
          if (value!.isEmpty) {
            return "Adicione algum título";
          }
          return null;
        },
        onSaved: (value) {
          note.title = value!;
        },
      ),
    );
  }

  Widget descriptionFormField(Note note) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: note.description,
        decoration: InputDecoration(
            labelText: "Anotação",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: (value) {
          if (value!.isEmpty) {
            return "Adicione alguma anotação";
          }
          return null;
        },
        onSaved: (value) {
          note.description = value!;
        },
      ),
    );
  }

  Widget submitButton(Note note, BuildContext context, ManageState state) {
    return ElevatedButton(
        child: (state is UpdateState
            ? const Text("Update Data")
            : const Text(
                "Insert Data",
              )),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            BlocProvider.of<ManageBloc>(context).add(SubmitEvent(note: note));

            formKey.currentState!.reset();
          }
        });
  }

  Widget cancelButton(Note note, BuildContext context, ManageState state) {
    return (state is UpdateState
        ? ElevatedButton(
            onPressed: () {
              BlocProvider.of<ManageBloc>(context).add(UpdateCancel());
            },
            child: const Text("Cancel Update"))
        : Container());
  }

  Widget filePickerButton(Note note, ManageState state) {
    return ElevatedButton(
        child: Text("Escolha uma imagem"),
        onPressed: () async {
          final pickedFile =
              await _picker.pickImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            note.img = await pickedFile.readAsBytes();
          }
        });
  }
}
