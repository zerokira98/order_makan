// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'pengeluaran_cubit.dart';

class PengeluaranState extends Equatable {
  final List<QueryDocumentSnapshot<Map<dynamic, dynamic>>> datas;
  final StrukFilter filter;
  final bool isLoading;
  const PengeluaranState(
      {required this.datas, required this.filter, this.isLoading = false});

  static PengeluaranState get empty =>
      PengeluaranState(datas: [], filter: StrukFilter());

  @override
  List<Object> get props => [datas, filter, isLoading];

  PengeluaranState copyWith({
    List<QueryDocumentSnapshot<Map<dynamic, dynamic>>>? datas,
    StrukFilter? filter,
    bool? isLoading,
  }) {
    return PengeluaranState(
        datas: datas ?? this.datas,
        filter: filter ?? this.filter,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  bool get stringify => true;
}
