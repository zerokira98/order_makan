import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:order_makan/model/ingredient_model.dart';
import 'package:order_makan/model/inputstock_model.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';

part 'inputbeliform_state.dart';

class InputbeliformCubit extends Cubit<InputbeliformState> {
  MenuItemRepository repo;
  InputbeliformCubit(this.repo) : super(InputbeliformState.initial());
  Future<void> initiate() async {
    emit(InputbeliformState.initial());
    await Future.delayed(Durations.extralong1);
    emit(InputbeliformState.initial());
  }

  void changeData(InputbeliformState data) async {
    emit(data);
  }

  void sendtoDB() async {
    String? ingredientId;
    if (state.ingredientItem.id == null) {
      ingredientId = await repo
          .addIngredients(state.ingredientItem
              .copyWith(title: state.ingredientItem.title.trim().toLowerCase()))
          .then(
            (value) => value.id,
          );
    } else {
      ingredientId =
          await repo.getIngredients(title: state.ingredientItem.title).then(
        (value) async {
          return value.single.id;
        },
      );
    }
    await repo.addInputstocks(InputstockModel(
        tanggalbeli: Timestamp.fromDate(state.tanggalbeli),
        title: state.nama,
        count: state.count,
        price: state.harga,
        tempatbeli: state.tempatbeli,
        units: '',
        asIngredient: state.ingredientItem.copyWith(
          id: () => ingredientId,
        )));
    initiate();
  }
}
