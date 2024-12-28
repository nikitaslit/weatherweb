import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test_zadanie/feature/autorized/cubit/auth_cubit.dart';
import 'package:flutter_test_zadanie/feature/autorized/page/login_screen.dart';
import 'package:flutter_test_zadanie/feature/theme/notifier.dart';
import 'package:flutter_test_zadanie/feature/theme/storage_theme/storage_theme.dart';
import 'package:flutter_test_zadanie/feature/weather_list_city/pages/list_city.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  static const path = '/settingpage';

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String? userEmail;
  String? userUid;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Загружаем данные о текущем пользователе из Firebase
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email;
        userUid = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ThemeNotifier>().isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Настройки"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: "Вернуться к списку городов",
          onPressed: () {
            GoRouter.of(context)
                .go(ListCity.path); // Возвращаемся через GoRouter
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Отображаем email и uid
              if (userEmail != null && userUid != null) ...[
                Text("Email: $userEmail", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text("UID: $userUid", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
              ],
              // Переключатель для изменения темы
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Темная тема'),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) async {
                      context.read<ThemeNotifier>().toggleTheme(value);
                      await KeyStore.saveThemeStorage(
                          value); // Сохраняем в SharedPreferences
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  AuthCubit.i(context)
                      .signOut(); // Вызов метода signOut из AuthCubit
                  GoRouter.of(context)
                      .go(LoginScreen.path);
                },
                child: const Text("Выход"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
