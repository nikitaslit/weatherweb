import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_zadanie/feature/autorized/cubit/auth_cubit_state.dart';

class AuthCubit extends Cubit<AuthCubitState> {
  final FirebaseAuth _firebaseAuth; //Вход авторизация выход
  late StreamSubscription<User?>
      _streamSubscription; //Подписка на поток пользовоталея который сообщает об состоянии входа выхода пользователя

  static AuthCubit i(BuildContext context) =>
      context.read<AuthCubit>(); //Получить экземпляр из контекста с помощью рид

  AuthCubit({
    required FirebaseAuth firebaseAuth,
  })  : _firebaseAuth = firebaseAuth,
        super(AuthCubitLoading()) {
    log('AuthCubit is created');
    _streamSubscription = _firebaseAuth
        .authStateChanges()
        .listen(_onAuthStateChange); //Уведомление о действиях пользователя.
  }
  
  void _onAuthStateChange(User? user) {
    if (user != null) {
      emit(AuthCubitAuthorized(user: user));
    } else {
      emit(AuthCubitUnAuthorized());
    }
  }

  Future<void> singIn({
    required String email,
    required String password,
  }) async {
    emit(AuthCubitLoading());
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      emit(AuthCubitAuthorized(user: result.user!));
    } catch (e) {
      log("ERROR SING IN $e");
      emit(AuthCubitUnAuthorized(error: e));
    }
  }

  Future<void> singUp({
    required String email,
    required String password,
  }) async {
    emit(AuthCubitLoading());
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      emit(AuthCubitAuthorized(user: result.user!));
    } catch (e) {
      log("ERROR IN SINGUP $e");
      emit(AuthCubitUnAuthorized(error: e));
    }
  }

  Future<void> signOut() async {
    try {
      _firebaseAuth.signOut();
    } catch (e) {
      log("ERROR SIGN OUT $e");
    } finally {
      emit(AuthCubitUnAuthorized());
    }
  }

  @override
  Future<void> close() async {
    _streamSubscription.cancel();
    return super.close();
  }
}
