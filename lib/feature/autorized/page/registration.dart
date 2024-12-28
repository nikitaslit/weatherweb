import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_zadanie/feature/autorized/cubit/auth_cubit.dart';
import 'package:flutter_test_zadanie/feature/autorized/cubit/auth_cubit_state.dart';
import 'package:flutter_test_zadanie/feature/autorized/page/login_screen.dart';
import 'package:flutter_test_zadanie/feature/weather_list_city/pages/abstract_page.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui'; // Для использования BackdropFilter

class Registration extends StatefulWidget {
  const Registration({super.key});

  static const path = "/registration";

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Зарегестрироваться"),
        backgroundColor: const Color.fromARGB(255, 244, 227, 41),
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/kirills.jpg',
          //     fit:
          //         BoxFit.cover, // Изображение будет растягиваться на весь экран
          //   ),
          // ),
          // Positioned.fill(//размытие
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Размытие
          //     child: Container(
          //       color:
          //           Colors.black.withOpacity(0.5), // Темный полупрозрачный слой
          //     ),
          //   ),
          // ),
          BlocConsumer<AuthCubit, AuthCubitState>(
            listener: (context, state) {
              if (state is AuthCubitAuthorized) {
                GoRouter.of(context).go(AbstractPage.path, extra: "Пермь");
              } else if (state is AuthCubitUnAuthorized) {
                // Если ошибка при регистрации, показываем сообщение об ошибке
                final error = state.error ?? 'Неизвестная ошибка';
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(error.toString())));
              }
            },
            builder: (context, state) {
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
                        width: 600,
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: "Логин"),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 600,
                        child: TextField(
                          controller: _passController,
                          decoration:
                              const InputDecoration(labelText: "Пароль"),
                          obscureText: true, // Скрыть ввод пароля
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                      const SizedBox(height: 20), // Отступ внизу
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuthCubit>().singUp(
                              email: _emailController.text,
                              password: _passController.text);
                        },
                        child: const Text("Зарегестрироваться"),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            GoRouter.of(context).go(LoginScreen.path),
                        child: const Text("Уже Зарегестрированы? Войти"),
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
