import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test_zadanie/feature/weather_list_city/model/city_model.dart';
import 'package:flutter_test_zadanie/feature/weather_list_city/repository/city_repository_interface.dart';

abstract final class _FirestoreKey {
  static const String citykey = 'cities';
}

final class CityRepository implements CityRepositoryInterface {
  final FirebaseFirestore _firestore;
  final User _user;
  User get user => _user;

  CityRepository({required FirebaseFirestore firestore, required User user})
      : _firestore = firestore,
        _user = user;
  CollectionReference<Map<String, dynamic>> get _cityCollection =>
      _firestore.collection(_FirestoreKey.citykey);

  @override
  Future<void> addCity(CityModel city) async {
    try {
      final jsonData = city.toMap()..remove('id');
      log("ADD City $jsonData");
      await _cityCollection.add({...jsonData, "userId": _user.uid});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteCity(String cityid) async {
    try {
      await _cityCollection.doc(cityid).delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CityModel>> getCity() async {
    try {
      final querySnapshot =
          await _cityCollection.where('userId', isEqualTo: _user.uid).get();
      final cityList = querySnapshot.docs.map((document) {
        final documentId = document.id;
        final jsonData = {...document.data(), 'id': documentId};
        return CityModel.fromMap(jsonData);
      }).toList();
      return cityList;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CityModel> getCitybyId(String cityid) async {
    try {
      final document = await _cityCollection.doc(cityid).get();
      final id = document.id;
      final data = document.data();
      final jsonData = {...?data, "id": id};
      final city = CityModel.fromMap(jsonData);
      return city;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateCity(CityModel city) async {
    try {
      await _cityCollection.doc(city.id).update(city.toMap());
    } catch (e) {
      rethrow;
    }
  }
}
