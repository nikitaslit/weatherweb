import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_zadanie/feature/autorized/cubit/auth_cubit.dart';
import 'package:flutter_test_zadanie/feature/theme/notifier.dart';
import 'package:flutter_test_zadanie/feature/weather_list_city/repository/city_repository.dart';
import 'package:flutter_test_zadanie/feature/weather_list_city/model/cubit/city_cubit.dart';
import 'package:flutter_test_zadanie/firebase_options.dart';
import 'package:flutter_test_zadanie/settings/router/router.dart';
import 'package:flutter_test_zadanie/feature/theme/storage_theme/storage_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Загружаем тему из SharedPreferences
  bool isDarkMode = await KeyStore.loadThemeStorage();

  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;

  const MyApp({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(firebaseAuth: auth)),
        BlocProvider(create: (_) => CityCubit(CityRepository(firestore: firestore, user: auth.currentUser!))),
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeNotifier(isDarkMode),
        child: Consumer<ThemeNotifier>(
          builder: (context, themeNotifier, _) {
            return MaterialApp.router(
              routerConfig: AppRouter.route,
              title: "Weather Auth project",
              themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              darkTheme: ThemeData.dark(),
              theme: ThemeData.light(),
            );
          },
        ),
      ),
    );
  }
}
