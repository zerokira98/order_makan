part of 'antrian_bloc.dart';

@immutable
abstract class AntrianEvent {}

class InitiateAntrian extends AntrianEvent {
  final Map? msg;
  InitiateAntrian({this.msg});
}

class AddtoAntrian extends AntrianEvent {
  final StrukState data;
  AddtoAntrian(this.data);
}

class OrderFinish extends AntrianEvent {
  final String strukId;
  OrderFinish(this.strukId);
}

class OrderFailure extends AntrianEvent {
  final StrukState data;
  final String reason;
  OrderFailure(this.data, {required this.reason});
}

///debug only, dont go production
class Delete extends AntrianEvent {
  final StrukState data;
  Delete(
    this.data,
  );
}
