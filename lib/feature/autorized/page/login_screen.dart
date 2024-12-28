import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_zadanie/feature/autorized/cubit/auth_cubit.dart';
import 'package:flutter_test_zadanie/feature/autorized/cubit/auth_cubit_state.dart';
import 'package:flutter_test_zadanie/feature/autorized/page/registration.dart';
import 'package:flutter_test_zadanie/feature/weather_list_city/pages/abstract_page.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const path = '/login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Авторизоваться"),
        backgroundColor: const Color.fromARGB(
            255, 244, 227, 41), 
        foregroundColor:
            Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/artem.jpg',
          //   ),
          // ),
          BlocConsumer<AuthCubit, AuthCubitState>(
            listener: (context, state) {
              if (state is AuthCubitAuthorized) {
                GoRouter.of(context).go(AbstractPage.path, extra: "Пермь");
              }
              if (state is AuthCubitUnAuthorized) {
                final error = state.error ??
                    "Попытались сами вас авторизовать - неудачно!";
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(error.toString())));
              }
            },
            builder: (BuildContext context, AuthCubitState state) {
              if (state is AuthCubitLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 600, // Установите желаемую ширину для TextField
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: "Логин"),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 10), // Между текстовыми полями
                      SizedBox(
                        width: 600, // ширина для TextField
                        child: TextField(
                          controller: _passController,
                          decoration:
                              const InputDecoration(labelText: "Пароль"),
                          obscureText: true, // Скрыть ввод пароля
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20), // Отступ вниз
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuthCubit>().singIn(
                              email: _emailController.text,
                              password: _passController.text);
                        },
                        child: const Text("Войти"),
                      ),
                      TextButton(
                        onPressed: () =>
                            GoRouter.of(context).go(Registration.path),
                        child: const Text("Зарегистрироваться"),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
