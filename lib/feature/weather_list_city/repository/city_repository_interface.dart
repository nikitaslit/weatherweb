import 'package:flutter_test_zadanie/feature/weather_list_city/model/city_model.dart';

abstract class CityRepositoryInterface {
  Future<List<CityModel>> getCity();
  Future<CityModel> getCitybyId(String cityid);
  Future<void> addCity(CityModel city);
  Future<void> updateCity(CityModel city);
  Future<void> deleteCity(String cityid);
}
