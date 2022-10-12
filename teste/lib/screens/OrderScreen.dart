import 'package:flutter/material.dart';
import 'package:teste/data/data.dart';
import 'package:teste/models/OrderModel.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Expanded(
            child: ListView.builder(
                itemCount: order.length,
                itemBuilder: ((context, index) {
                  return _buildOrderItem(order[index]);
                }))),
        ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("Pedido realizado para a mesa ${table.number}"),
                ),
              );
            },
            child: Text("Fazer Pedido",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
        SizedBox(
          height: 80,
        )
      ],
    );
  }
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
