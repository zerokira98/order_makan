import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_makan/model/ingredient_model.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';

part 'menuedit_state.dart';

class MenueditCubit extends Cubit<MenueditState> {
  MenuItemRepository repo;
  MenueditCubit(this.repo) : super(MenueditState.initial());
  void addIngredients() {
    var data =
        state.ingredients.toList() + [IngredientItem(title: '', count: 0)];
    emit(state.copyWith(ingredients: data));
  }

  void clear() {
    emit(state.copyWith(ingredients: []));
  }

  void removeIngredient({required int index}) {
    var data = state.ingredients.toList();
    data.removeAt(index);
    emit(state.copyWith(ingredients: data));
  }

  void getIngredients(List<IngredientItem> ingredientItems) {
    emit(MenueditState(ingredients: ingredientItems));
  }

  void editIngredients({required int index, required IngredientItem data}) {
    var datalist = state.ingredients.toList();
    datalist[index] = data;
    emit(state.copyWith(ingredients: datalist));
  }
}
