import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste/bloc/cart_bloc.dart';
import 'package:teste/bloc/monitor_order_bloc.dart';

Future<int> scanQRCode(context, currentTableNumber) async {
  try {
    final result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', "Cancelar", true, ScanMode.QR);

    int tableNumber = int.parse(result);
    if (tableNumber != -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text("Mesa atribuída: ${tableNumber}"),
        ),
      );
      return tableNumber;
    }
  } on PlatformException {
    print("Qr code falhou");
    return currentTableNumber;
  }
  return currentTableNumber;
}

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
    return PreferredSize(
        child: AppBar(
          title: const Text('Garçonapp'),
          actions: [
            new IconButton(
                onPressed: () async {
                  int tbN = await scanQRCode(context, cartBloc.tableNumber);
                  cartBloc.add(SetCartTableEvent(tableNumber: tbN));
                  BlocProvider.of<MonitorOrderBloc>(context)
                      .add(AskNewOrderList(table: tbN));
                },
                icon: Icon(Icons.qr_code)),
            new IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                          "Garçom a caminho da mesa ${cartBloc.tableNumber}"),
                    ),
                  );
                },
                icon: Icon(Icons.notifications_active)),
          ],
        ),
        preferredSize: Size.fromHeight(72));
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
