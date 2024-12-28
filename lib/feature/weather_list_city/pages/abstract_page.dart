import 'package:flutter/material.dart';
import 'package:flutter_test_zadanie/feature/pages/setting_page.dart';
import 'package:flutter_test_zadanie/feature/weather_list_city/pages/list_city.dart';
import 'package:flutter_test_zadanie/feature/weather_model/source/api.dart'; // Импортируем ApiProvider
import 'package:flutter_test_zadanie/feature/weather_list_city/pages/storage/storage_city.dart';
import 'package:go_router/go_router.dart';

class AbstractPage extends StatefulWidget {
  final String cityName;

  const AbstractPage({super.key, required this.cityName});

  static const path = '/abstractpage';

  @override
  State<AbstractPage> createState() => _AbstractPageState();
}

class _AbstractPageState extends State<AbstractPage> {
  String temperature = '';
  String statusMessage = 'Загружаем данные...';
  String abstractcity = '';
  String cloud = '';
  String feelsliketemp = '';
  String humidity = '';
  String windKph = '';
  String conditionText = '';
  String conditionIcon = '';

  @override
  void initState() {
    super.initState();
    _initializeCityAndFetchWeather();
  }

  Future<void> _initializeCityAndFetchWeather() async {
    final savedCity = await KeyStores.loadCityStorage();
    setState(() {
      abstractcity = savedCity;
    });
    await fetchWeather(abstractcity);
    await fetchCloud(abstractcity);
  }

  Future<void> fetchCloud(String city) async {
    setState(() {
      statusMessage =
          'Загружаем данные погоды...'; // Показываем статус загрузки
    });
    final apoProvider = ApiProvider();
    final product = await apoProvider.getCurrent(city);
    try {
      if (product.isNotEmpty) {
        setState(() {
          cloud = '${product.first.feelsLikeC}';
          feelsliketemp = '${product[0].feelsLikeC}';
          humidity = '${product[0].humidity}';
          windKph = '${product[0].windKph}';
          conditionText = product[0].conditionText;
          conditionIcon = product[0].conditionIcon;
          statusMessage = 'Данные успешно получены';
        });
      } else {
        setState(() {
          statusMessage = 'Нет данных о погоде';
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = 'Ошибка получения данных $e';
      });
    }
  }

  // Метод для получения данных о погоде
  Future<void> fetchWeather(String city) async {
    setState(() {
      statusMessage = 'Поднимаем температуру...'; // Показываем статус загрузки
    });

    final apiProvider = ApiProvider();
    final product = await apiProvider.getCurrentWeather(city);
    final time = await apiProvider.getCurrentHour(city);

    try {
      if (product.isNotEmpty) {
        setState(() {
          temperature = '${product[time].tempC}°C'; // Извлекаем температуру
          statusMessage = 'Данные успешно получены';
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
        statusMessage = 'Ошибка получения данных $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Погода вашего города: $abstractcity"),
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
                '$abstractcity\n$temperature',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                statusMessage,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
              Text('Температура ощущается как: $feelsliketemp °C'),
              Text('Влажность: $humidity%'),
              Text('Скорость ветра: $windKph км/ч'),
              Text('Погода: $conditionText'),
              conditionIcon.isNotEmpty
                  ? Image.network(conditionIcon)
                  : const SizedBox.shrink(),
              const SizedBox(height: 20.0),
              // Добавим индикатор загрузки
              if (statusMessage == 'Загружаем данные...')
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
