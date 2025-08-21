import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:order_makan/repo/karyawan_authrepo.dart';
import 'package:order_makan/repo/user_model.dart' show User;

part 'karyawanauth_event.dart';
part 'karyawanauth_state.dart';

class KaryawanauthBloc extends Bloc<KaryawanauthEvent, KaryawanauthState> {
  final KaryawanAuthRepo auth;
// final FirebaseFirestore firestore;
  late final StreamSubscription<User> _userSubscription;
  KaryawanauthBloc(
    this.auth,
  ) : super(auth.currentUser.isEmpty
            ? KaryawanauthInitial()
            : KaryawanauthInitial()) {
    on<InitiateKaryawan>((event, emit) {
      emit(KaryawanUnAuth());
    });
    on<UserChanged>((event, emit) async {
      if (event.user.isEmpty) {
        emit(KaryawanUnAuth());
      } else {
        var isadmin = await auth.isAdmin();
        if (isadmin) {
          auth.setcurrentAdmin = true;
        }
        emit(KaryawanAuthenticated(user: auth.currentUser, isAdmin: isadmin));
      }
    });
    on<SignIn>((event, emit) async {
      try {
        await auth.logInWithEmailAndPassword(
            email: event.email, password: event.password);
      } on Exception catch (e) {
        emit(KaryawanUnAuth(errorMsg: e.toString()));
        // debugPrint('error $e');
        // await Future.delayed(const Duration(seconds: 4));
        // emit(KaryawanUnAuth());
      }
    });
    on<SignUp>((event, emit) async {
      await auth.signUp(
          email: event.email,
          password: event.password,
          displayName: event.username);
    });
    on<SignOut>((event, emit) async {
      await auth.logOut();
    });
    _userSubscription = auth.user.listen((event) {
      add(UserChanged(event));
    });
  }
  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
