part of 'antrian_bloc.dart';

@immutable
abstract class AntrianEvent {}

class InitiateAntrian extends AntrianEvent {}

class AddtoAntrian extends AntrianEvent {
  final StrukState data;
  AddtoAntrian(this.data);
}

class OrderFinish extends AntrianEvent {
  final int key;
  OrderFinish(this.key);
}

class OrderFailure extends AntrianEvent {
  final StrukState data;
  final String reason;
  OrderFailure(this.data, {required this.reason});
}
