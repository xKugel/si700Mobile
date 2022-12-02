import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste/bloc/cart_bloc.dart';
import 'package:teste/bloc/monitor_item_bloc.dart';
import 'package:flutter/material.dart';
import 'package:teste/bloc/monitor_order_bloc.dart';
import 'package:teste/bloc/monitor_order_list_bloc.dart';
import 'package:teste/main.dart';
import 'package:teste/models/MenuItemModel.dart';
import 'package:teste/models/MenuItensModel.dart';
import 'package:teste/models/MenuOrdersModel.dart';
import 'package:teste/models/OrderItemModel.dart';
import 'package:teste/models/OrderModel.dart';

double _getTotal(List<OrderItemModel> orders) {
  double total = 0;

  for (var i = 0; i < orders.length; i++) {
    total += (orders[i].item.value * orders[i].quantity);
  }

  return total;
}

String _itemResume(List<OrderItemModel> ords) {
  String toReturn = "";
  for (int i = 0; i < ords.length; i++) {
    toReturn += "${ords[i].item.name} ${ords[i].quantity}x\n";
  }
  return toReturn;
}

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonitorOrderListBloc, MonitorOrderListState>(
      builder: (context, state) => getItensListView(state.itensCollection),
    );
  }

  ListView getItensListView(MenuOrdersModel itensCollection) {
    return ListView.builder(
      itemCount: itensCollection.length(),
      itemBuilder: ((context, index) =>
          _buildMenuItem(itensCollection.getNodeAtIndex(index))),
    );
  }

  Widget _buildMenuItem(OrderModel menuItem) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              height: 175,
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          textAlign: TextAlign.left,
                          "Itens:\n ${_itemResume(menuItem.itensList)}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20, bottom: 15),
                        child: Text(
                          textAlign: TextAlign.center,
                          "Mesa: ${menuItem.tableNumber}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20, bottom: 15),
                        child: Text(
                          textAlign: TextAlign.center,
                          "Status: ${menuItem.status == 'A' ? "Aberto" : "Fechado"}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Text(
                          textAlign: TextAlign.right,
                          "Total:\nR\$${_getTotal(menuItem.itensList)}",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }
}
