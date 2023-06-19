part of 'struk_bloc.dart';

class StrukState {
  final List<MenuItems> orderItems;
  final StrukError error;
  int totalPrice;
  StrukState({required this.orderItems, StrukError? error, int? totalPrice})
      : error = error ?? StrukError.empty(),
        totalPrice = totalPrice ?? 0;
  static StrukState initial() => StrukState(orderItems: []);
  StrukState copywith({List<MenuItems>? orderItems, int? totalPrice}) =>
      StrukState(
          orderItems: orderItems ?? this.orderItems,
          totalPrice: totalPrice ?? this.totalPrice);
}

class StrukError {
  int code;
  String msg;
  StrukError(this.code, this.msg);
  static StrukError empty() => StrukError(0, '');
  static StrukError existed(MenuItems items) => StrukError(1, items.title);
}
