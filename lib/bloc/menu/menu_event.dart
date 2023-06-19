part of 'menu_bloc.dart';

@immutable
abstract class MenuEvent {}

class Init extends MenuEvent {}

class AddMenu extends MenuEvent {
  final MenuItems menu;
  AddMenu(this.menu);
}

class DelMenu extends MenuEvent {
  final MenuItems menu;
  DelMenu({required this.menu});
}

class ChangeCat extends MenuEvent {
  final String catName;
  ChangeCat({required this.catName});
}
