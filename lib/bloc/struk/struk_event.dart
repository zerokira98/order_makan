part of 'struk_bloc.dart';

@immutable
abstract class StrukEvent {}

class InitiateStruk extends StrukEvent {
  final String karyawanId;
  InitiateStruk({required this.karyawanId});
}

class AddOrderitems extends StrukEvent {
  final StrukItem item;
  AddOrderitems({required this.item});
}

class IncreaseCount extends StrukEvent {
  final StrukItem item;
  IncreaseCount({required this.item});
}

class DecreaseCount extends StrukEvent {
  final StrukItem item;
  DecreaseCount({required this.item});
}

class ClearErrMsg extends StrukEvent {
  // final StrukItem item;
  ClearErrMsg();
}

class SendtoDb extends StrukEvent {}

class DateUpdate extends StrukEvent {}

// final class _KaryawanUserChanged extends StrukEvent {
//   final User user;
//   const _KaryawanUserChanged(this.user);
// }
