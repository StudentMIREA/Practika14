import 'package:flutter/material.dart';
import 'package:pr14/Pages/EditPage.dart';
import 'package:pr14/api_service.dart';
import 'package:pr14/auth/auth_service.dart';
import 'package:pr14/model/person.dart';
import 'package:pr14/pages/ChatPage.dart';
import 'package:pr14/pages/OrderPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.navToShopCart});

  final Function(int i) navToShopCart;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();
  final userEmail = AuthService().getCurrentUserEmail();
  late Future<Person> person;
  late Future<int> userId;

  @override
  void initState() {
    super.initState();

    person = ApiService().getUserByID(userEmail);
  }

  void _refreshData() {
    setState(() {
      person = ApiService().getUserByID(userEmail);
    });
  }

  void navToEdit(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPage()),
    );
    _refreshData();
  }

  void navToOrder(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OrderPage(navToShopCart: (i) => widget.navToShopCart(i))),
    );
    _refreshData();
  }

  void navToChat(BuildContext context, String role) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChatPage(
                role: role,
              )),
    );
    _refreshData();
  }

  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[200],
        appBar: AppBar(
          title: const Text('Профиль'),
          actions: [
            IconButton(onPressed: logout, icon: const Icon(Icons.logout))
          ],
          backgroundColor: Colors.white70,
        ),
        body: Center(
          child: FutureBuilder<Person>(
              future: person,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Scaffold(
                      backgroundColor: Colors.amber[200],
                      appBar: AppBar(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 246, 218),
                      ),
                      body: Center(child: Text('Error: ${snapshot.error}')));
                } else if (!snapshot.hasData) {
                  return Scaffold(
                      backgroundColor: Colors.amber[200],
                      appBar: AppBar(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 246, 218),
                      ),
                      body: Center(child: Text('No product found')));
                }

                final person = snapshot.data!;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 246, 218),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.width * 0.15,
                                decoration: BoxDecoration(
                                    color: Colors.amber[100],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.grey, width: 2),
                                    image: DecorationImage(
                                      image: NetworkImage(person.image),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        person.name,
                                        style: const TextStyle(fontSize: 14.0),
                                      ),
                                    ),
                                    person.phone != 'null'
                                        ? Text(
                                            'Телефон: ${person.phone}',
                                            style:
                                                const TextStyle(fontSize: 12.0),
                                          )
                                        : const SizedBox(),
                                    Text(
                                      'Почта: ${person.mail}',
                                      style: const TextStyle(fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      child: ElevatedButton(
                        onPressed: () => navToOrder(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 255, 246, 218),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_bag_rounded),
                              SizedBox(
                                width: 20,
                              ),
                              Text('Мои заказы'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 5.0),
                      child: ElevatedButton(
                        onPressed: () => navToEdit(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 255, 246, 218),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit),
                              SizedBox(
                                width: 20,
                              ),
                              Text('Редактировать профиль'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: ElevatedButton(
                        onPressed: () => navToChat(context, person.role),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 255, 246, 218),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.chat),
                              const SizedBox(
                                width: 20,
                              ),
                              person.role == 'admin'
                                  ? const Text('Чаты с покупателями')
                                  : const Text('Чат с продавцом'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ));
  }
}
