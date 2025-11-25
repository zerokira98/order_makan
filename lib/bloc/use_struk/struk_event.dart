part of 'struk_bloc.dart';

@immutable
abstract class UseStrukEvent {}

class InitiateStruk extends UseStrukEvent {
  final String karyawanId;
  final bool? success;
  InitiateStruk({required this.karyawanId, this.success});
}

class AddSubmenu extends UseStrukEvent {
  final StrukItem item;
  final SubMenuItem submenu;
  AddSubmenu(this.submenu, this.item);
}

class DeleteSubmenu extends UseStrukEvent {
  final StrukItem item;
  final SubMenuItem submenu;
  DeleteSubmenu(this.submenu, this.item);
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

// class ChangeAntrian extends UseStrukEvent {
//   final int antrian;
//   ChangeAntrian({required this.antrian});
// }

class ChangeDibayar extends UseStrukEvent {
  final int dibayar;
  ChangeDibayar({required this.dibayar});
}

class DecreaseCount extends UseStrukEvent {
  final StrukItem item;
  DecreaseCount({required this.item});
}

class ClearErrMsg extends UseStrukEvent {
  // final StrukItem item;
  ClearErrMsg();
}

class SendtoAntrianDB extends UseStrukEvent {}

class DateUpdate extends UseStrukEvent {}

// final class _KaryawanUserChanged extends StrukEvent {
//   final User user;
//   const _KaryawanUserChanged(this.user);
// }
