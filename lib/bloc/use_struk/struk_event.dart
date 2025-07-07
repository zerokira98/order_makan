part of 'struk_bloc.dart';

@immutable
abstract class UseStrukEvent {}

class InitiateStruk extends UseStrukEvent {
  final String karyawanId;
  InitiateStruk({required this.karyawanId});
}

class ChangeCatatan extends UseStrukEvent {
  final StrukItem item;
  final String catatan;
  ChangeCatatan(this.catatan, this.item);
}

class AddOrderitems extends UseStrukEvent {
  final StrukItem item;
  AddOrderitems({required this.item});
}

class IncreaseCount extends UseStrukEvent {
  final StrukItem item;
  IncreaseCount({required this.item});
}

class ChangeCount extends UseStrukEvent {
  final StrukItem item;
  final int count;
  ChangeCount({required this.item, required this.count});
}

class ChangePembayaran extends UseStrukEvent {
  final TipePembayaran tipe;
  ChangePembayaran({required this.tipe});
}

class ChangeMeja extends UseStrukEvent {
  final int meja;
  ChangeMeja({required this.meja});
}

class DecreaseCount extends UseStrukEvent {
  final StrukItem item;
  DecreaseCount({required this.item});
}

class ClearErrMsg extends UseStrukEvent {
  // final StrukItem item;
  ClearErrMsg();
}

class SendtoDb extends UseStrukEvent {}

class DateUpdate extends UseStrukEvent {}

// final class _KaryawanUserChanged extends StrukEvent {
//   final User user;
//   const _KaryawanUserChanged(this.user);
// }
