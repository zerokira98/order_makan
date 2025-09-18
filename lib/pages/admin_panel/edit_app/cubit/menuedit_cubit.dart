import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:order_makan/model/ingredient_model.dart';
import 'package:order_makan/model/submenuitem_model.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';

part 'menuedit_state.dart';

class MenueditCubit extends Cubit<MenueditState> {
  MenuItemRepository repo;
  MenueditCubit(this.repo) : super(MenueditState.initial());
  void addIngredients() {
    var data = state.ingredients.toList();
    var increment = data.isEmpty ? 0 : data.last.incrementindex ?? data.length;
    debugPrint(increment.toString());
    data.add(IngredientItem(
        title: '', count: 0, satuan: 'ml', incrementindex: increment + 1));
    emit(state.copyWith(ingredients: data));
  }

  void removeIngredient({required IngredientItem item}) {
    var data = state.ingredients
        .map(
          (e) => e.incrementindex == item.incrementindex ? null : e,
        )
        .nonNulls
        .toList();
    emit(state.copyWith(ingredients: data));
  }

  void initiate(MenueditState data) {
    var newingredient = data.ingredients.toList();
    for (var i = 0; i < data.ingredients.length; i++) {
      newingredient[i] = newingredient[i].copyWith(incrementindex: i);
    }
    emit(data.copyWith(ingredients: newingredient));
  }

  void editIngredients({required IngredientItem data}) {
    List<IngredientItem> datalist = state.ingredients
        .map(
          (e) => e.incrementindex == data.incrementindex ? data : e,
        )
        .nonNulls
        .toList();
    emit(state.copyWith(ingredients: datalist));
  }

  void removeSubmenu({int? cardId}) {
    var data = state.submenu
        .map(
          (e) => e.cardId == cardId ? null : e,
        )
        .nonNulls
        .toList();
    emit(state.copyWith(submenu: data));
  }

  void editSubmenu({required SubMenuItem data}) {
    var newdata = state.submenu
        .map(
          (e) => e.cardId == data.cardId ? data : e,
        )
        .nonNulls
        .toList();
    emit(state.copyWith(submenu: newdata));
  }

  void addSubmenu() {
    var data = state.submenu.toList();
    var increment = data.isEmpty ? 0 : data.last.cardId ?? data.length;
    debugPrint(increment.toString());
    data.add(SubMenuItem(
        title: '',
        cardId: increment + 1,
        adjustHarga: 0,
        adjustIngredient: []));
    emit(state.copyWith(submenu: data));
  }

  void removeSubmenuIngredients(
      {required SubMenuItem submenu, required IngredientItem data}) {
    var datalist = submenu.adjustIngredient
        .map((e) => e.incrementindex == data.incrementindex ? null : e)
        .nonNulls
        .toList();

    emit(state.copyWith(
        submenu: state.submenu
            .map((e) => e.cardId == submenu.cardId
                ? submenu.copyWith(adjustIngredient: datalist)
                : e)
            .toList()));
  }

  void editSubmenuIngredients(
      {required SubMenuItem submenu, required IngredientItem data}) {
    List<IngredientItem> datalist = submenu.adjustIngredient
        .map(
          (e) => e.incrementindex == data.incrementindex ? data : e,
        )
        .toList();
    emit(state.copyWith(
        submenu: state.submenu
            .map(
              (e) => e.cardId == submenu.cardId
                  ? submenu.copyWith(adjustIngredient: datalist)
                  : e,
            )
            .toList()));
  }

  void addSubmenuIngredients(SubMenuItem submenu) {
    var data = state.submenu.toList();
    var increment = submenu.adjustIngredient.isEmpty
        ? 0
        : submenu.adjustIngredient.last.incrementindex ??
            submenu.adjustIngredient.length;
    debugPrint(increment.toString());
    data = data
        .map(
          (e) => e.cardId == submenu.cardId
              ? e.copyWith(
                  adjustIngredient: e.adjustIngredient +
                      [
                        IngredientItem(
                            title: '',
                            count: 0,
                            satuan: 'ml',
                            incrementindex: increment + 1)
                      ])
              : e,
        )
        .toList();
    emit(state.copyWith(submenu: data));
  }

  void clear() {
    emit(state.copyWith(ingredients: []));
  }
}
