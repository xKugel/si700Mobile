import 'package:teste/models/MenuItemModel.dart';
import 'package:teste/models/OrderModel.dart';
import 'package:teste/models/TableModel.dart';

final _feijoada = MenuItemModel(
    imageURL:
        "https://blog.biglar.com.br/wp-content/uploads/2021/10/typical-brazilian-dish-called-feijoada-made-with-black-beans-pork-sausage.jpg",
    description: "Feijoada",
    value: 43.00);
final _lasanha = MenuItemModel(
    imageURL:
        "https://img.itdg.com.br/tdg/images/recipes/000/000/876/324587/324587_original.jpg?mode=crop&width=710&height=400",
    description: "Lasanha",
    value: 37.00);
final _strogonoff = MenuItemModel(
    imageURL:
        "https://images.aws.nestle.recipes/original/73cfbb5072ff136c81aed2c7c3a7cd65_stogonoff-carne-receitas-nestle.jpg",
    description: "Strogonoff",
    value: 35.00);
final _espetinho = MenuItemModel(
    imageURL:
        "https://espetinhodesucesso.com.br/wp-content/uploads/2018/03/espetinho-de-carne-com-bacon-1200x900.jpg",
    description: "Espetinho",
    value: 15.00);
final _hotdog = MenuItemModel(
    imageURL:
        "https://receitinhas.com.br/wp-content/uploads/2022/06/cachorro-quente-tradicional-2.jpg",
    description: "Hot Dog",
    value: 14.00);
final _burguer = MenuItemModel(
    imageURL:
        "https://classic.exame.com/wp-content/uploads/2020/05/mafe-studio-LV2p9Utbkbw-unsplash-1.jpg?quality=70&strip=info&w=1024",
    description: "Hamburguer",
    value: 20.00);
final _pizza = MenuItemModel(
    imageURL:
        "https://img.itdg.com.br/tdg/images/blog/uploads/2022/07/5-itens-necessarios-para-se-tornar-um-pizzaiolo-neste-Dia-da-Pizza.jpg?mode=crop&width={:width=%3E150,%20:height=%3E130}",
    description: "Pizza",
    value: 30.00);
final _coxinha = MenuItemModel(
    imageURL:
        "https://img.itdg.com.br/tdg/images/recipes/000/080/686/21535/21535_original.jpg?w=1200",
    description: "Coxinha",
    value: 10.00);
final _coca = MenuItemModel(
    imageURL:
        "https://www.imigrantesbebidas.com.br/bebida/images/products/full/1984-refrigerante-coca-cola-lata-350ml.jpg",
    description: "Coca Cola",
    value: 8.00);
final _guarana = MenuItemModel(
    imageURL:
        "https://riomarrecife.com.br/recife/2020/03/guarana-antarctica.jpg",
    description: "Guarana",
    value: 8.00);

final List<MenuItemModel> menu = [
  _feijoada,
  _lasanha,
  _strogonoff,
  _espetinho,
  _hotdog,
  _burguer,
  _pizza,
  _coxinha,
  _coca,
  _guarana
];

List<OrderModel> order = [
  OrderModel(item: _feijoada, quantity: 1),
  OrderModel(item: _coca, quantity: 2)
];

List<OrderModel> tableOrder = [
  OrderModel(item: _lasanha, quantity: 1),
  OrderModel(item: _hotdog, quantity: 3),
  OrderModel(item: _guarana, quantity: 4),
  OrderModel(item: _pizza, quantity: 1),
  OrderModel(item: _feijoada, quantity: 1),
  OrderModel(item: _coca, quantity: 2)
];

var table = TableModel(number: 0, orders: tableOrder);
