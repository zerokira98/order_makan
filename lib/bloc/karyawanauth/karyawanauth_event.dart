part of 'karyawanauth_bloc.dart';

@immutable
abstract class KaryawanauthEvent {}

class Authenticate extends KaryawanauthEvent {}

class SignUp extends KaryawanauthEvent {
  final String email;
  final String password;
  SignUp(this.email, this.password);
}

class SignIn extends KaryawanauthEvent {
  final String email;
  final String password;
  SignIn(this.email, this.password);
}

class InitiateKaryawan extends KaryawanauthEvent {}

class SignOut extends KaryawanauthEvent {}

class UserChanged extends KaryawanauthEvent {
  final User user;
  UserChanged(this.user);
}
