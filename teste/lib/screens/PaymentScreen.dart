import 'package:flutter/material.dart';
import 'package:teste/data/data.dart';
import 'package:teste/models/TableModel.dart';
import 'package:teste/models/OrderModel.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  final dropPaymentValue = ValueNotifier("");
  final dropPaymentOptions = ["Dinheiro", "Cartão", "Pix"];

  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Expanded(
            child: ListView.builder(
                itemCount: table.orders.length,
                itemBuilder: ((context, index) {
                  return _buildOrderItem(table.orders[index]);
                }))),
        SizedBox(
          height: 20,
        ),
        Text("Total: ${_getTotal(table.orders)}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        Center(
          child: ValueListenableBuilder(
              valueListenable: dropPaymentValue,
              builder: (BuildContext context, String value, _) {
                return DropdownButton(
                  hint: const Text("Selecione o meio de pagamento"),
                  value: (value.isEmpty) ? null : value,
                  onChanged: (value) =>
                      dropPaymentValue.value = value.toString(),
                  items: dropPaymentOptions
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                );
              }),
        ),
        ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(
                      "Garçom a caminho da mesa ${table.number} para receber o pagamento. Método de pagamento selecionado: ${dropPaymentValue.value}"),
                ),
              );
            },
            child: Text("Realizar pagamento",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
        SizedBox(
          height: 80,
        )
      ],
    );
  }
}

double _getTotal(List<OrderModel> orders) {
  double total = 0;

  for (var i = 0; i < orders.length; i++) {
    total += (orders[i].item.value * orders[i].quantity);
  }

  return total;
}

Widget _buildOrderItem(OrderModel order) {
  return Center(
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(10),
          color: Color.fromARGB(50, 0, 0, 0),
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Item: ${order.item.description}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Valor Unidade: R\$${order.item.value}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Quantidade: ${order.quantity}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Total: R\S${order.quantity * order.item.value}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
