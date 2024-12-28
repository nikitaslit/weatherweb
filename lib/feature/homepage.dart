import 'package:flutter/material.dart';
import 'package:flutter_test_zadanie/feature/autorized/page/login_screen.dart';
import 'package:flutter_test_zadanie/feature/weather_list_city/pages/list_city.dart';
import 'package:flutter_test_zadanie/feature/pages/setting_page.dart';
import 'package:flutter_test_zadanie/feature/weather_model/source/api.dart';
import 'package:go_router/go_router.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  static const String path = '/homepage';

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String temperature = '';
  String city = 'Омск';
  String statusMessage = 'Загружаем данные...';
  DateTime lastUpdate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchWeather(city); // Загружаем погоду при запуске
  }

  // Метод для получения данных о погоде
  Future<void> fetchWeather(String city) async {
    setState(() {
      statusMessage = 'Загружаем данные...'; // Показываем статус загрузки
    });

    final apiProvider = ApiProvider();
    final product = await apiProvider.getCurrentWeather(city);
    final time = await apiProvider.getCurrentHour(city);

    try {
      if (product.isNotEmpty) {
        setState(() {
          temperature = '${product[time].tempC}°C';
          statusMessage = 'Данные успешно получены';
          lastUpdate = DateTime.now(); // Обновляем время последнего обновления
        });
      } else {
        setState(() {
          temperature = 'Нет данных о погоде';
          statusMessage = 'Нет данных о погоде';
        });
      }
    } catch (e) {
      setState(() {
        temperature = 'Ошибка получения погоды';
        statusMessage = 'Ошибка получения данных';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Вычисляем количество секунд с последнего обновления
    int secondsSinceLastUpdate =
        DateTime.now().difference(lastUpdate).inSeconds;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () => GoRouter.of(context).go(ListCity.path),
              icon: const Icon(Icons.menu),
              tooltip: 'Список городов',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () => GoRouter.of(context).go(SettingPage.path),
              icon: const Icon(Icons.settings),
              tooltip: 'Настройки',
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                '$city\n$temperature',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              // Показываем статус обновления
              Text(
                statusMessage,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              // Показываем количество секунд с последнего обновления
              Text(
                'Время с последнего обновления: $secondsSinceLastUpdate секунд',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20.0),
              // Поле ввода для города
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Введите название другого города',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  setState(() {
                    city = value;
                  });
                  fetchWeather(city); // Запрашиваем погоду для нового города
                },
              ),
              const SizedBox(height: 20.0),
              // Кнопка для запроса погоды
              ElevatedButton(
                onPressed: () {
                  fetchWeather(city); // Запрашиваем погоду
                },
                child: const Text('Показать погоду'),
              ),
              const SizedBox(height: 20.0),
              // Добавим индикатор загрузки, если данные все еще загружаются
              if (statusMessage == 'Загружаем данные...')
                const CircularProgressIndicator(),
              ElevatedButton(
                onPressed: () => GoRouter.of(context).go(LoginScreen.path),
                child: const Text("Выйти"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
