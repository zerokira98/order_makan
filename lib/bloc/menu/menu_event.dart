part of 'menu_bloc.dart';

@immutable
abstract class MenuEvent {}

class Init extends MenuEvent {
  final Map? msg;
  Init({this.msg});
}

class ClearMsg extends MenuEvent {}

class AddMenu extends MenuEvent {
  final MenuItems menu;
  AddMenu(this.menu);
}

class EditMenu extends MenuEvent {
  final MenuItems editedmenu;

  EditMenu(this.editedmenu);
}

class DelMenu extends MenuEvent {
  final MenuItems menu;
  DelMenu({required this.menu});
}

class ChangeTopbarCat extends MenuEvent {
  final String catName;
  ChangeTopbarCat({required this.catName});
}
