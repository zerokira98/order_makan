part of 'antrian_bloc.dart';

@immutable
class AntrianState {
  final List<StrukState> antrianStruks;
  final Map? msg;
  const AntrianState({required this.antrianStruks, this.msg});
  AntrianState copywith(
      {List<StrukState>? antrianStruks, Map? Function()? msg}) {
    return AntrianState(
        antrianStruks: antrianStruks ?? this.antrianStruks,
        msg: msg != null ? msg() : this.msg);
  }
}
