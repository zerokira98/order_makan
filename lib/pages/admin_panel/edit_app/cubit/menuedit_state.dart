// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'menuedit_cubit.dart';

class MenueditState extends Equatable {
  final List<IngredientItem> ingredients;
  const MenueditState({required this.ingredients});
  static MenueditState initial() => MenueditState(ingredients: []);

  MenueditState copyWith({
    List<IngredientItem>? ingredients,
  }) {
    return MenueditState(
      ingredients: ingredients ?? this.ingredients,
    );
  }

  @override
  List<Object> get props => ingredients;
}
