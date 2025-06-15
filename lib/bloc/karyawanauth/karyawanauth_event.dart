part of 'karyawanauth_bloc.dart';

@immutable
abstract class KaryawanauthEvent {}

class Authenticate extends KaryawanauthEvent {}

class SignUp extends KaryawanauthEvent {
  final String username;
  final String password;
  SignUp(this.username, this.password);
}

class SignIn extends KaryawanauthEvent {
  final String username;
  final String password;
  SignIn(this.username, this.password);
}

class InitiateKaryawan extends KaryawanauthEvent {}

class SignOut extends KaryawanauthEvent {}

class UserChanged extends KaryawanauthEvent {
  final String username;
  UserChanged(this.username);
}
