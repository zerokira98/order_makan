part of 'karyawanauth_bloc.dart';

@immutable
abstract class KaryawanauthState {}

class KaryawanauthInitial extends KaryawanauthState {}

class KaryawanAuthenticated extends KaryawanauthState {
  final Karyawan user;
  KaryawanAuthenticated(this.user);
}

class KaryawanUnAuth extends KaryawanauthState {}

class KaryawanLoading extends KaryawanauthState {}

class Karyawan {
  String username;
  String namaLengkap;
  String? gambar;
  Karyawan({required this.username, required this.namaLengkap});
}
