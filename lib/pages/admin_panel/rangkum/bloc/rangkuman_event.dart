part of 'rangkuman_bloc.dart';

sealed class RangkumanEvent extends Equatable {
  const RangkumanEvent();
  @override
  List<Object> get props => [];
}

///Default to current monthly
class InitiateRangkuman extends RangkumanEvent {
  final Map? err;

  const InitiateRangkuman({this.err});
}

class ChangeFilterRangkuman extends RangkumanEvent {
  final StrukFilter filter;

  const ChangeFilterRangkuman({required this.filter});
}
