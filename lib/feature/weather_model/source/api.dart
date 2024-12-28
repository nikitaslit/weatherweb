import 'package:dio/dio.dart';
import 'package:flutter_test_zadanie/feature/weather_model/currect_model.dart';
import 'package:flutter_test_zadanie/feature/weather_model/weather_temperature_model.dart';

abstract class _ProviderPath {
  static const String path = 'forecast.json';
}

class ApiProvider {
  final Dio _dio = Dio(BaseOptions(
      baseUrl:
          'https://api.weatherapi.com/v1/')); //https иначе нельзя обратиться к сайту погоды! через файрбейс!
  Future<List<WeatherModel>> getCurrentWeather(String city) async {
    final response = await _dio.get(_ProviderPath.path, queryParameters: {
      'key': '81859dc01a6344f4810161831243011',
      'q': city,
    });
    final jsonData =
        response.data['forecast']['forecastday'][0]['hour'] as List<dynamic>;
    final productList =
        jsonData.map((toElement) => WeatherModel.fromJson(toElement)).toList();
    return productList;
  }

  Future<int> getCurrentHour(String city) async {
    final response = await _dio.get(_ProviderPath.path, queryParameters: {
      'key': '81859dc01a6344f4810161831243011',
      'q': city,
    });
    final localtime = response.data['location']['localtime'] as String;
    final hour = int.parse(localtime.split(' ')[1].split(':')[0]);
    return hour;
  }

  Future<List<CurrentWeather>> getCurrent(String city) async {
    final response = await _dio.get(_ProviderPath.path, queryParameters: {
      'key': '81859dc01a6344f4810161831243011',
      'q': city,
    });
    final jsonData = response.data['current'] as Map<String, dynamic>;
    final productList = [CurrentWeather.fromJson(jsonData)];
    return productList;
  }
}
