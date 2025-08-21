part of 'antrian_bloc.dart';

@immutable
abstract class AntrianEvent {}

class InitiateAntrian extends AntrianEvent {
  final Map? msg;
  InitiateAntrian({this.msg});
}

class ClrMsg extends AntrianEvent {
  ClrMsg();
}

class AddtoAntrian extends AntrianEvent {
  final UseStrukState data;
  AddtoAntrian(this.data);
}

class OrderFinish extends AntrianEvent {
  final String strukId;
  OrderFinish(this.strukId);
}

class OrderFailure extends AntrianEvent {
  final UseStrukState data;
  final String reason;
  OrderFailure(this.data, {required this.reason});
}

///debug only, dont go production
class Delete extends AntrianEvent {
  final UseStrukState data;
  final String reason;
  Delete(this.data, {required this.reason});
}
