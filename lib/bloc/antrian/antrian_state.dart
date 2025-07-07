part of 'antrian_bloc.dart';

@immutable
class AntrianState {
  final List<UseStrukState> antrianStruks;
  final bool isloading;
  final Map? msg;
  const AntrianState(
      {required this.antrianStruks, this.msg, this.isloading = false});
  AntrianState copywith(
      {List<UseStrukState>? antrianStruks,
      Map? Function()? msg,
      bool? isloading}) {
    return AntrianState(
        isloading: isloading ?? this.isloading,
        antrianStruks: antrianStruks ?? this.antrianStruks,
        msg: msg != null ? msg() : this.msg);
  }
}
