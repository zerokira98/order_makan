import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_makan/model/ingredient_model.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';

part 'notif_state.dart';

class NotifCubit extends Cubit<NotifState> {
  MenuItemRepository menurepo;

  late final StreamSubscription ingsubscription;
  NotifCubit(this.menurepo) : super(NotifState.initial) {
    ingsubscription = menurepo.ingredientRef.snapshots().listen(
      (event) {
        initiate();
      },
    );
  }
  @override
  Future<void> close() {
    ingsubscription.cancel();
    return super.close();
  }

  initiate() async {
    List<IngredientItem> notif = [];

    var ingredients = await menurepo.getIngredients();
    for (var e in ingredients) {
      if ((e.alert ?? 0) > e.count) {
        notif.add(e);
      }
    }
    emit(NotifState(notif: notif, ingredients: ingredients));
  }
}
