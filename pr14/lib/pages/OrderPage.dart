import 'package:flutter/material.dart';
import 'package:pr14/api_service.dart';
import 'package:pr14/model/order.dart';
import 'package:pr14/auth/auth_service.dart';
import 'package:pr14/pages/ItemPage.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key, required this.navToShopCart});

  final Function(int i) navToShopCart;

  // Переход на страницу с товарами
  void NavToItem(index, BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemPage(
          index: index,
          navToShopCart: (i) => navToShopCart(i),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Замените 1 на нужный userId
    final userEmail = AuthService().getCurrentUserEmail();

    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        title: const Text('Мои заказы'),
        backgroundColor: Colors.white70,
      ),
      body: FutureBuilder<List<Order>>(
        future: ApiService()
            .getOrders(userEmail!), // Асинхронный вызов функции getOrders
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Пока данные загружаются, отображаем индикатор загрузки
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Если произошла ошибка, отображаем сообщение об ошибке
            return Center(
                child: Text('Ошибка загрузки заказов: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Если нет данных, отображаем сообщение об отсутствии заказов
            return Center(child: Text('Нет заказов.'));
          }

          // Если данные успешно загружены, отображаем список заказов
          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Container(
                margin: const EdgeInsets.all(8.0),
                //height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 246, 218),
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Номер заказа: ${order.orderId}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Статус: ${order.status}'),
                      Text(
                          'Дата создания: ${order.createdAt.toLocal().toString().split(' ')[0]}'),
                      const SizedBox(height: 8.0),
                      Container(
                        height: 150, // Задайте высоту контейнера
                        child: ListView.builder(
                          scrollDirection:
                              Axis.horizontal, // Горизонтальная прокрутка
                          itemCount: order.products.length,
                          itemBuilder: (context, productIndex) {
                            final product = order.products[productIndex];
                            return GestureDetector(
                              onTap: () =>
                                  NavToItem(product.productId, context),
                              child: Container(
                                width: 120,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      product.image,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ), // Изображение продукта
                                    Text('Кол-во: ${product.quantity}',
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0))),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('Сумма заказа: '),
                            Text(
                              '${order.total.toStringAsFixed(2)} ₽',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 6, 196, 9),
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
