import 'package:flutter/material.dart';
import 'package:pr14/api_service.dart';
import 'package:pr14/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void signUp() async {
    final name = nameController.text;
    final email = mailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Пароли не совпадают',
          style: TextStyle(color: Colors.black, fontSize: 16.0),
        ),
        backgroundColor: Colors.amber[700],
      ));
      return;
    }
    try {
      await authService.signUpWithEmailPassword(email, password);
      await ApiService().addNewUser(name, email);
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Error: $e",
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          backgroundColor: Colors.amber[700],
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromARGB(255, 255, 246, 218),
        appBar: AppBar(
          title: const Text('Регистрация'),
          backgroundColor: Colors.amber[200],
        ),
        body: SingleChildScrollView(
            physics:
                BouncingScrollPhysics(), // Optional for a smoother scroll experience
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 16.0, top: 200.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'Имя',
                        hintStyle:
                            const TextStyle(fontSize: 14.0, color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(255, 160, 0, 1),
                                width: 1.0)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(255, 160, 0, 1),
                                width: 2.0)),
                      ),
                      controller: nameController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'Почта',
                        hintStyle:
                            const TextStyle(fontSize: 14.0, color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(255, 160, 0, 1),
                                width: 1.0)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(255, 160, 0, 1),
                                width: 2.0)),
                      ),
                      controller: mailController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.black),
                      decoration: const InputDecoration(
                        fillColor: const Color.fromARGB(255, 255, 246, 218),
                        hintText: 'Пароль',
                        hintStyle:
                            const TextStyle(fontSize: 14.0, color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(255, 160, 0, 1),
                                width: 1.0)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(255, 160, 0, 1),
                                width: 2.0)),
                      ),
                      controller: passwordController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.black),
                      decoration: const InputDecoration(
                        fillColor: const Color.fromARGB(255, 255, 246, 218),
                        hintText: 'Повторите пароль',
                        hintStyle:
                            const TextStyle(fontSize: 14.0, color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(255, 160, 0, 1),
                                width: 1.0)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(255, 160, 0, 1),
                                width: 2.0)),
                      ),
                      controller: confirmPasswordController,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[200],
                          padding: const EdgeInsets.only(
                              bottom: 13.0, top: 13.0, right: 30.0, left: 30.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                      onPressed: signUp,
                      child: const Text('Зарегистрироваться',
                          style: TextStyle(fontSize: 16, color: Colors.black)))
                ],
              ),
            )));
  }
}
