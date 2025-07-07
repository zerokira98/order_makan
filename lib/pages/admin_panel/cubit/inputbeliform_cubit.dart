import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:order_makan/model/ingredient_model.dart';

part 'inputbeliform_state.dart';

class InputbeliformCubit extends Cubit<InputbeliformState> {
  InputbeliformCubit() : super(InputbeliformState.initial());
  Future<void> initiate() async {
    emit(InputbeliformState.initial());
    await Future.delayed(Durations.extralong1);
    emit(InputbeliformState.initial());
  }

  void changeData(InputbeliformState data) async {
    emit(data);
  }

  void sendtoDB() {
    if (state.ingredientItem.id == null) {}
  }
}
