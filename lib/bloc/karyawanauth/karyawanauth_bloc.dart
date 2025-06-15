import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:order_makan/repo/karyawan_authrepo.dart';

part 'karyawanauth_event.dart';
part 'karyawanauth_state.dart';

class KaryawanauthBloc extends Bloc<KaryawanauthEvent, KaryawanauthState> {
  final KaryawanAuthRepo auth;

  late final StreamSubscription<User> _userSubscription;
  KaryawanauthBloc(this.auth)
      : super(auth.currentUser.isEmpty
            ? KaryawanauthInitial()
            : KaryawanauthInitial()) {
    on<InitiateKaryawan>((event, emit) {});
    on<UserChanged>((event, emit) {
      if (event.username.isEmpty) {
        emit(KaryawanUnAuth());
      } else {
        emit(KaryawanAuthenticated(
            Karyawan(username: event.username, namaLengkap: 'namaLengkap')));
      }
    });
    on<SignIn>((event, emit) async {
      try {
        await auth.signIn(username: event.username, password: event.password);
      } on Exception catch (e) {
        emit(KaryawanUnAuth(errorMsg: e.toString()));
        await Future.delayed(const Duration(seconds: 4));
        emit(KaryawanUnAuth());
        print('e:');
        print(e);
      }
    });
    on<SignUp>((event, emit) async {
      await auth.signUp(username: event.username, password: event.password);
    });
    on<SignOut>((event, emit) async {
      await auth.signOut();
    });
    _userSubscription = auth.user.listen((event) {
      add(UserChanged(event.username));
    });
  }
  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
