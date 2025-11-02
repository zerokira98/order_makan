import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:order_makan/repo/firestore_kas.dart';
import 'package:order_makan/repo/strukrepo.dart';
import 'dart:convert';

part 'pengeluaran_state.dart';

class PengeluaranCubit extends Cubit<PengeluaranState> {
  KasRepository repo;
  PengeluaranCubit(this.repo) : super(PengeluaranState.empty);
  void initiate() {
    var now = DateTime.now();
    var initialfilter = StrukFilter(
        start: DateTime(now.year, now.month),
        end: DateTime(now.year, now.month + 1));
    repo
        .getPengeluaran(start: initialfilter.start!, end: initialfilter.end!)
        .then(
      (value) {
        emit(PengeluaranState(datas: value.docs, filter: initialfilter));
      },
    );
  }

  void changeFilter(StrukFilter filter) {
    if ((filter.start != null) && (filter.end != null)) {
      repo.getPengeluaran(start: filter.start!, end: filter.end!).then(
        (value) {
          emit(PengeluaranState(datas: value.docs, filter: filter));
        },
      );
    }
  }
}
