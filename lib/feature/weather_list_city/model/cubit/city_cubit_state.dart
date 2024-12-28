import 'package:flutter_test_zadanie/feature/weather_list_city/model/city_model.dart';

abstract interface class CityCubitState {}

final class CityListLoading implements CityCubitState {}

final class CityListSuccess implements CityCubitState {
  final List<CityModel> citylist;

  CityListSuccess({required this.citylist});
}

final class CityListFailed implements CityCubitState {
  final Object? error;

  CityListFailed({required this.error});
}
