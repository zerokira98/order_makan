// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'pengeluaran_cubit.dart';

class PengeluaranState extends Equatable {
  final List<QueryDocumentSnapshot<Map<dynamic, dynamic>>> datas;
  final StrukFilter filter;
  const PengeluaranState({required this.datas, required this.filter});

  static PengeluaranState get empty =>
      PengeluaranState(datas: [], filter: StrukFilter());

  @override
  List<Object> get props => [datas, filter];

  PengeluaranState copyWith({
    List<QueryDocumentSnapshot<Map<dynamic, dynamic>>>? datas,
    StrukFilter? filter,
  }) {
    return PengeluaranState(
      datas: datas ?? this.datas,
      filter: filter ?? this.filter,
    );
  }

  @override
  bool get stringify => true;
}
