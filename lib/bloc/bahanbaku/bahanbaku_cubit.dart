import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:order_makan/model/ingredient_model.dart';
import 'package:order_makan/model/inputstock_model.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';
import 'package:order_makan/repo/strukrepo.dart';

part 'bahanbaku_state.dart';

class BahanbakuCubit extends Cubit<BahanbakuState> {
  MenuItemRepository repo;
  BahanbakuCubit(this.repo)
      : super(BahanbakuState.initial.copyWith(isLoading: true));
  void initiate() {
    var now = DateTime.now();
    var filter = StrukFilter(
        start: DateTime(now.year, now.month),
        end: DateTime(now.year, now.month + 1));
    (
      repo.getInputstocksWithFilter(start: filter.start!, end: filter.end!),
      repo.getStocks()
    ).wait.then(
      (value) {
        emit(BahanbakuState(value.$1.docs, value.$2.docs, filter,
            isLoading: false));
      },
    );
  }

  void changeDate(StrukFilter strukFilter) {
    emit(state.copyWith(isLoading: true));
    if (state != BahanbakuState.initial) {
      repo
          .getInputstocksWithFilter(
              start: strukFilter.start!, end: strukFilter.end!)
          .then(
        (value) {
          emit(state.copyWith(
              pembelian: value.docs, filter: strukFilter, isLoading: false));
        },
      );
    }
  }
}
