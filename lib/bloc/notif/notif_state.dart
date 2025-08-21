part of 'notif_cubit.dart';

class NotifState extends Equatable {
  final List<IngredientItem> notif;
  final List<IngredientItem> ingredients;
  const NotifState({required this.notif, required this.ingredients});
  static NotifState get initial => NotifState(notif: [], ingredients: []);

  @override
  List<Object> get props => [notif, ingredients];
}
