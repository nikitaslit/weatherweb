import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_zadanie/feature/pages/setting_page.dart';
import 'package:flutter_test_zadanie/feature/weather_list_city/model/city_model.dart';
import 'package:flutter_test_zadanie/feature/weather_list_city/model/cubit/city_cubit.dart';
import 'package:flutter_test_zadanie/feature/weather_list_city/model/cubit/city_cubit_state.dart';
import 'package:flutter_test_zadanie/feature/weather_list_city/pages/abstract_page.dart';
import 'package:flutter_test_zadanie/feature/weather_list_city/pages/storage/storage_city.dart';
import 'package:go_router/go_router.dart'; // Импортируйте AbstractPage

class ListCity extends StatefulWidget {
  const ListCity({super.key});

  static const path = '/city';

  @override
  State<ListCity> createState() => _ListCityState();
}

class _ListCityState extends State<ListCity> {
  final _namecityController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    context.read<CityCubit>().loadCity();
  }

  void _createCity() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("User is not logged in")));
      return;
    }

    final city = CityModel(
      id: '',
      userId: currentUser.uid, // Используем ID текущего пользователя
      name: _namecityController.text,
    );
    await context.read<CityCubit>().createCity(city);
    _namecityController.clear();
    context.read<CityCubit>().loadCity();
    Navigator.of(context).pop();
  }

  void _showAddCityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить город'),
          content: TextField(
            controller: _namecityController,
            decoration:
                const InputDecoration(hintText: "Введите название города"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: _createCity,
              child:
                  const Text('Добавить'),
            ),
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ваш список городов"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed:
                  _showAddCityDialog,
              icon: const Icon(Icons.add),
              tooltip: 'Добавить город',
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
      body: BlocBuilder<CityCubit, CityCubitState>(
        builder: (context, state) {
          if (state is CityListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CityListSuccess) {
            final cities = state.citylist;
            return ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cities[index].name),
                  onTap: () async {
                    await KeyStores.saveCityStorage(cities[index].name);
                    GoRouter.of(context).go(
                      AbstractPage.path,
                      extra: cities[index].name, 
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Удаляем задачу
                      context.read<CityCubit>().deleteCity(cities[index].id);
                    },
                  ),
                );
              },
            );
          } else if (state is CityListFailed) {
            return Center(child: Text('Ошибка: ${state.error}'));
          }
          return const Center(child: Text('Неизвестное состояние'));
        },
      ),
    );
  }
}
