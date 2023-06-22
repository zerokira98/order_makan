part of 'struk_bloc.dart';

class StrukState {
  final List<StrukItem> orderItems;
  final StrukError error;

  StrukState({required this.orderItems, StrukError? error})
      : error = error ?? StrukError.empty();
  static StrukState initial() => StrukState(orderItems: []);
  StrukState copywith({List<StrukItem>? orderItems, int? totalPrice}) =>
      StrukState(
        orderItems: orderItems ?? this.orderItems,
      );
}

class Diskon {
  String nama;
  String deskripsi;
  DateTime start;
  DateTime end;
  int potonganHarga;
  Diskon(this.nama, this.deskripsi, this.start, this.end, this.potonganHarga);
}

class StrukError {
  int code;
  String msg;
  StrukError(this.code, this.msg);
  static StrukError empty() => StrukError(0, '');
  static StrukError existed(StrukItem items) => StrukError(1, items.title);
}
