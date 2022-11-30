import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste/bloc/cart_bloc.dart';
import 'package:teste/bloc/monitor_item_bloc.dart';
import 'package:teste/bloc/monitor_order_bloc.dart';
import 'package:teste/components/HomeAppBar.dart';
import 'package:teste/provider/local_database.dart';
import 'package:teste/screens/MenuScreen.dart';
import 'package:teste/screens/OrderScreen.dart';
import 'package:teste/screens/PaymentScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDF9F0F2w5GsUL2Pxw2y7uJ0EQ611TCBkU",
          authDomain: "garconapp-e2991.firebaseapp.com",
          projectId: "garconapp-e2991",
          storageBucket: "garconapp-e2991.appspot.com",
          messagingSenderId: "870452793362",
          appId: "1:870452793362:web:12a1a5225ffadb3de348cb"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'GarçonApp';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    MenuScreen(),
    OrderScreen(),
    PaymentScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MonitorOrderBloc()),
        BlocProvider(create: (_) => CartBloc()),
      ],
      child: Scaffold(
        appBar: HomeAppBar(),
        body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => MonitorItemBloc()),
          ],
          child: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.fastfood),
              label: 'Cardápio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task),
              label: 'Pedido',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payment),
              label: 'Pagamento',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
