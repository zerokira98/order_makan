part of 'topbar_bloc.dart';

@immutable
abstract class TopbarEvent {}

class Init extends TopbarEvent {}

class AddCat extends TopbarEvent {
  final String name;
  AddCat({required this.name});
}

class DelCat extends TopbarEvent {
  final String name;
  DelCat({required this.name});
}

class ChangeSelection extends TopbarEvent {
  final String name;
  ChangeSelection({required this.name});
}
