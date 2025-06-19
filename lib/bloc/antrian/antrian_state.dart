part of 'antrian_bloc.dart';

@immutable
class AntrianState {
  final List<StrukState> antrianStruks;
  const AntrianState({required this.antrianStruks});
  AntrianState copywith({List<StrukState>? antrianStruks}) {
    return AntrianState(antrianStruks: antrianStruks ?? this.antrianStruks);
  }
}
