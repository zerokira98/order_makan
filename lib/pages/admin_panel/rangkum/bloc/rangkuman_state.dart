// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'rangkuman_bloc.dart';

class RangkumanState extends Equatable {
  final List<UseStrukState> struks;
  final StrukFilter filter;
  final Map? errmsg;
  const RangkumanState(
      {required this.struks, required this.filter, this.errmsg});
  static RangkumanState get initial =>
      RangkumanState(struks: [], filter: StrukFilter());

  @override
  List<Object?> get props => [struks, filter, errmsg];

  RangkumanState copyWith({
    List<UseStrukState>? struks,
    StrukFilter? filter,
    Function? errmsg,
  }) {
    return RangkumanState(
      struks: struks ?? this.struks,
      filter: filter ?? this.filter,
      errmsg: errmsg != null ? errmsg() : this.errmsg,
    );
  }
}

// final class RangkumanInitial extends RangkumanState {}
