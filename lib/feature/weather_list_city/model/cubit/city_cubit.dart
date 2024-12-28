import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_zadanie/feature/weather_list_city/model/city_model.dart';
import 'package:flutter_test_zadanie/feature/weather_list_city/model/cubit/city_cubit_state.dart';
import 'package:flutter_test_zadanie/feature/weather_list_city/repository/city_repository.dart';

class CityCubit extends Cubit<CityCubitState> {
  final CityRepository _cityRepository;

  CityCubit(this._cityRepository) : super(CityListLoading());

  Future<void> loadCity() async {
    try {
      final cities = await _cityRepository.getCity();

      // Если список пуст, добавляем город "Пермь"
      if (cities.isEmpty) {
        final defaultCity = CityModel(
          id: '', // ID будет автоматически добавлен Firebase
          name: 'Пермь',
          userId: _cityRepository.user.uid,
        );
        await createCity(defaultCity); // Используем метод создания города
        emit(CityListSuccess(citylist: [defaultCity]));
      } else {
        emit(CityListSuccess(citylist: cities));
      }
    } catch (e) {
      emit(CityListFailed(error: e.toString()));
    }
  }

  Future<void> createCity(CityModel city) async {
    try {
      await _cityRepository.addCity(city);
      if (state is CityListSuccess) {
        final currectState = state as CityListSuccess;
        final updateList = List<CityModel>.from(currectState.citylist)
          ..add(city);
        emit(CityListSuccess(citylist: updateList));
      }
    } catch (e) {
      emit(CityListFailed(error: e.toString()));
    }
  }

  Future<void> deleteCity(String cityId) async {
    try {
      await _cityRepository.deleteCity(cityId);

      if (state is CityListSuccess) {
        final currentState = state as CityListSuccess;
        final updatedList =
            currentState.citylist.where((city) => city.id != cityId).toList();
        emit(CityListSuccess(citylist: updatedList));
      }
    } catch (e) {
      emit(CityListFailed(error: e.toString()));
    }
  }
}
