part of 'struk_bloc.dart';

@immutable
abstract class StrukEvent {}

class AddOrderitems extends StrukEvent {
  final MenuItems item;
  AddOrderitems({required this.item});
}

class IncreaseCount extends StrukEvent {
  final MenuItems item;
  IncreaseCount({required this.item});
}

class DecreaseCount extends StrukEvent {
  final MenuItems item;
  DecreaseCount({required this.item});
}
