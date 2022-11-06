import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste/bloc/cart_bloc.dart';
import 'package:teste/bloc/monitor_order_bloc.dart';
import 'package:teste/models/TableModel.dart';
import 'package:teste/models/OrderItemModel.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  final dropPaymentValue = ValueNotifier("");
  final dropPaymentOptions = ["Dinheiro", "Cartão", "Pix"];
  late CartBloc cartBloc;

  Widget build(BuildContext context) {
    cartBloc = BlocProvider.of<CartBloc>(context);
    int tableNumber = cartBloc.tableNumber;
    BlocProvider.of<MonitorOrderBloc>(context)
        .add(AskNewOrderList(table: tableNumber));
    return BlocBuilder<MonitorOrderBloc, MonitorOrderState>(
        builder: (context, state) => Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: state.itensCollection.length,
                        itemBuilder: ((context, index) {
                          return _buildOrderItem(state.itensCollection[index]);
                        }))),
                SizedBox(
                  height: 20,
                ),
                Text("Total: ${_getTotal(state.itensCollection)}",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
                      if (state.itensCollection.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.yellow,
                            content: Text("Seu pedido está vazio"),
                          ),
                        );
                        return;
                      }
                      if (dropPaymentValue.value.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.yellow,
                            content: Text("Selecione um método de pagamento"),
                          ),
                        );
                        return;
                      }
                      BlocProvider.of<MonitorOrderBloc>(context)
                          .add(CloseOrder(table: tableNumber));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                              "Garçom a caminho da mesa ${tableNumber} para receber o pagamento. Método de pagamento selecionado: ${dropPaymentValue.value}. Obrigado pela preferência"),
                        ),
                      );
                      cartBloc.add(ResetCart());
                    },
                    child: Text("Realizar pagamento",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600))),
                SizedBox(
                  height: 80,
                )
              ],
            ));
  }
}

double _getTotal(List<OrderItemModel> orders) {
  double total = 0;

  for (var i = 0; i < orders.length; i++) {
    total += (orders[i].item.value * orders[i].quantity);
  }

  return total;
}

Widget _buildOrderItem(OrderItemModel order) {
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
                    "Item: ${order.item.name}",
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
