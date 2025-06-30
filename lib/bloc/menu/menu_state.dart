part of 'menu_bloc.dart';

@immutable
class MenuState {
  final List<MenuItems> datas;

  final Map? msg;
  const MenuState({required this.datas, this.msg});

  MenuState copywith({List<MenuItems>? datas, Map? Function()? msg}) {
    return MenuState(
        datas: datas ?? this.datas, msg: msg != null ? msg() : this.msg);
  }
}
