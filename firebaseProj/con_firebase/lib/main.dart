import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc.dart';
import 'screens/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: "AIzaSyCuYA9Ly8LvuxjnKkUr4Iv6lhDnWiKruww",
    appId: "1:78752269136:web:dcb00cd5b8c6f8ad53a255",
    messagingSenderId: "78752269136",
    projectId: "si700laurakugel",
    authDomain: "si700laurakugel.firebaseapp.com",
    storageBucket: "si700laurakugel.appspot.com"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MultiBlocProvider(providers: [
          BlocProvider(create: (context) => AuthBloc()),
        ], child: const Wrapper()));
  }
}
