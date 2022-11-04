import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste/bloc/cart_bloc.dart';
import 'package:teste/models/OrderItemModel.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: ((context, state) {
      CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
      return Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cartBloc.listOrder.length,
                  itemBuilder: ((context, index) {
                    return _buildOrderItem(cartBloc.listOrder[index], context);
                  }))),
          _handleStateButton(context, cartBloc, state),
          SizedBox(
            height: 80,
          )
        ],
      );
    }));
  }
}

Widget _handleStateButton(context, cartBloc, state) {
  if (state is EmptyCartState || state is NoTableCartState) {
    return Container(
      margin: EdgeInsets.all(10),
      color: Color.fromARGB(50, 0, 0, 0),
      height: 80,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 20),
            Text(
              state is NoTableCartState
                  ? "Não há uma mesa, leia o QRCode da mesa"
                  : "O carrinho do Pedido está vazio",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ]),
    );
  }
  return ElevatedButton(
    onPressed: () async {
      BlocProvider.of<CartBloc>(context).add(await OrderEvent());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text("Pedido realizado para a mesa ${cartBloc.tableNumber}"),
        ),
      );
    },
    child: Text("Fazer Pedido",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
  );
}

Widget _buildOrderItem(OrderItemModel order, context) {
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
                  ),
                  IconButton(
                    onPressed: () => {
                      BlocProvider.of<CartBloc>(context)
                          .add(RemoveCartEvent(item: order.item))
                    },
                    icon: Icon(Icons.remove_circle_outline_outlined),
                  ),
                  IconButton(
                    onPressed: () => {
                      BlocProvider.of<CartBloc>(context)
                          .add(InsertCartEvent(item: order.item))
                    },
                    icon: Icon(Icons.add_circle_outline_outlined),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
