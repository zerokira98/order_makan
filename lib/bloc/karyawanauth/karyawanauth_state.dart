part of 'karyawanauth_bloc.dart';

@immutable
abstract class KaryawanauthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class KaryawanauthInitial extends KaryawanauthState {}

class KaryawanAuthenticated extends KaryawanauthState {
  final Karyawan user;
  KaryawanAuthenticated(this.user);
}

class KaryawanUnAuth extends KaryawanauthState {
  final String? errorMsg;
  KaryawanUnAuth({this.errorMsg});
  @override
  List<Object?> get props => [errorMsg];
}

class KaryawanLoading extends KaryawanauthState {}

class Karyawan {
  String username;
  String namaLengkap;
  String? gambar;
  Karyawan({required this.username, required this.namaLengkap});
}
