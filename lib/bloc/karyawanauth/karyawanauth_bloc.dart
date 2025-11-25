import 'dart:async';

import 'package:android_id/android_id.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../repo/repo.dart';

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
            email: event.email.trim(), password: event.password);
      } on Exception catch (e) {
        emit(KaryawanUnAuth(errorMsg: e.toString()));
        // debugPrint('error $e');
        // await Future.delayed(const Duration(seconds: 4));
        // emit(KaryawanUnAuth());
      }
    });
    on<SignUp>((event, emit) async {
      await auth.signUp(
          email: event.email.trim(),
          password: event.password,
          displayName: event.username);
    });
    on<SignOut>((event, emit) async {
      auth.logOut().then(
        (value) {
          if (!kIsWasm) {
            FirebaseMessaging.instance.getToken().then((token) async {
              debugPrint("tken:$token");
              var androidId = await const AndroidId().getId();
              DeviceRepo(
                firestore: FirebaseFirestore.instance,
              ).updateToken((androidId ?? 'unknownid'), token!, false);
            });
          }
        },
      );
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
