part of 'karyawanauth_bloc.dart';

@immutable
abstract class KaryawanauthEvent {}

class Authenticate extends KaryawanauthEvent {}

class InitiateKaryawan extends KaryawanauthEvent {}
