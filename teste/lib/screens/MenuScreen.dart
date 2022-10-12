import 'package:teste/data/data.dart';
import 'package:flutter/material.dart';
import 'package:teste/main.dart';
import 'package:teste/models/MenuItemModel.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: menu.length,
        itemBuilder: ((context, index) {
          return _buildMenuItem(menu[index]);
        }));
  }

  Widget _buildMenuItem(MenuItemModel menuItem) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              height: 175,
              child: Row(
                children: [
                  Container(
                    width: 175,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: NetworkImage(menuItem.imageURL),
                            fit: BoxFit.cover)),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        menuItem.description,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "R\$${menuItem.value}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ],
              )),
          Positioned(
              bottom: 15,
              right: 10,
              child: Container(
                // width: 48,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(30)),
                    child: IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            "${menuItem.description} adicionado ao pedido da mesa ${table.number}"),
                          ),
                       );
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    )),
              ))
        ],
      ),
    );
  }
}
