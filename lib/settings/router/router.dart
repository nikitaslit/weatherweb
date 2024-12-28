import "package:flutter_test_zadanie/feature/autorized/page/login_screen.dart";
import "package:flutter_test_zadanie/feature/autorized/page/registration.dart";
import "package:flutter_test_zadanie/feature/homepage.dart";
import "package:flutter_test_zadanie/feature/weather_list_city/pages/abstract_page.dart";
import "package:flutter_test_zadanie/feature/weather_list_city/pages/list_city.dart";
import "package:flutter_test_zadanie/feature/pages/setting_page.dart";
import "package:flutter_test_zadanie/feature/pages/welcom_screen.dart";
import "package:go_router/go_router.dart";

abstract final class AppRouter {
  static final route = GoRouter(initialLocation: LoginScreen.path, routes: [
    GoRoute(
      path: Homepage.path,
      builder: (context, state) => const Homepage(),
    ),
    GoRoute(
      path: WelcomScreen.path,
      builder: (context, state) => const WelcomScreen(),
    ),
    GoRoute(
      path: LoginScreen.path,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Registration.path,
      builder: (context, state) => const Registration(),
    ),
    GoRoute(
      path: ListCity.path,
      builder: (context, state) => const ListCity(),
    ),
    GoRoute(
      path: SettingPage.path,
      builder: (context, state) => const SettingPage(),
    ),
    GoRoute(
      path: AbstractPage.path, // Путь остается фиксированным
      builder: (context, state){
        final cityName = state.extra as String? ?? 'Неизвестный город';
        return AbstractPage(cityName: cityName);
      },
    ),
  ]);
}
