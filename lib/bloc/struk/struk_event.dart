part of 'struk_bloc.dart';

@immutable
abstract class StrukEvent {}

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

class SendtoDb extends StrukEvent {}
