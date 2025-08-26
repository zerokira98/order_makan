// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'rangkuman_bloc.dart';

class RangkumanState extends Equatable {
  final List<UseStrukState> struks;
  final List pengeluaranKas;
  final List pengeluaranInputBahan;

  final StrukFilter filter;
  final Map? errmsg;
  const RangkumanState(
      {required this.pengeluaranInputBahan,
      required this.pengeluaranKas,
      required this.struks,
      required this.filter,
      this.errmsg});
  static RangkumanState get initial => RangkumanState(
      struks: [],
      filter: StrukFilter(),
      pengeluaranKas: [],
      pengeluaranInputBahan: []);

  @override
  List<Object?> get props =>
      [struks, pengeluaranKas, filter, errmsg, pengeluaranInputBahan];

  RangkumanState copyWith({
    List<UseStrukState>? struks,
    List? pengeluaranKas,
    List? pengeluaranInputBahan,
    StrukFilter? filter,
    Map? errmsg,
  }) {
    return RangkumanState(
      struks: struks ?? this.struks,
      pengeluaranKas: pengeluaranKas ?? this.pengeluaranKas,
      pengeluaranInputBahan:
          pengeluaranInputBahan ?? this.pengeluaranInputBahan,
      filter: filter ?? this.filter,
      errmsg: errmsg ?? this.errmsg,
    );
  }

  @override
  bool get stringify => true;
}

// final class RangkumanInitial extends RangkumanState {}
