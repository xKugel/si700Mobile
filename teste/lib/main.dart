import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste/bloc/manage_bloc.dart';
import 'package:teste/provider/local_database.dart';
import 'package:teste/screens/MenuScreen.dart';
import 'package:teste/screens/OrderScreen.dart';
import 'package:teste/screens/PaymentScreen.dart';
import 'package:teste/data/data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'GarçonApp';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garçonapp'),
        actions: [
          new IconButton(
              onPressed: () {
                scanQRCode();
              },
              icon: Icon(Icons.qr_code)),
          new IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Garçom a caminho da mesa ${table.number}"),
                  ),
                );
              },
              icon: Icon(Icons.notifications_active)),
        ],
      ),
      body: MultiBlocProvider(
        providers: [BlocProvider(create: (_) => ManageBloc())],
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
    );
  }

  void scanQRCode() async {
    try {
      final result = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', "Cancelar", true, ScanMode.QR);

      if (int.parse(result) != -1) {
        table.number = int.parse(result);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("Mesa atribuída: ${table.number}"),
          ),
        );
      }
    } on PlatformException {
      print("Qr code falhou");
    }
  }
}
